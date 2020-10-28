import 'package:assistant/animation/looped_size_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math' as math;

/*
  extending AnimatedWidget. It means that instead of wrapping the whole Widget in AnimatedBuilder,
  it will be rebuilt every time the animation from constructor changes its value.
*/
class TransitionDot extends AnimatedWidget {
  AnimationController animation;

  TransitionDot({Key key, Listenable animation})
      : super(key: key, listenable: animation);

  Animation<int> get positionAnimation => IntTween(
        begin: 0,
        end: 50,
      ).animate(
        CurvedAnimation(
          parent: super.listenable,
          curve: Interval(0.15, 0.3),
        ),
      );

  Animation<double> get sizeAnimation => LoopedSizeAnimation().animate(
        CurvedAnimation(
          parent: super.listenable,
          curve: Interval(0.3, 0.8),
        ),
      );

  @override
  Widget build(BuildContext context) {
    double scaledSize = ScreenUtil().setHeight(sizeAnimation.value);
    double deviceHeight =
        MediaQuery.of(context).size.height; //get device height
    double deviceWidth = MediaQuery.of(context).size.width; //get device width
    double height = math.min(scaledSize,
        deviceHeight); //make sure the height isn't bigger than the screen
    double width = math.min(scaledSize, deviceWidth); //same for width
    Decoration decoration = BoxDecoration(
      shape: width < 0.9 * deviceWidth
          ? BoxShape.circle
          : BoxShape.rectangle, //update shape
      color: Theme.of(context).primaryColor,
    );

    /*
       create a new dot widget. It will take place of the old slider,
       the idea is to make it appear in the same position the slider ended up after shrinking down.
     */

    Widget dot = Container(
      decoration: decoration,
      width: height,
      height: width,
    );

    /*
      wrap the whole widget inside IgnorePointer, so that it can cover the whole screen and not interact with all the controls
     */
    return IgnorePointer(
      /*
        specify the widget’s opacity. If animation is below 0.15 (the point where slider animation ends),
        opacity is set to 0, so we cannot see the widget, otherwise, we make it visible.
       */
      child: Opacity(
        opacity: positionAnimation.value > 0
            ? 1.0
            : 0.0, //check for positionAnimation
        // the actual widget is a Scaffold, same as the one from main but with a different body.
        child: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Spacer(flex: 104 - positionAnimation.value), //upper spacer
                dot,
                Spacer(flex: 4 + positionAnimation.value), //lower spacer
              ],
            ),
          ),
        ),
      ),
    );
  }
}
