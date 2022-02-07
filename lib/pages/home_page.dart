import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:my_holy_bible/components/verse_of_day.dart';
import 'package:my_holy_bible/pages/books_page.dart';
import 'package:my_holy_bible/pages/notes/notes_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Holy Bible"),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Welcome",
              style: GoogleFonts.sacramento(
                fontSize: 40,
              ),
            ),
            Text(
              "Its been 3 days since your last visit",
              style: GoogleFonts.ebGaramond(fontSize: 18),
            ),
            Container(
              padding: const EdgeInsets.only(top: 20),
              margin: const EdgeInsets.only(top: 20),
              child: const VerseOfDay(),
            ),
            Container(
              margin: const EdgeInsets.only(top: 40),
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  shape: const StadiumBorder(),
                  side: const BorderSide(width: 1, color: Colors.black12),
                ),
                icon: const Icon(
                  MdiIcons.bookOpen,
                  size: 14,
                  color: Colors.black45,
                ),
                label: Text("Read Bible".toUpperCase(),
                    style: GoogleFonts.montserrat(
                        fontSize: 14, letterSpacing: 5, color: Colors.black)),
                onPressed: () {
                  Get.to(() => BooksPage());
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                top: 5,
              ),
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  shape: const StadiumBorder(),
                  side: const BorderSide(width: 1, color: Colors.black12),
                ),
                icon: const Icon(
                  MdiIcons.notebookEdit,
                  size: 14,
                  color: Colors.black45,
                ),
                label: Text("Notes".toUpperCase(),
                    style: GoogleFonts.montserrat(
                        fontSize: 14, letterSpacing: 5, color: Colors.black)),
                onPressed: () {
                  Get.to(() => NotesPage());
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
