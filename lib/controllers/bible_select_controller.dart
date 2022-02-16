import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:my_holy_bible/services/api_service.dart';
import '../models/remote_verse.dart';

class BibleSelectController extends GetxController {
  var selectedBible = 'niv'.obs;
  final storage = GetStorage();
  var memoryVerse = <RemoteVerse>[].obs ;

  @override
  void onInit() {
    super.onInit();
    getVerseOfTheDay();
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

  getVerseOfTheDay() async{
  //memoryVerse(await ApiService().getVerseOfDay());
    print("hello this is called");
    var  response  = await ApiService().getVerseOfDay();
    if (response !=null){
      memoryVerse.value = response;
    }
  }
}
