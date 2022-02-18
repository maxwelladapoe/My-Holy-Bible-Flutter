import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:my_holy_bible/models/cross_reference_verses.dart';

import '../database/bible_database_helper.dart';
import '../models/verses.dart';

class CrossReferencesPage extends StatefulWidget {
  Verse selectedVerse;

  String bookName;

  CrossReferencesPage(this.selectedVerse, [this.bookName = "Genesis"]);

  @override
  State<CrossReferencesPage> createState() => _CrossReferencesPageState();
}

class _CrossReferencesPageState extends State<CrossReferencesPage> {
  final dbHelper = BibleDatabaseHelper();

  List<CrossReferenceVerse> crossReferences = [];

  var previousRank = 0;

  var previousEndVerse = 0;

  @override
  Widget build(BuildContext context) {


    Widget versesBuilder() {
      return FutureBuilder(
          future: dbHelper.getAllCrossReferenceVerses(widget.selectedVerse.id),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {

              crossReferences = snapshot.data;
              if(crossReferences.length >0){
              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.only(top: 5),
                itemCount: crossReferences.length,
                itemBuilder: (BuildContext context, int index) {
                  CrossReferenceVerse verse = crossReferences[index];
                  var verseText = verse.verse_text;
                  var verseNumber = verse.verse_number;

                  return Column(
                    key: Key(verse.id.toString()),
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.only(
                            top: 3, left: 10, right: 10, bottom: 3),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(right: 3.0),
                              child: Text(
                                  '${verse.book_name} ${verse.chapter_number}:$verseNumber',
                                  style: GoogleFonts.ebGaramond(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red)),
                            ),
                            Text(
                              '$verseText',
                              style: GoogleFonts.ebGaramond(
                                fontSize: 18.0,
                              ),
                              textAlign: TextAlign.justify,
                            )
                          ],
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
           else {
             return Container(
               padding: EdgeInsets.only(top: 20),
               child: Text("There are no cross reference verses"),
             );
              }

            }
            return Container(
              child: CircularProgressIndicator(),
            );
          });
    }
    return Scaffold(
        appBar: AppBar(
          title: Text("Cross References",   style: GoogleFonts.ebGaramond(
            fontSize: 20.0,
          )),
        ),
        body: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Container(
            padding: EdgeInsets.only(left: 20, right: 20, top: 20),
            child: Column(
              children: [
                Container(
                  child: Column(
                    children: [
                      Text(
                          "${widget.bookName} ${widget.selectedVerse.chapter_number}:${widget.selectedVerse.verse_number}",
                      style: GoogleFonts.ebGaramond(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5),
                      Text(
                        widget.selectedVerse.verse_text,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.ebGaramond(fontSize: 18)
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
                Container(
                  child: versesBuilder(),
                )
              ],
            ),
          ),
        ));
  }
}
