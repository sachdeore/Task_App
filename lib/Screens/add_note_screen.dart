import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../database/database_helper.dart';
import '../models/note.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController =
  TextEditingController();

  int selectedColor = Colors.yellow.shade200.toARGB32();

  final List<Color> colors = [
    Colors.yellow.shade200,
    Colors.green.shade200,
    Colors.blue.shade200,
    Colors.orange.shade200,
    Colors.pink.shade200,
    Colors.purple.shade200,
    Colors.teal.shade200,
  ];

  Future<void> saveNote() async {
    if (titleController.text.trim().isEmpty ||
        descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter title and description"),
        ),
      );
      return;
    }

    String date =
    DateFormat("dd MMM yyyy").format(DateTime.now());

    Note note = Note(
      title: titleController.text,
      description: descriptionController.text,
      date: date,
      color: selectedColor,
    );

    await DatabaseHelper.instance.insertNote(note);

    if (!mounted) return;

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(selectedColor),

      appBar: AppBar(
        title: const Text("Add Note"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: "Title",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: descriptionController,
              maxLines: 6,
              decoration: const InputDecoration(
                labelText: "Description",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            Wrap(
              spacing: 10,
              children: colors.map((color) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedColor = color.toARGB32();
                    });
                  },
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: color,
                    child: selectedColor == color.toARGB32()
                        ? const Icon(
                      Icons.check,
                      color: Colors.black,
                    )
                        : null,
                  ),
                );
              }).toList(),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: saveNote,
                child: const Text(
                  "Save Note",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}