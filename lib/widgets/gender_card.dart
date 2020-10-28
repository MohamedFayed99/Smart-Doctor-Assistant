import 'package:assistant/utils/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math' as math;
import 'package:flutter_svg/flutter_svg.dart';

import 'card_title.dart';

// ! this page is responsable for displaying components that appears in gender section (card)

// user gender type
enum GenderType { male, female, other }

// the body of gender card
class GenderCard extends StatefulWidget {
  @override
  GenderType initialGender;
  ValueChanged<GenderType> onChange;
  GenderCard({this.initialGender = GenderType.male, this.onChange});

  _GenderCardState createState() => _GenderCardState();
}

class _GenderCardState extends State<GenderCard>
    with SingleTickerProviderStateMixin {
  AnimationController arrowAnimationController;

  // var to switch between genders
  GenderType selectedGender;

  String get getSelectedGenderType => this.selectedGender.toString();

  @override
  void initState() {
    super.initState();
    selectedGender = widget.initialGender ??
        GenderType
            .male; // if no gender selected make the default selection is 'other'

    arrowAnimationController = AnimationController(
        vsync: this,
        lowerBound: -defaultGenderAngle, // -45
        upperBound: defaultGenderAngle, // 45
        value: genderAngles[selectedGender]);
  }

  @override
  void dispose() {
    arrowAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: orangeColor,
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.only(top: ScreenUtil().setHeight(8)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CardTitle(
                title: 'النوع',
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: ScreenUtil().setHeight(12),
                ),
                child: _drawMainStack(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // draw main stack which will hold the center circle, icons, and switcher
  Widget _drawMainStack() {
    return Container(
      width: double.infinity,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          _drawCircleIndicators(),
          GenderIconTranslated(
            genderType: GenderType.female,
          ),
          GenderIconTranslated(
            genderType: GenderType.male,
          ),
//          GenderIconTranslated(
//            genderType: GenderType.other,
//          ),
          _drawGestureDetector(),
        ],
      ),
    );
  }

  Widget _drawGestureDetector() {
    // we use Positioned.fill to make TapHandler fill the whole stack
    return Positioned.fill(
      child: TapHandler(
        onGenderTapped: _setSelectedGender,
      ),
    );
  }

  void _setSelectedGender(GenderType type) {
    setState(() {
      selectedGender = type;
      widget.onChange(type);
    });
    arrowAnimationController.animateTo(genderAngles[type],
        duration: Duration(milliseconds: 200));
  }

  Widget _drawCircleIndicators() {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        GenderCircle(),
        GenderArrow(listenable: arrowAnimationController),
      ],
    );
  }
}

// center circle
double _circleSize = ScreenUtil().setHeight(80);

class GenderCircle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: _circleSize,
      height: _circleSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color.fromRGBO(244, 244, 244, 1.0),
      ),
    );
  }
}

// ? Draw gender icons
// ! There are three gender icons, each above (فوق) the circle but with a different angle.
// ! To place them in the right spots we need to move them to the center of the circle,
// ! then rotate, then move outside the circle and then rotate again to straighten them up.
// ! We will also draw small lines between icons and the circle.

// First draw lines between gender icons
class GenderLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: ScreenUtil().setHeight(8), bottom: ScreenUtil().setHeight(6)),
      child: Container(
        height: ScreenUtil().setHeight(8),
        width: 1,
        color: Colors.grey[800],
      ),
    );
  }
}

// The default angle is the angle between the middle gender icon and side ones and it is equal to 45 degrees (or pi/4).
const double defaultGenderAngle = math.pi / 4;

// We store angles for each gender outside the widget because we will reuse it when drawing an indicator arrow
const Map<GenderType, double> genderAngles = {
  GenderType.male: defaultGenderAngle, // +45
  GenderType.female: -defaultGenderAngle, // -45
  GenderType.other: 0.0,
};

/*
How we build the widget:
1- Draw svg icon.
2- Rotate it in the opposite direction to where it will be placed.
3- Add a line below the icon (with paddings).
4- Rotate icon with a line in the target direction (at this point icon is straight again but the line remained rotated in the desired direction).
5- Lift “base” of the widget up half the size of the circle. This will make all icons look like they are centered around the middle of the circle.
*/
class GenderIconTranslated extends StatelessWidget {
  Map<GenderType, String> genderImages = {
    GenderType.female: 'assets/svg/female.svg',
    GenderType.male: 'assets/svg/male.svg',
    GenderType.other: 'assets/svg/other.svg',
  };

  GenderType genderType;

  // pass the gender type in the constructor to make arrow point to it
  GenderIconTranslated({this.genderType});

  bool get isOtherGender => genderType == GenderType.other;

  String get imageName => genderImages[genderType];

  double iconSize() {
    return ScreenUtil().setHeight(isOtherGender ? 25 : 20);
  }

  double genderLeftPadding() {
    return ScreenUtil().setHeight(isOtherGender ? 8 : 0);
  }

  @override
  Widget build(BuildContext context) {
    // 1- Draw svg icon.
    Widget icon = Padding(
      padding: EdgeInsets.only(left: genderLeftPadding()),
      child: SvgPicture.asset(
        imageName,
        height: iconSize(),
        width: iconSize(),
      ),
    );

    // 2- Rotate it in the opposite direction to where it will be placed.
    Widget rotatedIcon = Transform.rotate(
      angle: genderAngles[genderType],
      child: icon,
    );

    // 3- Add a line below the icon (with paddings).
    Widget iconWithLine = Padding(
      padding: EdgeInsets.only(bottom: _circleSize / 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          rotatedIcon,
          GenderLine(),
        ],
      ),
    );

    // 4- Rotate icon with a line in the target direction
    Widget rotatedIconWithLine = Transform.rotate(
      alignment: Alignment.bottomCenter,
      angle: genderAngles[genderType],
      child: iconWithLine,
    );

    // This will make all icons look like they are centered around the middle of the circle.
    Widget centerIconWithLine = Padding(
      padding: EdgeInsets.only(bottom: _circleSize / 2),
      child: rotatedIconWithLine,
    );

    return centerIconWithLine;
  }
}

// ? Build gender arrow
/*
Those are operations performed to get the arrow:
1- Draw an svg image.
2- Since the image is rotated by default, we want to rotate it back so that arrow is pointing towards the middle.
3- We move (translate) an arrow so that it is “pinned” to the center of the screen.
4- We rotate arrow to the angle provided in the constructor.
*/
class GenderArrow extends AnimatedWidget {
  double arrowLength() => ScreenUtil().setHeight(42);

  double translationOffset() => arrowLength() * -.4;

  const GenderArrow({Key key, Listenable listenable})
      : super(key: key, listenable: listenable);

  @override
  Widget build(BuildContext context) {
    Animation animation = listenable;
    return Transform.rotate(
      angle: animation.value,
      child: Transform.translate(
        offset: Offset(0.0, translationOffset()),
        child: Transform.rotate(
          angle: -defaultGenderAngle,
          child: SvgPicture.asset(
            'assets/svg/gender_arrow.svg',
            height: arrowLength(),
            width: arrowLength(),
          ),
        ),
      ),
    );
  }
}

// ? Handle tapping
// finally allow the user to change the gender on tap
// becouse the icons are small in size so tapping on it will be difficult
// the easiest solution is to split the gender card into 3 equal columns,
// each assigned to one gender. This way it will be easy for the user to change the gender

class TapHandler extends StatelessWidget {
  final Function(GenderType) onGenderTapped;

  TapHandler({this.onGenderTapped});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
          child: GestureDetector(
            onTap: () => this.onGenderTapped(GenderType.female),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () => this.onGenderTapped(GenderType.other),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () => this.onGenderTapped(GenderType.male),
          ),
        )
      ],
    );
  }
}

// ? Animation
// The last part is to animate the arrow movement.
// We will do it by creating an AnimationController in GenderCard and passing it to the GenderArrowwidget
