import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/note.dart';

class DatabaseHelper {
  DatabaseHelper._();

  static final DatabaseHelper instance = DatabaseHelper._();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbFolder = await getDatabasesPath();

    final path = join(dbFolder, "notes.db");

    print("Database Folder : $dbFolder");
    print("Database File   : $path");

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute("""
      CREATE TABLE notes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        date TEXT NOT NULL,
        color INTEGER NOT NULL
      )
    """);
  }

  // Insert Note
  Future<int> insertNote(Note note) async {
    final db = await database;

    return await db.insert(
      "notes",
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Read All Notes
  Future<List<Note>> getNotes() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(
      "notes",
      orderBy: "id DESC",
    );

    return maps.map((map) => Note.fromMap(map)).toList();
  }

  // Update Note
  Future<int> updateNote(Note note) async {
    final db = await database;

    return await db.update(
      "notes",
      note.toMap(),
      where: "id = ?",
      whereArgs: [note.id],
    );
  }

  // Delete Note
  Future<int> deleteNote(int id) async {
    final db = await database;

    return await db.delete(
      "notes",
      where: "id = ?",
      whereArgs: [id],
    );
  }

  // Delete All Notes
  Future<void> deleteAllNotes() async {
    final db = await database;

    await db.delete("notes");
  }

  // Close Database
  Future<void> closeDatabase() async {
    final db = await database;

    db.close();
  }
}