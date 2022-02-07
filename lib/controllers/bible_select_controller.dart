import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class BibleSelectController extends GetxController {
  var selectedBible = 'niv'.obs;
  final storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    selectedBible.value = storage.read('selectedBible') ?? 'niv';
    ever(
      selectedBible,
      (value) {
        storage.write('selectedBible', value);
      },
    );
  }

  setSelectedBible(bible) async {
    selectedBible(bible);
  }
}
