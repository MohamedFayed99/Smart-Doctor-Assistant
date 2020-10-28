import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

const double _pacmanWidth = 21.0;
const double _sliderHorizontalMargin = 24.0;
const double _dotsLeftMargin = 8.0;

class PacmanSlider extends StatefulWidget {
  VoidCallback onSubmit;
  AnimationController animationController;

  PacmanSlider({this.onSubmit, this.animationController});

  @override
  _PacmanSliderState createState() => _PacmanSliderState();
}

class _PacmanSliderState extends State<PacmanSlider>
    with TickerProviderStateMixin {
  double _pacmanPosition = 24.0;
  AnimationController pacmanMovementController;
  Animation<BorderRadius> borderRadisAnimation;
  Animation<double> submitWidthAnimation;
  Animation<double> pacmanAnimation;

  double get width =>
      submitWidthAnimation.value ?? 0.0; //replace field with a getter

  @override
  void initState() {
    super.initState();
    pacmanMovementController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));

    /*
      start transition animation with changing slider’s borders to be more rounded.
      To do that, use BorderRadiusTween which will help us animating from one BorderRadius to another
     */
    borderRadisAnimation = BorderRadiusTween(
      //create BorderRadiusTween
      begin: BorderRadius.circular(8.0),
      end: BorderRadius.circular(50.0),
    ).animate(CurvedAnimation(
      parent: widget.animationController,
      /*
      Interval curve, which means that our border animation will not be run during whole 2 seconds
       */
      curve: Interval(0.0, 0.07), //specify interval from 0 to 7%
    ));
  }

  @override
  void dispose() {
    pacmanMovementController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      submitWidthAnimation = Tween<double>(
        begin: constraints.maxWidth, //start with maximum width
        end: ScreenUtil().setHeight(52.0), //finish with width equal to height
      ).animate(CurvedAnimation(
        parent:
            widget.animationController, //use the same animation controller...
        curve: Interval(
            0.05, 0.15), //... but in different time frame from border animation
      ));

      return AnimatedBuilder(
        /*
        AnimatedBuilder will take care of rebuilding the slider everytime AnimationController changes its value
         */
        animation: widget.animationController,
        builder: (context, child) {
          Decoration decoration = BoxDecoration(
            borderRadius: borderRadisAnimation.value,
            color: Theme.of(context).primaryColor,
          );

          return Center(
              child: Container(
            width: width, //use new animation width
            height: ScreenUtil().setHeight(52.0),
            decoration: decoration,
            child: submitWidthAnimation.isDismissed
                ? GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () =>
                        _animatePacmanToEnd(width: constraints.maxWidth),
                    child: Stack(
                      alignment: Alignment.centerRight,
                      children: <Widget>[
                        AnimatedDots(),
                        _drawDotCurtain(decoration,
                            width: constraints.maxWidth),
                        _drawPacman(width: constraints.maxWidth),
                      ],
                    ),
                  )
                : Container(),
          ));
        },
      );
    });
  }

  Widget _drawDotCurtain(Decoration decoration, {double width = 0.0}) {
    if (width == 0.0) {
      return Container();
    }
    double marginRight =
        width - _pacmanPosition - ScreenUtil().setHeight(_pacmanWidth / 2);
    return Positioned.fill(
      right: marginRight,
      child: Container(decoration: decoration),
    );
  }

  Widget _drawPacman({double width}) {
    if (pacmanAnimation == null && width != 0.0) {
      pacmanAnimation = _initPacmanAnimation(width);
    }
    return Positioned(
      left: _pacmanPosition,
      child: GestureDetector(
        onHorizontalDragUpdate: (details) => _onPacmanDrag(width, details),
        onHorizontalDragEnd: (details) => _onPacmanEnd(width, details),
        child: PacmanIcon(),
      ),
    );
  }

  Animation<double> _initPacmanAnimation(double width) {
    Animation<double> animation = Tween(
      begin: _pacmanMinPosition(),
      end: _pacmanMaxPosition(width),
    ).animate(pacmanMovementController);

    animation.addListener(() {
      setState(() {
        _pacmanPosition = animation.value;
      });
      if (animation.status == AnimationStatus.completed) {
        _onPacmanSubmited();
      }
    });
    return animation;
  }

  _onPacmanSubmited() {
    widget.onSubmit();
    Future.delayed(Duration(seconds: 1), () => _resetPacman());
  }

  _onPacmanDrag(double width, DragUpdateDetails details) {
    setState(() {
      _pacmanPosition += details.delta.dx;
      _pacmanPosition = math.max(_pacmanMinPosition(),
          math.min(_pacmanMaxPosition(width), _pacmanPosition));
    });
  }

  _onPacmanEnd(double width, DragEndDetails details) {
    bool isOverHalf =
        _pacmanPosition + ScreenUtil().setHeight(_pacmanWidth / 2) >
            0.5 * width;
    if (isOverHalf) {
      _animatePacmanToEnd(width: width);
    } else {
      _resetPacman();
    }
  }

  _animatePacmanToEnd({double width}) {
    pacmanMovementController.forward(
        from: _pacmanPosition / _pacmanMaxPosition(width));
  }

  _resetPacman() {
    setState(() => _pacmanPosition = _pacmanMinPosition());
  }

  double _pacmanMinPosition() =>
      ScreenUtil().setHeight(_sliderHorizontalMargin);

  double _pacmanMaxPosition(double sliderWidth) =>
      sliderWidth -
      ScreenUtil().setHeight(_sliderHorizontalMargin / 2 + _pacmanWidth);
}

class AnimatedDots extends StatefulWidget {
  @override
  _AnimatedDotsState createState() => _AnimatedDotsState();
}

class _AnimatedDotsState extends State<AnimatedDots>
    with SingleTickerProviderStateMixin {
  final int numberOfDots = 10;
  final double minOpacity = 0.1;
  final double maxOpacity = 0.5;
  AnimationController hintAnimationController;

  @override
  void initState() {
    super.initState();
    _initHintAnimationController();
    hintAnimationController.forward();
  }

  @override
  void dispose() {
    hintAnimationController?.dispose();
    super.dispose();
  }

  void _initHintAnimationController() {
    hintAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    hintAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(Duration(milliseconds: 800), () {
          hintAnimationController.forward(from: 0.0);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: ScreenUtil().setHeight(
            _sliderHorizontalMargin + _pacmanWidth + _dotsLeftMargin,
          ),
          right: ScreenUtil().setHeight(_sliderHorizontalMargin)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(numberOfDots, _generateDot)
          ..add(Opacity(
            opacity: maxOpacity,
            child: Dot(size: 14.0),
          )),
      ),
    );
  }

  Widget _generateDot(int dotNumber) {
    Animation animation = _initDotAnimation(dotNumber);
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) => Opacity(
        opacity: animation.value,
        child: child,
      ),
      child: Dot(size: 9.0),
    );
  }

  Animation<double> _initDotAnimation(int dotNumber) {
    double lastDotStartTime = 0.4;
    double dotAnimationDuration = 0.5;
    double begin = lastDotStartTime * dotNumber / numberOfDots;
    double end = begin + dotAnimationDuration;
    return SinusoidalAnimation(min: minOpacity, max: maxOpacity).animate(
      CurvedAnimation(
        parent: hintAnimationController,
        curve: Interval(begin, end),
      ),
    );
  }
}

class SinusoidalAnimation extends Animatable<double> {
  SinusoidalAnimation({this.min, this.max});

  final double min;
  final double max;

  @protected
  double lerp(double t) {
    return min + (max - min) * math.sin(math.pi * t);
  }

  @override
  double transform(double t) {
    return (t == 0.0 || t == 1.0) ? min : lerp(t);
  }
}

class Dot extends StatelessWidget {
  final double size;

  const Dot({Key key, @required this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(size),
      width: ScreenUtil().setHeight(size),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
    );
  }
}

class PacmanIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        right: ScreenUtil().setHeight(16.0),
      ),
      child: SvgPicture.asset(
        'assets/svg/pacman.svg',
        height: ScreenUtil().setHeight(25.0),
        width: ScreenUtil().setHeight(21.0),
      ),
    );
  }
}
