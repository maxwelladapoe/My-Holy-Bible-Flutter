import 'dart:io';
import 'package:flutter/services.dart';
import 'package:my_holy_bible/models/bible_book.dart';
import 'package:my_holy_bible/models/cross_reference_verses.dart';
import 'package:my_holy_bible/models/verses.dart';
import 'package:my_holy_bible/models/note.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class BibleDatabaseHelper {
  static Database? _db;

  Future<void> init() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "bibles_db.db");
    var exists = await databaseExists(path);
    if (!exists) {
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}
      ByteData data =
          await rootBundle.load(join("assets/databases/", "bibles_db.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes, flush: true);
    }
    _db = await openDatabase(path, readOnly: false, version: 2,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db.execute(
          'CREATE TABLE Notes (id INTEGER PRIMARY KEY,title String, body TEXT, created_at DATETIME, updated_at DATETIME)');
    });
  }

  Future<List<BibleBook>> getAllBibleBooks() async {
    if (_db == null) {
      print("db is not initiated yet, initiate using [init(db)] function");
    }
    List<Map> books = [];

    await _db?.transaction((txn) async {
      books = await txn.query("bible_books");
    });

    return books.map((e) => BibleBook.fromJson(e)).toList();
  }

  Future<List<Verse>> getChapterVersesForBook(
      bibleName, bookId, chapterNumber) async {
    List<Map> chapterVerses = [];

    await _db?.transaction((txn) async {
      chapterVerses = await txn.query("${bibleName}_bible_verses",
          where: 'chapter_number = ? and book_id=?',
          whereArgs: [chapterNumber, bookId]);
    });
    return chapterVerses.map((e) => Verse.fromJson(e)).toList();
  }

  highlightVerse(int verseID) async {
    var bibleNames = ['amp', 'kjv', 'msg', 'nkjv', 'niv'];
    await _db?.transaction((txn) async {
      bibleNames.forEach((name) {
        txn.rawUpdate(
            "UPDATE ${name}_bible_verses SET is_highlighted =? where id=?",
            [1, verseID]);
      });
    });
  }



  unHighlightVerse(int verseID) async {
    var bibleNames = ['amp', 'kjv', 'msg', 'nkjv', 'niv'];
    await _db?.transaction((txn) async {
      bibleNames.forEach((name) {
        txn.rawUpdate(
            "UPDATE ${name}_bible_verses SET is_highlighted =? where id=?",
            [0, verseID]);
      });
    });
  }

  Future<List<CrossReferenceVerse>> getAllCrossReferenceVerses(verseID) async {
    List<Map> crossReferenceVerses = [];

    await _db?.transaction((txn) async {
      crossReferenceVerses = await txn.rawQuery(
          "select cr.sv as start_verse, cr.ev as end_verse, cr.rank,bb.book_name, bv.* from cross_references cr, kjv_bible_verses bv, bible_books bb where cr.verse_id =? and bv.id >=cr.sv and bv.id <= cr.ev and bb.book_id=bv.book_id order by cr.rank asc"
      ,[verseID]);
    });
    return crossReferenceVerses.map((e) => CrossReferenceVerse.fromJson(e)).toList();
  }

  Future<List<Note>> getAllNotes() async {
    List<Map> notes = [];

    await _db?.transaction((txn) async {
      notes = await txn.query("notes");
    });

    return notes.map((e) => Note.fromJson(e)).toList();
  }

  Future<Note> insertNote(Note note) async {
    await _db?.transaction((txn) async {
      note.id = txn.insert("notes", note.toMap()).toString();
    });

    return note;
  }
}
