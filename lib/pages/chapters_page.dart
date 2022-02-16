import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_holy_bible/components/bible_select_dropdown.dart';
import 'package:my_holy_bible/database/bible_database_helper.dart';
import 'package:my_holy_bible/pages/verses_page.dart';

class ChaptersPage extends StatelessWidget {
  final dbHelper = BibleDatabaseHelper();
  final int bookId;
  final int totalNumberOfChapters;
  final String bookName;
  ChaptersPage(this.bookId, this.bookName, this.totalNumberOfChapters);

  chaptersBuilder() {
    return ListView.builder(
        itemCount: totalNumberOfChapters,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              ListTile(
                enabled: true,
                onTap: () {

                  Get.to(() => VersesPage(
                      bookId, bookName, (index + 1), totalNumberOfChapters));

                  //open chapter
                },
                title: Text(
                  "Chapter " + (index + 1).toString(),
                  style: GoogleFonts.ebGaramond(
                    fontSize: 18.0,
                  ),
                ),
              ),
              const Divider(
                height: 3.0,
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chapters",style: GoogleFonts.ebGaramond(
          fontSize: 20.0,
        )),
        actions: [BibleSelectDropDown()],
      ),
      body: chaptersBuilder(),
    );
  }
}
