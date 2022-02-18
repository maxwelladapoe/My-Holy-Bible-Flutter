import 'dart:convert';

class CrossReferenceVerse {
  final int start_verse;
  final int end_verse;
  final int rank;
  final int id;
  final int book_id;
  final String book_name;
  final int chapter_number;
  final int verse_number;
  final String verse_text;
  var is_highlighted;
  var highlighted_color;
  bool is_selected= false;

  CrossReferenceVerse(this.start_verse, this.end_verse, this.rank,this.id, this.book_id, this.book_name, this.chapter_number, this.verse_number,
      this.verse_text, [this.is_highlighted, this.highlighted_color]);
  factory CrossReferenceVerse.fromRawJson(String str) =>
      CrossReferenceVerse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CrossReferenceVerse.fromJson(Map<dynamic, dynamic> json) => CrossReferenceVerse(
      json["start_verse"],
      json["end_verse"],
      json["rank"],
      json["id"],
      json["book_id"],
      json["book_name"],
      json["chapter_number"],
      json["verse_number"],
      json["verse_text"],
      json["is_highlighted"],
      json["highlighted_color"]);

  Map<dynamic, dynamic> toJson() => {
        "start_verse": start_verse,
        "end_verse": end_verse,
        "rank": rank,
        "id": id,
        "book_id": book_id,
        "book_name": book_name,
        "chapter_number": chapter_number,
        "verse_number": verse_number,
        "verse_text": verse_text,
        "is_highlighted": is_highlighted,
        "highlighted_color": highlighted_color
      };

}
