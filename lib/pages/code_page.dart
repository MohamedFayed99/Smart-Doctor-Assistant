import 'dart:math';

import 'package:assistant/painters_and_clips/paint_1.dart';
import 'package:assistant/utils/consts.dart';
import 'package:assistant/widgets/the_buttons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';

import 'home_page.dart';

class CodePage extends StatefulWidget {
  @override
  _CodePageState createState() => _CodePageState();
}

class _CodePageState extends State<CodePage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        child: Stack(
          children: <Widget>[
            Positioned(
              bottom: 0,
              right: 0,
              child: CustomPaint(
                painter: ShapesPainter(
                  color: Colors.orange,
                  raduis: 160,
                ),
                child: Container(),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              child: CustomPaint(
                painter: ShapesPainter(
                  shapeCenter: Offset(0, 0),
                  raduis: 110,
                ),
                child: Container(),
              ),
            ),
            Container(
              width: size.width,
              height: size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: ScreenUtil().setHeight(45),
                  ),
                  Image.asset(
                    'assets/images/app_icon.png',
                    width: size.width * .8,
                    height: size.height * .18,
                    fit: BoxFit.fill,
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(45),
                  ),
                  SelectableText(
                    'كود المريض: ${generatePatientCode()}',
                    enableInteractiveSelection: true,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: mainColor,
                    ),
                  ),
                  Text(
                    'رقم المريض: ${generatePatientNumber()}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: mainColor,
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(45),
                  ),
                  TheButton(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => HomePage(),
                        ),
                      );
                    },
                    borderRaduis: 0,
                    verticalPadding: 10,
                    title: 'انهاء'.toUpperCase().replaceAll(' ', '  '),
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(100),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> generatePatientCode() async{
    String patientCode='';

    final documentId = ModalRoute.of(context).settings.arguments;
    CollectionReference patients = FirebaseFirestore.instance.collection('patients');
    final result = await patients.doc(documentId).get();
    final patientData = result.data();
    final firstName = patientData['first name'].toString();
    final secondName = patientData['first name'].toString();
    final age = patientData['age'].toString();
    final height = patientData['height'].toString();
    patientCode ='${firstName.substring(0,1) + secondName.substring(0,1) + age + height}';

    return patientCode;
  }
  int generatePatientNumber(){
    Random random = Random();
    int randomNumber = random.nextInt(30);
    return randomNumber;
  }
}
