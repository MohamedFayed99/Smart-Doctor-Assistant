import 'package:assistant/pages/code_page.dart';
import 'package:assistant/painters_and_clips/paint_1.dart';
import 'package:assistant/utils/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class WaitingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final documentId = ModalRoute.of(context).settings.arguments;
    Future.delayed(
      Duration(seconds: 4),
      () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => CodePage(),
            settings: RouteSettings(
              arguments: documentId,
            ),
          ),
        );
      },
    );

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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/images/app_icon.png',
                    width: size.width * .8,
                    height: size.height * .18,
                    fit: BoxFit.fill,
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(45),
                  ),
                  Center(
                    child: SpinKitHourGlass(
                      color: mainColor,
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(45),
                  ),
                  Text(
                    '... جاري انشاء الحساب',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: mainColor,
                    ),
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
}
