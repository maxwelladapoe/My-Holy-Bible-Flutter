import 'package:get/get.dart';

class NotesController extends GetxController {
  var newNoteCreated = false.obs;

  setNewNoteCreated(success) async {
    newNoteCreated(success);
  }
}
