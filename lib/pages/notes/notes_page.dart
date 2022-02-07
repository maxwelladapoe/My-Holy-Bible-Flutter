import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:my_holy_bible/database/bible_database_helper.dart';
import 'package:my_holy_bible/pages/notes/create_note_page.dart';
import 'package:my_holy_bible/pages/notes/read_note_page.dart';
import '../../components/note_card_widget.dart';
import '../../models/note.dart';


class NotesPage extends StatefulWidget {
  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  late List<Note> notes;
  bool isLoading = false;
  final dbHelper = BibleDatabaseHelper();

  @override
  void initState() {
    super.initState();

    refreshNotes();
  }

  // @override
  // void dispose() {
  //   NotesDatabase.instance.close();
  //
  //   super.dispose();
  // }

  Future refreshNotes() async {
    setState(() => isLoading = true);

    notes = await dbHelper.getAllNotes();

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text(
        'Notes',
        style: TextStyle(fontSize: 24),
      ),
      actions: [Icon(Icons.search), SizedBox(width: 12)],
    ),
    body: Center(
      child: isLoading
          ? CircularProgressIndicator()
          : notes.isEmpty
          ? const Text(
        'No Notes',
        style: TextStyle(color: Colors.white, fontSize: 24),
      )
          : buildNotes(),
    ),
    floatingActionButton: FloatingActionButton(
      child: const  Icon(MdiIcons.notePlus),
      onPressed: () async {
        await Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => CreateNotePage()),
        );
        refreshNotes();
      },
    ),
  );

  Widget buildNotes() => MasonryGridView.count(
    crossAxisCount: 2,
    mainAxisSpacing: 2,
    crossAxisSpacing: 2,
    itemCount: notes.length,
    itemBuilder: (context, int index) {
      final note = notes[index];
        return GestureDetector(
        onTap: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => ReadNotePage()),
          );
          refreshNotes();
        },
        child: NoteCardWidget(note: note, index: index),
      );
    },
  );






}