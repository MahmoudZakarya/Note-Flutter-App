import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/database_helper.dart';



final DatabaseHelper _databaseHelper = DatabaseHelper();



class Note {
  final int? id;
  final String title;
  final String content;
  final List<String>? photos;
  final String? type;
  final String date;

  Note({
    this.id,
    required this.title,
    required this.content,
    this.photos,
    this.type,
    required this.date

});

  Map<String, dynamic> toMap(){
    return {
       "id":id,
       "title":title,
       "content":content,
       "photos":photos,
        "type":type,
       "date":date,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map){
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      photos: map['photos'],
      type: map['type'],
      date: map['date']
    );
  }

}


// StateNotifier to manage the list of notes
class NotesNotifier extends StateNotifier<List<Note>> {
  NotesNotifier() : super([]);

  // Fetch notes from SQLite database
  Future<void> loadNotes() async {
    // Replace with your SQLite fetch logic
    final List<Note> notes = await _databaseHelper.getNotes();
    state = notes.toList();
  }

  // Add or update a note
  Future<void> addOrUpdateNote(Note note) async {
    if (note.id == null ) {
      // Add new note to SQLite
      final newNoteId = await _databaseHelper.insertNote(note);


      final newNote = await _databaseHelper.getNoteById(newNoteId);

      state = [...state, newNote];
    } else {
      // Update existing note in SQLite
      await _databaseHelper.updateNote(note);
      state = state.map((n) => n.id == note.id ? note : n).toList();
    }
  }

  // Delete a note (optional)
  Future<void> deleteNote(int id) async {
    if(id == 0){ return;}
    else {
      await _databaseHelper.deleteNote(id);
      state = state.where((note) => note.id != id).toList();
    }

  }
}

// Provider for notes state
final notesProvider = StateNotifierProvider<NotesNotifier, List<Note>>((ref) {
  return NotesNotifier();
});
