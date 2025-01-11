import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/notes_model.dart';

class DatabaseHelper{
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper()=> _instance;
  DatabaseHelper._internal();

  Future<Database> get database async {
    if(_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'notes.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,

    );
  }

  Future<void> _onCreate(Database db, int version) async{
    await db.execute('''
      CREATE TABLE notes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        content TEXT,
        photos TEXT,
        type TEXT
        date TEXT
        )
    ''');
  }

  Future<int> insertNote(Note note) async {
    final db = await database;
    return await db.insert('notes', note.toMap());

  }

  Future<List<Note>> getNotes() async{
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('notes');
    return List.generate(maps.length, (i)=> Note.fromMap(maps[i]));
  }

  Future<Note> getNoteById(int id) async {
    final db = await database;
    final query = await db.query('notes',
      where: 'id = ?',
      whereArgs: [id],
    );

    final Note note = Note.fromMap(query[0]);

    return note;
  }

  Future<int> updateNote(Note note) async {
    final db = await database;
    return await db.update('notes', note.toMap(),
    where: 'id = ?',
    whereArgs: [note.id],
    );
  }

  Future<int> deleteNote(int id) async {
    final db = await database;
    return await db.delete('notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}