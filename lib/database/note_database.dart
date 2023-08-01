//database.dart;

// required package imports

import 'dart:async';

import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'note_table.dart';
import 'notedao.dart';

part "note_database.g.dart"; // the generated code will be there
//repository
@Database(version: 1, entities: [Note])
abstract class NoteDatabase extends FloorDatabase {
  NoteDao get noteDao;
}
