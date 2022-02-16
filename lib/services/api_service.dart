import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import '../models/remote_verse.dart';

class ApiService {
  final String base_url = "myholybible.wearepoe.com";

  getVerseOfDay() async {
    var url = Uri.https(base_url, '/verse_of_the_day');

    var response = await http.get(url);
    RemoteVerse verse;

    var decodedData = convert.jsonDecode(response.body);
    verse = RemoteVerse(
        decodedData['title'],
        decodedData['id'],
        decodedData['book_id'],
        decodedData['book_name'],
        decodedData['chapter_number'],
        decodedData['verse_number'],
        decodedData['verse_text']);
    List<RemoteVerse> versesList  = [];
    versesList.add(verse);
    return versesList;
  }
}
