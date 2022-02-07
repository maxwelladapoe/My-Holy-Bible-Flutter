import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:my_holy_bible/components/bible_select_dropdown.dart';
import 'package:my_holy_bible/controllers/bible_select_controller.dart';
import 'package:my_holy_bible/database/bible_database_helper.dart';

class VersesPage extends StatefulWidget {
  int bookId;
  String bookName;
  int chapterNumber;
  int totalNumberOfChapters;

  VersesPage(this.bookId, this.bookName, this.chapterNumber,
      this.totalNumberOfChapters, {Key? key}) : super(key: key);

  @override
  State<VersesPage> createState() => _VersesPageState();
}

class _VersesPageState extends State<VersesPage> {
  final dbHelper = BibleDatabaseHelper();

  String bibleName = 'niv';

  int hitBottomCount =0;
  ScrollController scrollController = ScrollController();



  void _scrollListener() {
    if (scrollController.position.extentAfter < 500) {
      setState(() {
        //items.addAll(List.generate(42, (index) => 'Inserted $index'));
      });
    }
  }


  @override
  void initState() {
    super.initState();
    scrollController = ScrollController()..addListener(_scrollListener);
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification) {

      if (scrollController.position.extentAfter == 0) {

        hitBottomCount++;
        if( hitBottomCount >=2){
          print("load more");
        }

      }else if(scrollController.position.extentBefore ==0){
        print("top");
      }else{
        hitBottomCount = 0;
      }
      print(hitBottomCount);


    }
    return false;
  }


  Widget versesBuilder() {
    BibleSelectController controller = Get.find();

    return GetX<BibleSelectController>(builder: (controller) {
      return FutureBuilder(
          future: dbHelper.getChapterVersesForBook(
              controller.selectedBible.value, widget.bookId, widget.chapterNumber),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              var allChapterVerses = snapshot.data;
              return NotificationListener<ScrollNotification>(
                onNotification: _handleScrollNotification,
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.only(top: 5),
                  itemCount: allChapterVerses.length,
                  itemBuilder: (BuildContext context, int index) {
                    var verseText = allChapterVerses[index].verse_text;
                    var verseNumber = allChapterVerses[index].verse_number;
                    return Column(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.only(
                              top: 3, left: 20, right: 20, bottom: 3),
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
                              ))
                            ],
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
        title: Text(widget.bookName + " " + widget.chapterNumber.toString()),
        actions: [
          const BibleSelectDropDown(),
          PopupMenuButton(
            icon: const Icon(MdiIcons
                .dotsVertical), //don't specify icon if you want 3 dot menu
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
        ],
      ),
      body: versesBuilder(),
    );
  }
}
