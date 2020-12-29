import 'package:authsnow/User/login.dart';
import 'package:authsnow/screens/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'ad_show.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.black,
  ));
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var uid = prefs.getString('uid');
  var ad = Add();
  if (ad.showa) {
    ad.show();
  } else {
    ad.dispose();
  }

  print(ad.showa);
  runApp(MyApp(
    home: uid == null
        ? Login()
        : Home(
            id: uid,
          ),
  ));
}

class MyApp extends StatefulWidget {
  MyApp({Key key, this.home}) : super(key: key);
  final home;
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: widget.home,
    );
  }
}
