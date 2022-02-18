import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:my_holy_bible/components/verse_of_day.dart';
import 'package:my_holy_bible/pages/books_page.dart';
import 'package:my_holy_bible/pages/notes/notes_page.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../controllers/bible_select_controller.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
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
            GetX <BibleSelectController> (builder: (controller){
              if(controller.currentActiveDateTime.value.isNotEmpty){

                return Text(
                  "Its been ${timeago.format(DateTime.parse(controller.previousActiveDateTime.value))} since your last visit",
                  style: GoogleFonts.ebGaramond(fontSize: 18),
                );
              }else{
                return Container();
              }

            })
           ,
            Container(
              padding: const EdgeInsets.only(top: 20),
              margin: const EdgeInsets.only(top: 20),
              child:  VerseOfDay(),
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
