import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../database/database_helper.dart';
import '../models/note.dart';

class AddEditNoteScreen extends StatefulWidget {
  final Note? note;

  const AddEditNoteScreen({super.key, this.note});

  @override
  State<AddEditNoteScreen> createState() => _AddEditNoteScreenState();
}

class _AddEditNoteScreenState extends State<AddEditNoteScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController =
  TextEditingController();

  int selectedColor = Colors.yellow.shade200.value;

  final List<Color> colors = [
    Colors.yellow.shade200,
    Colors.blue.shade200,
    Colors.green.shade200,
    Colors.pink.shade200,
    Colors.orange.shade200,
    Colors.purple.shade200,
    Colors.teal.shade200,
  ];

  @override
  void initState() {
    super.initState();

    if (widget.note != null) {
      titleController.text = widget.note!.title;
      descriptionController.text = widget.note!.description;
      selectedColor = widget.note!.color;
    }
  }

  Future<void> saveNote() async {
    if (titleController.text.trim().isEmpty ||
        descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter title and description")),
      );
      return;
    }

    String date = DateFormat("dd MMM yyyy").format(DateTime.now());

    if (widget.note == null) {
      await DatabaseHelper.instance.insertNote(
        Note(
          title: titleController.text,
          description: descriptionController.text,
          date: date,
          color: selectedColor,
        ),
      );
    } else {
      await DatabaseHelper.instance.updateNote(
        Note(
          id: widget.note!.id,
          title: titleController.text,
          description: descriptionController.text,
          date: date,
          color: selectedColor,
        ),
      );
    }

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(selectedColor),

      appBar: AppBar(
        title: Text(
          widget.note == null ? "Add Note" : "Edit Note",
        ),
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
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: "Description",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Choose Color",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 10),

            Wrap(
              spacing: 10,
              children: colors.map((color) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedColor = color.value;
                    });
                  },
                  child: CircleAvatar(
                    backgroundColor: color,
                    radius: 18,
                    child: selectedColor == color.value
                        ? const Icon(Icons.check, color: Colors.black)
                        : null,
                  ),
                );
              }).toList(),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: saveNote,
                child: Text(
                  widget.note == null ? "Save Note" : "Update Note",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}