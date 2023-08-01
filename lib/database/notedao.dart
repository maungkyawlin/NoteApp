// dao/person_dao.dart

import 'package:floor/floor.dart';

import 'note_table.dart';


//note modelcontroller
@dao
abstract class NoteDao {
  @Query('select * from note ')
  Stream<List<Note>> getAllNotes();

  @insert
  Future<void> addNote(Note note);

  @delete
  Future<void> deleteNote(Note note);
  @update
  Future<void> updateNote(Note note);

  @delete
  Future<void> deleteAllNote(List<Note> notes);
}
