import 'dart:convert';

class BibleBook {
  final int book_id;
  final String book_name;
  final int number_of_chapters;
  final String abbreviation;

  BibleBook(
      this.book_id, this.book_name, this.number_of_chapters, this.abbreviation);
  factory BibleBook.fromRawJson(String str) =>
      BibleBook.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BibleBook.fromJson(Map<dynamic, dynamic> json) => BibleBook(
      json["book_id"],
      json["book_name"],
      json["number_of_chapters"],
      json["abbreviation"]);

  Map<dynamic, dynamic> toJson() => {
        "book_id": book_id,
        "book_name": book_name,
        "number_of_chapters": number_of_chapters,
        "abbreviation": abbreviation
      };
}
