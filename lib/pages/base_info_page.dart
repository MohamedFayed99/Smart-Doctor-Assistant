import 'package:assistant/pages/height_gender_weight_page.dart';
import 'package:assistant/painters_and_clips/paint_1.dart';
import 'package:assistant/utils/consts.dart';
import 'package:assistant/widgets/TheTextFormFeild.dart';
import 'package:assistant/widgets/the_buttons.dart';
import 'package:assistant/widgets/weight_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';

class BaseInfoPage extends StatefulWidget {
  @override
  _BaseInfoPageState createState() => _BaseInfoPageState();
}

class _BaseInfoPageState extends State<BaseInfoPage> {
  bool sugre = false;
  bool pressure = false;
  final _formKey = GlobalKey<FormState>();
  String firstName;
  String secondName;
  int age;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: scaffoldKey,
      body: Form(
        key: _formKey,
        child: Container(
          width: size.width,
          height: size.height,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Positioned(
                bottom: 0,
                right: 0,
                child: CustomPaint(
                  painter: ShapesPainter(),
                  child: Container(
                    height: size.height * .5,
                  ),
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
                  child: Container(
                    height: size.height * .5,
                  ),
                ),
              ),
              SafeArea(
                child: SingleChildScrollView(
                  physics: scrollPhysics,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: ScreenUtil().setHeight(70),
                        ),
                        Text('انشاء حساب مريض جديد'),
                        SizedBox(
                          width: ScreenUtil().setWidth(10),
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: TheTextFormField(
                                borderRaduis: 3,
                                keyboardType: TextInputType.text,
                                hint: 'الاسم الثاني'
                                    .toUpperCase()
                                    .replaceAll(' ', '  '),
                                backgroundColor: Colors.orange.withOpacity(.5),
                                width: size.width * .9,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  secondName = value;
                                },
                              ),
                            ),
                            SizedBox(
                              width: ScreenUtil().setWidth(10),
                            ),
                            Expanded(
                              child: TheTextFormField(
                                keyboardType: TextInputType.text,
                                borderRaduis: 3,
                                backgroundColor: Colors.orange.withOpacity(.5),
                                hint: 'الاسم الاول'
                                    .toUpperCase()
                                    .replaceAll(' ', '  '),
                                width: size.width * .9,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  firstName = value;
                                },
                              ),
                            ),
                          ],
                        ),
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: CheckboxListTile(
                            value: sugre,
                            title: Text('مريض بالسكر ؟'),
                            subtitle:
                                Text(sugre ? 'مريض بالسكر' : 'ليس مريضا بالسكر'),
                            onChanged: (bool val) {
                              sugre = val;
                              setState(() {});
                            },
                          ),
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(18),
                        ),
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: CheckboxListTile(
                            value: pressure,
                            title: Text('مريض بالضغط ؟'),
                            subtitle: Text(
                                pressure ? 'مريض بالضغط' : 'ليس مريضا بالضغط'),
                            onChanged: (bool val) {
                              pressure = val;
                              setState(() {});
                            },
                          ),
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(15),
                        ),
                        Container(
                          width: size.width,
                          height: size.height * .25,
                          child: WeightCard(
                            initialValue: 20,
                            valuesHeight: 60,
                            title: 'العمر',
                            value: '(سنة)',
                            onChage: (value) {
                              age = value;
                            },
                          ),
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(50),
                        ),
                        TheButton(
                          onTap: () async {
                            if(_formKey.currentState.validate()){
                              try{
                                _formKey.currentState.save();
                                DocumentReference patient = FirebaseFirestore.instance.collection('patients').doc();
                                  await patient.set({
                                  'first name': firstName,
                                  'second name' : secondName,
                                  'age' : age,
                                  'has sugar' : sugre,
                                  'has pressure' : pressure,
                                }).then((value) => print("Patient Added"))
                                    .catchError((error) => print("Failed to add Patient: $error"));
                                 print(patient.id);
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => HeightGenderWeightPage(),
                                      settings: RouteSettings(
                                        arguments: patient.id,
                                      ),
                                  )
                                );
                              } catch(e){
                                scaffoldKey.currentState.showSnackBar(SnackBar(
                                  content: Text('Something went wrong'),
                                ));
                              }
                            }

                          },
                          borderRaduis: 0,
                          verticalPadding: 10,
                          title: 'التالي'.toUpperCase().replaceAll(' ', '  '),
                        ),
                        SizedBox(
                          height: ScreenUtil().setHeight(50),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 45,
                left: 5,
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
