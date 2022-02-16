import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:my_holy_bible/database/bible_database_helper.dart';
import 'package:my_holy_bible/pages/home_page.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const GetMaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  // This widget is the root of your application.



  FirebaseMessaging messaging = FirebaseMessaging.instance;
  // NotificationSettings settings = await messaging.requestPermission(
  // alert: true,
  // announcement: false,
  // badge: true,
  // carPlay: false,
  // criticalAlert: false,
  // provisional: false,
  // sound: true,
  // );



  @override
  void initState() {
    firebaseCloudMessaging_Listeners();
    loadDb();

    super.initState();
  }


  void firebaseCloudMessaging_Listeners() {
    messaging.getToken().then((token){
      print(token);
    });

  }

  loadDb() async {
    await BibleDatabaseHelper().init();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}
