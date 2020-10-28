import 'package:assistant/pages/base_info_page.dart';
import 'package:assistant/pages/start_page.dart';
import 'package:assistant/utils/consts.dart';
import 'package:assistant/widgets/TheTextFormFeild.dart';
import 'package:assistant/widgets/the_app_bar.dart';
import 'package:assistant/widgets/the_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  String patientCode;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBar(
        context: context,
        title: 'العيادة الذكية',
        leadingIcon: Icons.launch,
        onLeadingIconPressed: () {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (_) => StartPage(),
            ),
            (_) => false,
          );
        },
      ),
      body: Form(
        key: _formKey,
        child: Container(
          height: size.height,
          width: size.width,
          child: SingleChildScrollView(
            physics: scrollPhysics,
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                        color: secondColor,
                        border: Border.all(
                          width: 2,
                          color: secondColor,
                        )),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'مينا عاطف',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'اسم الدكتور',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: size.height * .05,
                  ),
                  Text(
                    'ادخل كود المريض لارساله الي الدكتور',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  TheTextFormField(
                    keyboardType: TextInputType.text,
                    borderRaduis: 3,
                    backgroundColor: orangeColor,
                    hint: 'كود المريض'.toUpperCase().replaceAll(' ', '  '),
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
                      patientCode = value;
                    },
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(18),
                  ),
                  TheButton(
                    verticalPadding: 10,
                    onTap: () {
                      if(_formKey.currentState.validate()){

                      }
                    },
                    borderRaduis: 0,
                    title: 'ادخال'.toUpperCase().replaceAll(
                          ' ',
                          '  ',
                        ),
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(50),
                  ),
                  TheButton(
                    backgroundColor: Colors.orange,
                    verticalPadding: 10,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => BaseInfoPage(),
                        ),
                      );
                    },
                    borderRaduis: 0,
                    title: 'انشاء حساب مريض'.toUpperCase().replaceAll(
                          ' ',
                          '  ',
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
