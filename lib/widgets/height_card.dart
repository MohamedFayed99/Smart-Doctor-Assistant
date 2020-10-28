import 'package:assistant/utils/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:math' as math;

import 'card_title.dart';

class HeightCard extends StatefulWidget {
  final int height;
  final ValueChanged<int> onChanged;

  HeightCard({
    Key key,
    this.height = 170,
    this.onChanged,
  }) : super(key: key);

  @override
  _HeightCardState createState() => _HeightCardState();
}

class _HeightCardState extends State<HeightCard> {
  int height;

  @override
  void initState() {
    super.initState();
    height = widget.height ?? 170;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: orangeColor,
      child: Padding(
        padding: EdgeInsets.only(top: ScreenUtil().setHeight(8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CardTitle(
              title: 'الطول',
              subtitle: '(سم)',
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: ScreenUtil().setHeight(8),
                ),

                /*
                we will have to work a lot on the (( widget’s actual height )). To view that height, we will use LayoutBuilder.
                LayoutBuilder gives us access to view constraints (dimentions) so that we can use the widget’s height.
                */

                child: LayoutBuilder(
                  builder: (context, constriants) {
                    return HeightPicker(
                      height: height,
                      widgetHeight: constriants.maxHeight,
                      onHeightChanged: (newHeight) {
                        widget.onChanged(newHeight);
                        setState(() {
                          this.height = newHeight;
                        });
                      },
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class HeightPicker extends StatefulWidget {
  final int height;
  final double widgetHeight;
  final ValueChanged<dynamic> onHeightChanged;
  final int minHeight;
  final int maxHeight;

  HeightPicker({
    this.height,
    this.maxHeight = 200, // max height
    this.minHeight = 115, // min height
    this.onHeightChanged,
    this.widgetHeight,
  });

  int get totalUnit => maxHeight - minHeight;

  @override
  _HeightPickerState createState() => _HeightPickerState();
}

// ? Labels on the right
// start with displaying labels on the right.
// We want them to be evenly distributed and to display values from minHeight to maxHeight incremented by 5.

class _HeightPickerState extends State<HeightPicker> {
  double startDragYOffset;
  int startDragHeight;

  // calculate pixels between each unit will be used in drwaing the picture
  double get _pixelsPerUnit => _drawingHeight / widget.totalUnit;

  // حدود الرسم
  // المسافة اللي فوق واللي تحت وحجم الخط
  // returns actual height of slider to be able to slide
  double get _drawingHeight {
    double totalHeight = widget.widgetHeight;
    double marginBottom = marginBottomAdapted();
    double marginTop = marginTopAdapted();
    return totalHeight - (marginBottom + marginTop + 13.0);
  }

  // calculate silder position
  double get _sliderPosition {
    double halfOfBottomLabel = 13.0 / 2;
    int unitsFromBottom = widget.height - widget.minHeight;
    return halfOfBottomLabel + unitsFromBottom * _pixelsPerUnit;
  }

  @override
  Widget build(BuildContext context) {
    // stack to display many widgets above each other
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onVerticalDragStart: _onDragStart,
      onVerticalDragUpdate: _onDragUpdate,
      onTapDown: (details) {
        int height = _globalOffsetToHeight(details.globalPosition);
        widget.onHeightChanged(_normalizeHeight(height));
      },
      child: Stack(
        children: <Widget>[
          _drawPersonImage(),
          _drawSlider(),
          _drawLabels(),
        ],
      ),
    );
  }

  _onDragStart(DragStartDetails dragStartDetails) {
    int newHeight = _globalOffsetToHeight(dragStartDetails.globalPosition);
    widget.onHeightChanged(newHeight);
    setState(() {
      startDragYOffset = dragStartDetails.globalPosition.dy;
      startDragHeight = newHeight;
    });
  }

  _onDragUpdate(DragUpdateDetails dragUpdateDetails) {
    double currentYOffset = dragUpdateDetails.globalPosition.dy;
    double verticalDifference = startDragYOffset - currentYOffset;
    int diffHeight = verticalDifference ~/ _pixelsPerUnit;
    int height = _normalizeHeight(startDragHeight + diffHeight);
    setState(() => widget.onHeightChanged(height));
  }

  int _normalizeHeight(int height) {
    return math.max(widget.minHeight, math.min(widget.maxHeight, height));
  }

  int _globalOffsetToHeight(Offset globalOffset) {
    RenderBox getBox = context.findRenderObject();
    Offset localPosition = getBox.globalToLocal(globalOffset);
    double dy = localPosition.dy;
    dy = dy - marginTopAdapted() - 13.0 / 2;
    int height = widget.maxHeight - (dy ~/ _pixelsPerUnit);
    return height;
  }

  // ? drawPersonImage
  Widget _drawPersonImage() {
    double personImageHeight = _sliderPosition + marginBottomAdapted();
    return Align(
      alignment: Alignment.bottomCenter,
      child: SvgPicture.asset(
        "assets/svg/person.svg",
        height: personImageHeight,
        width: personImageHeight / 3,
      ),
    );
  }

  Widget _drawSlider() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: _sliderPosition,
      child: HeightSlider(height: widget.height),
    );
  }

  Widget _drawLabels() {
    // calculate how many labels (number) to display
    int labelsToDisplay = widget.totalUnit ~/ 5 + 1;

    // generate these numbers
    List<Widget> numbers = List.generate(labelsToDisplay, (index) {
      return Text(
        '${widget.maxHeight - 5 * index}',
        style: TextStyle(
          color: secondColor,
          fontSize: 13.0,
        ),
      );
    });

    return Align(
        alignment: Alignment.centerRight,
        // We used IgnorePainter which causes the widget to ignore all gestures on it
        child: IgnorePointer(
          ignoring: true,
          child: Padding(
            padding: EdgeInsets.only(
                bottom: marginBottomAdapted(),
                top: marginTopAdapted(),
                right: ScreenUtil().setHeight(12.0)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: numbers,
            ),
          ),
        ));
  }
}

// ! Height slider
// HeightSlider which is the indicator of the selected height. It contains 3 elements: label, circle, and line.
// i used Positioned widget which will specify the slider’s position from the bottom

/*
? we will need to do the following things:
1- Calculate drawingHeight which is the distance in pixels between the middle of the lowest label and middle of the highest label.
2- Having drawingHeight, we can calculate pixelsPerUnit which will represent how many pixels are there between two units of height.
3- Last, we can calculate sliderPosition which defines where should the slider be placed.
 */

class HeightSlider extends StatelessWidget {
  final int height;

  HeightSlider({this.height});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SliderLabel(
            height: this.height,
          ),
          Row(
            children: <Widget>[
              SliderCircle(),
              Expanded(
                child: SliderLine(),
              )
            ],
          )
        ],
      ),
    );
  }
}

// ? SliderLine
class SliderLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: List.generate(40, (index) {
        return Expanded(
          child: Container(
            height: 2,
            decoration: BoxDecoration(
                color: index.isEven
                    ? Theme.of(context).primaryColor
                    : Colors.white),
          ),
        );
      }),
    );
  }
}

// ? SliderCircle
class SliderCircle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: circleSizeAdapted(),
      height: circleSizeAdapted(),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.unfold_more,
        color: Colors.white,
        size: 0.6 * circleSizeAdapted(),
      ),
    );
  }
}

// ? SliderLabel
class SliderLabel extends StatelessWidget {
  int height;

  SliderLabel({this.height});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: ScreenUtil().setHeight(4),
        bottom: ScreenUtil().setHeight(2),
      ),
      child: Text(
        "$height",
        style: TextStyle(
          fontSize: 14,
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

double marginBottomAdapted() => ScreenUtil().setHeight(marginBottom);

double marginTopAdapted() => ScreenUtil().setHeight(marginTop);

double circleSizeAdapted() => ScreenUtil().setHeight(circleSize);

const double circleSize = 32.0;
const double marginBottom = circleSize / 2;
const double marginTop = 26.0;
const double selectedLabelFontSize = 14.0;
