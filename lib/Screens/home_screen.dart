import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../models/note.dart';
import '../widgets/note_card.dart';
import 'add_edit_note_screen.dart';
import 'add_note_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Note> notes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadNotes();
  }

  Future<void> loadNotes() async {
    notes = await DatabaseHelper.instance.getNotes();

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });
  }

  Future<void> deleteNote(int id) async {
    await DatabaseHelper.instance.deleteNote(id);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Note Deleted Successfully"),
        backgroundColor: Colors.red,
      ),
    );

    loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor: Colors.white,

      appBar: AppBar(
        elevation: 0,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "📝 My Notes",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),

        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF833AB4),
                Color(0xFFFD1D1D),
                Color(0xFFFCB045),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),

        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
        ],
      ),

      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : notes.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.sticky_note_2_outlined,
              size: 100,
              color: Colors.grey,
            ),
            SizedBox(height: 20),
            Text(
              "No Notes Yet",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Tap the + button to add your first note.",
              style: TextStyle(
                fontSize: 16,
                color: Colors.blueGrey,
              ),
            ),
          ],
        ),
      )
          : RefreshIndicator(
        onRefresh: loadNotes,
        child: ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: notes.length,
          itemBuilder: (context, index) {
            return NoteCard(
              note: notes[index],

              onEdit: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddEditNoteScreen(
                      note: notes[index],
                    ),
                  ),
                );

                loadNotes();
              },

              onDelete: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    title: const Text("Delete Note"),
                    content: const Text(
                      "Are you sure you want to delete this note?",
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Cancel"),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          deleteNote(notes[index].id!);
                        },
                        child: const Text(
                          "Delete",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF833AB4),
        foregroundColor: Colors.white,
        elevation: 8,
        icon: const Icon(Icons.add),
        label: const Text("Add Note"),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddNoteScreen(),
            ),
          );

          loadNotes();
        },
      ),
    );
  }
}