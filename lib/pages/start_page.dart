import 'package:assistant/pages/enter_page.dart';
import 'package:assistant/painters_and_clips/paint_1.dart';
import 'package:assistant/utils/consts.dart';
import 'package:assistant/widgets/the_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';

class StartPage extends StatelessWidget {
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
              left: 0,
              child: CustomPaint(
                painter: ShapesPainter(),
                child: Container(
                  height: size.height * .5,
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: CustomPaint(
                painter: ShapesPainter(
                  shapeCenter: Offset(0, 0),
                  raduis: 175,
                  color: secondColor,
                ),
                child: Container(
                  height: size.height * .5,
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: CustomPaint(
                painter: ShapesPainter(
                  shapeCenter: Offset(0, 0),
                  raduis: 130,
                  color: mainColor,
                ),
                child: Container(
                  height: size.height * .5,
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: CustomPaint(
                painter: ShapesPainter(
                  shapeCenter: Offset(0, 0),
                  raduis: 90,
                  color: Colors.deepPurple.withOpacity(.5),
                ),
                child: Container(
                  height: size.height * .5,
                ),
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
                    Text(
                      'اهلا بك في العيادة الذكية '
                          .toUpperCase()
                          .replaceAll(' ', '  '),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: mainColor,
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(13),
                    ),
                    Image.asset(
                      'assets/images/start_assistant.jpg',
                      width: size.width * .85,
                      height: size.height * .3,
                      fit: BoxFit.fill,
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(18),
                    ),
                    TheButton(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => EnterPage(),
                          ),
                        );
                      },
                      verticalPadding: 10,
                      title: 'بدء'.toUpperCase().replaceAll(' ', '  '),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
