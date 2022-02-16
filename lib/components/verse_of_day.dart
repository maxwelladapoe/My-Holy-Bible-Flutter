import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_holy_bible/controllers/bible_select_controller.dart';

class VerseOfDay extends StatelessWidget {
  final BibleSelectController bibleSelectController = Get.put(BibleSelectController());
  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.80,
            child: Card(
              child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Verse of day".toUpperCase(),
                        style: GoogleFonts.montserrat(
                            fontSize: 10, letterSpacing: 5),
                      ),
                      Obx((){

                        var verseOfTheDay= bibleSelectController.memoryVerse[0];

                        return    Container(
                          padding: const EdgeInsets.only(top: 20),
                          child: Column(
                            children: [
                              Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  child: Text(
                                    (verseOfTheDay.verse_text.isNotEmpty ?verseOfTheDay.verse_text:
                                    "Do not let your hearts be troubled. You believe in God; believe also in me."),
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.ebGaramond(
                                      fontSize: 18,
                                    ),
                                  )),
                              Text(
                                verseOfTheDay.title.isNotEmpty ? verseOfTheDay.title: "John 14:1",
                                style: GoogleFonts.ebGaramond(
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        );
                      })

                    ],
                 )
              ),
            )));
  }
}
