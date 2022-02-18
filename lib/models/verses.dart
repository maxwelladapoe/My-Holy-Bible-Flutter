import 'dart:convert';

class Verse {
  final int id;
  final int book_id;
  final int chapter_number;
  final int verse_number;
  final String verse_text;
  var is_highlighted;
  var highlighted_color;
  bool is_selected= false;

  Verse(this.id, this.book_id, this.chapter_number, this.verse_number,
      this.verse_text, [this.is_highlighted, this.highlighted_color]);
  factory Verse.fromRawJson(String str) =>
      Verse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Verse.fromJson(Map<dynamic, dynamic> json) => Verse(
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
