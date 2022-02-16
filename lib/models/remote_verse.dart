import 'dart:convert';

class RemoteVerse {
  final int id;
  final int book_id;
  final int chapter_number;
  final int verse_number;
  final String verse_text;
  final String book_name;
  final String title;

  RemoteVerse(this.title, this.id, this.book_id, this.book_name,
      this.chapter_number, this.verse_number, this.verse_text);

  factory RemoteVerse.fromRawJson(String str) =>
      RemoteVerse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RemoteVerse.fromJson(Map<dynamic, dynamic> json) => RemoteVerse(
      json["title"],
      json["id"],
      json["book_id"],
      json["book_name"],
      json["chapter_number"],
      json["verse_number"],
      json["verse_text"]);

  Map<dynamic, dynamic> toJson() => {
        "title": title,
        "id": id,
        "book_id": book_id,
        "book_name": book_name,
        "chapter_number": chapter_number,
        "verse_number": verse_number,
        "verse_text": verse_text,
      };
}
