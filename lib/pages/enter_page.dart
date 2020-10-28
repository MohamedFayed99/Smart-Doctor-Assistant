import 'package:assistant/pages/home_page.dart';
import 'package:assistant/painters_and_clips/paint_1.dart';
import 'package:assistant/utils/consts.dart';
import 'package:assistant/widgets/TheTextFormFeild.dart';
import 'package:assistant/widgets/the_buttons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';

class EnterPage extends StatefulWidget {
  @override
  _EnterPageState createState() => _EnterPageState();
}

class _EnterPageState extends State<EnterPage> {
  final _formKey = GlobalKey<FormState>();
  String phone;
  String password;
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
              SingleChildScrollView(
                physics: scrollPhysics,
                child: Container(
                  height: size.height,
                  width: size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: ScreenUtil().setHeight(13),
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
                      TheTextFormField(
                        borderRaduis: 3,
                        keyboardType: TextInputType.text,
                        hint: 'كود الدكتور'.toUpperCase().replaceAll(' ', '  '),
                        backgroundColor: Colors.orange.withOpacity(.5),
                        width: size.width * .9,
                        prefixIcon: Icon(
                          Icons.code,
                          color: mainColor,
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          phone = value;
                        },
                      ),
                      TheTextFormField(
                        keyboardType: TextInputType.number,
                        borderRaduis: 3,
                        backgroundColor: Colors.orange.withOpacity(.5),
                        hint: 'كلمة المرور'.toUpperCase().replaceAll(' ', '  '),
                        width: size.width * .9,
                        prefixIcon: Icon(
                          Icons.lock,
                          color: mainColor,
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          password = value;
                        },
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(18),
                      ),
                      TheButton(
                        onTap: () async {
                            if(_formKey.currentState.validate()){
                              try {
                                  _formKey.currentState.save();
                                 final result = await FirebaseFirestore.instance.collection('doctors')
                                  .doc('H0jl9zYbmaVONbpaHdFp').get();
                                 final doctorData = result.data();
                                 print(doctorData);
                                 if(doctorData['phone'] != phone || doctorData['password'] != password){
                                   scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(
                                     'Phone or Password is wrong'
                                   )));
                                 } else {
                                   Navigator.of(context).push(
                                       MaterialPageRoute(builder:(_) => HomePage() )
                                   );
                                 }

                              } catch (e) {
                                print(e.toString());
                              }
                            }
//
                        },
                        borderRaduis: 0,
                        verticalPadding: 10,
                        title: 'دخول'.toUpperCase().replaceAll(' ', '  '),
                      ),
                    ],
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
