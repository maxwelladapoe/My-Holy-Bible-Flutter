import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:my_holy_bible/services/api_service.dart';
import '../models/remote_verse.dart';

class BibleSelectController extends GetxController {
  var selectedBible = 'niv'.obs;
  final storage = GetStorage();
  var memoryVerse = <RemoteVerse>[].obs ;
  var isLoadingVerseOfDay = true.obs;
  var previousActiveDateTime = "".obs;
  var currentActiveDateTime = "".obs;

  @override
  void onInit() {
    super.onInit();
    getVerseOfTheDay();
    selectedBible.value = storage.read('selectedBible') ?? 'niv';

    previousActiveDateTime.value = storage.read('currentActiveDateTime')?? DateTime.now().toString();
    currentActiveDateTime.value =   DateTime.now().toString();

    ever(
      selectedBible,
      (value) {
        storage.write('selectedBible', value);
      },
    );


    ever(
      currentActiveDateTime,
          (value) {
        storage.write('currentActiveDateTime', value);
      },
    );

  }

  setSelectedBible(bible) async {
    selectedBible(bible);
  }

  getVerseOfTheDay() async{

    try{
      isLoadingVerseOfDay(true);
      var  response  = await ApiService().getVerseOfDay();
      if (response !=null){
        isLoadingVerseOfDay(false);
        memoryVerse.value = response;
      }else{
        isLoadingVerseOfDay(false);
      }
    } finally{
      isLoadingVerseOfDay(false);
    }

  }
}
