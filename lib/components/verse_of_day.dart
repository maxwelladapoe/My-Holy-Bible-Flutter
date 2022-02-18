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

                        var isLoading = bibleSelectController.isLoadingVerseOfDay;

                        if(isLoading.value){
                          print(isLoading);
                          return  Container(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircularProgressIndicator(),
                                Padding(padding: EdgeInsets.only(top: 10),
                                child:  Text("loading the verse of the day"),)

                              ],
                            ) ,

                          );
                        }else{
                          var verseOfTheDay= bibleSelectController.memoryVerse[0];
                          return    Container(
                            padding: const EdgeInsets.only(top: 20),
                            child: Column(
                              children: [
                                Container(
                                    margin: const EdgeInsets.only(bottom: 10),
                                    child: Text(
                                      verseOfTheDay.verse_text,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.ebGaramond(
                                        fontSize: 18,
                                      ),
                                    )),
                                Text(
                                  verseOfTheDay.title,
                                  style: GoogleFonts.ebGaramond(
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          );
                        }


                      })

                    ],
                 )
              ),
            )));
  }
}
