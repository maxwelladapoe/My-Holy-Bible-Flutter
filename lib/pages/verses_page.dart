import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:my_holy_bible/components/bible_select_dropdown.dart';
import 'package:my_holy_bible/controllers/bible_select_controller.dart';
import 'package:my_holy_bible/database/bible_database_helper.dart';
import 'package:my_holy_bible/models/verses.dart';
import 'package:my_holy_bible/pages/cross_references_page.dart';
import 'package:share_plus/share_plus.dart';

class VersesPage extends StatefulWidget {
  int bookId;
  String bookName;
  int chapterNumber;
  int totalNumberOfChapters;

  VersesPage(this.bookId, this.bookName, this.chapterNumber,
      this.totalNumberOfChapters,
      {Key? key})
      : super(key: key);

  @override
  State<VersesPage> createState() =>
      VersesPageState(bookId, bookName, chapterNumber, totalNumberOfChapters);
}

enum TtsState { playing, stopped, paused, continued }

class VersesPageState extends State<VersesPage> {
  int bookId;
  String bookName;
  int chapterNumber;
  int totalNumberOfChapters;
  final FlutterTts flutterTts = FlutterTts();

  VersesPageState(this.bookId, this.bookName, this.chapterNumber,
      this.totalNumberOfChapters);

  final dbHelper = BibleDatabaseHelper();
  String bibleName = 'niv';
  int hitBottomCount = 0;
  ScrollController scrollController = ScrollController();
  bool isSelectMode = false;
  var selectedVerses = [];
  var allChapterVerses = [];

  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;

  get isStopped => ttsState == TtsState.stopped;

  get isPaused => ttsState == TtsState.paused;

  get isContinued => ttsState == TtsState.continued;

  @override
  void initState() {
    super.initState();
    flutterTts.setLanguage('en');
    flutterTts.setSpeechRate(0.4);
    scrollController = ScrollController()..addListener(_scrollListener);
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    if (scrollController.position.extentAfter < 500) {
      setState(() {
        //items.addAll(List.generate(42, (index) => 'Inserted $index'));
      });
    }
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification) {
      if (scrollController.position.extentAfter == 0) {
        hitBottomCount++;
        if (hitBottomCount >= 2) {
          print("load more");
        }
      } else if (scrollController.position.extentBefore == 0) {
        print("top");
      } else {
        hitBottomCount = 0;
      }
      print(hitBottomCount);
    }
    return false;
  }

  addVerseToSelectedVerses(verse) {
    setState(() {
      if (selectedVerses.contains(verse.id)) {
        selectedVerses.remove(verse.id);
      } else {
        selectedVerses.add(verse.id);
      }

      if (selectedVerses.length == 0) {
        isSelectMode = false;
      }
    });
  }

  String getSelectedVersesAsString([textToSpeech = false]) {
    var verses = [];
    selectedVerses.sort();
    selectedVerses.forEach((verseID) {
      var verse =
          allChapterVerses.firstWhere((element) => element.id == verseID);
      verses.add(verse);
    });
    var firstVerse = verses.first;
    var lastVerse = verses.last;
    var stringTitle = "";
    var stringBody = "";
    if (verses.length > 1) {
      if (!textToSpeech) {
        stringTitle =
            "${bookName} ${chapterNumber}:${firstVerse.verse_number}-${lastVerse.verse_number}"
                .trim();
      } else {
        stringTitle =
            "${bookName} chapter ${chapterNumber} verse ${firstVerse.verse_number} to ${lastVerse.verse_number}."
                .trim();
      }
    } else {
      if (!textToSpeech) {
        stringTitle =
            "${bookName} ${chapterNumber}:${firstVerse.verse_number}".trim();
      } else {
        stringTitle =
            "${bookName} chapter ${chapterNumber} verse ${firstVerse.verse_number}."
                .trim();
      }
    }
    verses.forEach((element) {
      stringBody += " ${element.verse_text}";
    });
    stringBody = stringBody.trim();

    return "$stringTitle\n$stringBody";
  }

  bookmarkSelectedVerses() {
    selectedVerses.sort();
    selectedVerses.forEach((verseID) {
     dbHelper.highlightVerse(verseID);
      allChapterVerses.firstWhere((element) => element.id == verseID).is_highlighted = 1;

    });
    setState(() {
      isSelectMode = false;
      selectedVerses.clear();
    });
  }


  unBookmarkSelectedVerses() {
    selectedVerses.sort();
    selectedVerses.forEach((verseID) {
      dbHelper.unHighlightVerse(verseID);
      allChapterVerses.firstWhere((element) => element.id == verseID).is_highlighted = 0;
    });
    setState(() {
      isSelectMode = false;
      selectedVerses.clear();
    });
  }

  buildActions() {
    var actions = [
      const BibleSelectDropDown(),
      PopupMenuButton(
        icon: const Icon(
            MdiIcons.dotsVertical), //don't specify icon if you want 3 dot menu
        color: Colors.blue,
        itemBuilder: (context) => [
          const PopupMenuItem<int>(
            value: 0,
            child: Text(
              "Setting",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
        onSelected: (item) => {print(item)},
      ),
    ];

    if (isSelectMode) {
      Widget showBookMark() {
        //check if the selected verse is highlighted
        Verse oneVerse = allChapterVerses
            .firstWhere((element) => element.id == selectedVerses[0]);
        if (selectedVerses.length == 1 && oneVerse.is_highlighted ==1) {
          return IconButton(
            onPressed: () {
              unBookmarkSelectedVerses();
            },
            icon: Icon(MdiIcons.bookmarkMinus),
            iconSize: 20,
          );
        } else {
          return IconButton(
            onPressed: () {
              bookmarkSelectedVerses();
            },
            icon: Icon(MdiIcons.bookmarkPlus),
            iconSize: 20,
          );
        }
      }

      actions = [
        IconButton(
          onPressed: () {
            Clipboard.setData(
                    new ClipboardData(text: getSelectedVersesAsString()))
                .then((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Verse copied to clipboard")));
            });
          },
          icon: Icon(MdiIcons.contentCopy),
          iconSize: 20,
        ),
        IconButton(
          onPressed: () {
            Share.share(getSelectedVersesAsString());
          },
          icon: Icon(MdiIcons.shareVariant),
          iconSize: 20,
        ),
        showBookMark(),
        selectedVerses.length ==1 ?
        IconButton(
          onPressed: () {
            Verse verseToCross = allChapterVerses
                .firstWhere((element) => element.id == selectedVerses[0]);
            Get.to(()=>CrossReferencesPage(verseToCross, bookName));
            setState(() {
              isSelectMode = false;
              selectedVerses.clear();
            });
          },
          icon: Icon(MdiIcons.bookOpenPageVariant),
          iconSize: 20,
        ):Container(),
        IconButton(
          onPressed: () {
            flutterTts.speak(getSelectedVersesAsString(true));
          },
          icon: Icon(MdiIcons.textToSpeech),
          iconSize: 20,
        )
      ];
    }

    return actions;
  }

  Widget versesBuilder() {
    return GetX<BibleSelectController>(builder: (controller) {
      return FutureBuilder(
          future: dbHelper.getChapterVersesForBook(
              controller.selectedBible.value,
              widget.bookId,
              widget.chapterNumber),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              allChapterVerses = snapshot.data;
              return NotificationListener<ScrollNotification>(
                onNotification: _handleScrollNotification,
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.only(top: 5),
                  itemCount: allChapterVerses.length,
                  itemBuilder: (BuildContext context, int index) {
                    var verse = allChapterVerses[index];
                    var verseText = verse.verse_text;
                    var verseNumber = verse.verse_number;

                    return Column(
                      key: Key(verse.id.toString()),
                      children: <Widget>[
                        GestureDetector(
                          onLongPress: () {
                            //initiate select mode and add first item
                            if (!isSelectMode) {
                              setState(() {
                                isSelectMode = true;
                                addVerseToSelectedVerses(verse);
                              });
                            }
                          },
                          onTap: () {
                            if (isSelectMode) {
                              addVerseToSelectedVerses(verse);
                              setState(() {
                                verse.is_selected = true;
                              });
                            }
                          },
                          child: Container(
                            color: (selectedVerses.contains(verse.id))
                                ? Colors.greenAccent
                                : Colors.transparent,
                            padding: const EdgeInsets.only(
                                top: 3, left: 10, right: 10, bottom: 3),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(right: 3.0),
                                  child: Text('$verseNumber',
                                      style: GoogleFonts.ebGaramond(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red)),
                                ),
                                Expanded(
                                    child: Text(
                                  '$verseText',
                                  style: GoogleFonts.ebGaramond(
                                    fontSize: 18.0,
                                  ),
                                  textAlign: TextAlign.justify,
                                )),
                                verse.is_highlighted ==1 ? Container(
                                  child: Icon(MdiIcons.bookmark, color: Colors.red, size: 22.0),
                                ): Container()
                              ],
                            ),
                          ),
                        ),
                        const Divider(
                          height: 3.0,
                        ),
                      ],
                    );
                  },
                ),
              );
            }
            return Container();
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.bookName + " " + widget.chapterNumber.toString(),
            style: GoogleFonts.ebGaramond(
              fontSize: 20.0,
            )),
        actions: buildActions(),
      ),
      body: versesBuilder(),
    );
  }
}
