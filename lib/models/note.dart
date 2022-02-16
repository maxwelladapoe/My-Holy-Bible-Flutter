import 'dart:convert';

class Note {
  String? id;
  String title;
  String body;
  String? created_at;
  String? updated_at;

  Note(this.title, this.body, [this.created_at, this.updated_at]);

  factory Note.fromRawJson(String str) => Note.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Note.fromJson(Map<dynamic, dynamic> json) =>
      Note(json["title"], json["body"], json["created_at"],  json["updated_at"]);

  Map<dynamic, dynamic> toJson() => {
        "id": id,
        "title": title,
        "body": body,
        "created_at": created_at,
        "updated_at": updated_at,
      };

  Map<String, Object> toMap() {
    var map = <String, Object>{"title": title, "body": body};

    if (id != null) {
      map["id"] = id!;
    }
    if (created_at == null) {
      map["created_at"] = DateTime.now().toString();
    }

    map["updated_at"] = DateTime.now().toString();
    return map;
  }
}
