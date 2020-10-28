import 'package:assistant/pages/start_page.dart';
import 'package:assistant/utils/consts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appName,
      theme: ThemeData(
        backgroundColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
        accentColor: mainColor,
        fontFamily: 'Cairo',
      ),
      home: TheApp(),
    );
  }
}

class TheApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      allowFontScaling: true,
    );
    return StartPage();
  }
}
