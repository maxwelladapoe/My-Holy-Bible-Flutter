import 'dart:convert';

class ChapterVerses {
  final int id;
  final int book_id;
  final int chapter_number;
  final int verse_number;
  final String verse_text;
  var is_highlighted;
  var highlighted_color;

  ChapterVerses(this.id, this.book_id, this.chapter_number, this.verse_number,
      this.verse_text, this.is_highlighted, this.highlighted_color);
  factory ChapterVerses.fromRawJson(String str) =>
      ChapterVerses.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ChapterVerses.fromJson(Map<dynamic, dynamic> json) => ChapterVerses(
      json["id"],
      json["book_id"],
      json["chapter_number"],
      json["verse_number"],
      json["verse_text"],
      json["is_highlighted"],
      json["highlighted_color"]);

  Map<dynamic, dynamic> toJson() => {
        "id": id,
        "book_id": book_id,
        "chapter_number": chapter_number,
        "verse_number": verse_number,
        "verse_text": verse_text,
        "is_highlighted": is_highlighted,
        "highlighted_color": highlighted_color
      };
}
