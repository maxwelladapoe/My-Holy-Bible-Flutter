import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:my_holy_bible/controllers/notes_controller.dart';
import 'package:my_holy_bible/database/bible_database_helper.dart';
import 'package:my_holy_bible/models/note.dart';


class CreateNotePage extends StatelessWidget {

  final noteTitleController = TextEditingController();
  final noteContentController = TextEditingController();

  final dbHelper = BibleDatabaseHelper();

  void _showToast(BuildContext context, message) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(message),
        // action: SnackBarAction(label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final NotesController notesStateController = Get.put<NotesController>( NotesController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("New Note"),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextFormField(
                style:  const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                ),
              controller: noteTitleController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
              hintText: 'Title',

            ),
              validator: (title) =>
              title != null && title.isEmpty ? 'The title cannot be empty' : null),

             Expanded(
                child: TextFormField(
                  controller: noteContentController,
              textAlignVertical: TextAlignVertical.top,
                  decoration: const  InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Type something...',
                  ),
              expands: true,
              maxLines: null,
              keyboardType: TextInputType.multiline,
            ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {

          if(noteTitleController.text.isNotEmpty && noteContentController.text.isNotEmpty){
            var note = Note(noteTitleController.text, noteContentController.text);
            dbHelper.insertNote(note);

            _showToast(context,"Note added successfully");
            Get.back();
          }else{
            _showToast(context,"Please provide a title and content for your note");
          }

        },
        backgroundColor: Colors.green,
        child: const Icon(MdiIcons.contentSave),
      ),
    );
  }
}
