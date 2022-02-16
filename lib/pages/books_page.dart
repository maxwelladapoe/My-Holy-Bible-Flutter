import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_holy_bible/components/bible_select_dropdown.dart';
import 'package:my_holy_bible/database/bible_database_helper.dart';
import 'package:my_holy_bible/models/bible_book.dart';
import 'package:my_holy_bible/pages/chapters_page.dart';

class BooksPage extends StatelessWidget {
  final dbHelper = BibleDatabaseHelper();

  List<BibleBook> allBooks = [];

  BooksPage({Key? key}) : super(key: key);

  bookBuilder(books) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 5),
      itemCount: books.length,
      itemBuilder: (BuildContext context, int index) {
        var bookName = books[index].book_name;
        var numChapters = books[index].number_of_chapters;
        var textChapters = numChapters.toString() +
            " " +
            (numChapters == 1 ? 'Chapter' : 'Chapters');

        var bookId = books[index].book_id;



        return Column(
          children: <Widget>[
            ListTile(
              enabled: true,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ChaptersPage(bookId, bookName, numChapters)));
              },
              contentPadding:
                  const EdgeInsets.only(top: 5, left: 20, right: 20),
              title: Text(
                '$bookName',
                style: GoogleFonts.ebGaramond(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                '$textChapters',
                style: GoogleFonts.ebGaramond(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(
              height: 3.0,
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var bBook = FutureBuilder(
        future: dbHelper.getAllBibleBooks(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            var oldTestamentBooks = [];
            var newTestamentBooks = [];
            allBooks = snapshot.data;

            int count = 1;
            for (var element in allBooks) {
              if (count <= 39) {
                oldTestamentBooks.add(element);
              } else {
                newTestamentBooks.add(element);
              }
              count++;
            }

            var oldTestament = bookBuilder(oldTestamentBooks);
            var newTestament = bookBuilder(newTestamentBooks);

            return DefaultTabController(
              length: 2,
              child: Scaffold(
                appBar: AppBar(
                  title:  Text('My Holy Bible', style: GoogleFonts.ebGaramond(
                    fontSize: 20.0,
                  )),
                  actions: [BibleSelectDropDown()],
                  bottom: TabBar(
                    onTap: (index) {
                      // Tab index when user select it, it start from zero
                    },
                    tabs: [
                      Container(
                          padding: const EdgeInsets.only(bottom: 8, top: 8),
                          child: const Text("Old Testament")),
                      Container(
                          padding: const EdgeInsets.only(bottom: 8, top: 8),
                          child: const Text("New Testament"))
                    ],
                  ),
                ),
                body: TabBarView(
                  children: [
                    Center(child: oldTestament),
                    Center(child: newTestament),
                  ],
                ),
              ),
            );
          }
          return Container();
        });

    return bBook;
  }
}
