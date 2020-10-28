import 'package:assistant/utils/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' as math;

import 'card_title.dart';

class WeightCard extends StatefulWidget {
  int initialValue;
  ValueChanged<int> onChage;
  final String title;
  final String value;
  final double valuesHeight;

  WeightCard({
    this.initialValue = 70,
    this.onChage,
    @required this.title,
    @required this.value,
    this.valuesHeight,
  });

  @override
  _WeightCardState createState() => _WeightCardState();
}

class _WeightCardState extends State<WeightCard> {
  int weight;

  @override
  void initState() {
    super.initState();
    weight = widget.initialValue ?? 70;
  }

  int get getWeight => weight;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: orangeColor,
      child: Padding(
        padding: EdgeInsets.only(
          top: ScreenUtil().setHeight(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CardTitle(
              title: '${widget.title}',
              subtitle: '${widget.value}',
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: _drawSlider(widget.valuesHeight),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawSlider(double valuesHeight) {
    return WeightBackground(
      valuesHeight: valuesHeight,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return constraints.isTight
              ? Container()
              : WeightSlider(
                  minValue: 1,
                  maxValue: 150,
                  value: weight,
                  onValueChanged: (val) {
                    setState(() => weight = val);
                    widget.onChage(val);
                  },
                  width: constraints.maxWidth,
                );
        },
      ),
    );
  }
}

// ? the background is an oval shape with light gray as a background color
class WeightBackground extends StatelessWidget {
  Widget child;
  double valuesHeight;

  WeightBackground({this.child, this.valuesHeight});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        Container(
          height: ScreenUtil().setHeight(valuesHeight ?? 100),
          decoration: BoxDecoration(
            color: Color.fromRGBO(244, 244, 244, 1.0),
            borderRadius: new BorderRadius.circular(
              ScreenUtil().setHeight(50.0),
            ),
          ),
          child: child,
        ),
        SvgPicture.asset(
          'assets/svg/widget_arrow.svg',
          height: ScreenUtil().setHeight(10),
          width: ScreenUtil().setWidth(18),
        ),
      ],
    );
  }
}

// ? WeightSlider
class WeightSlider extends StatelessWidget {
  final int maxValue, minValue;
  final double width;
  ValueChanged<int> onValueChanged;
  int value;

  ScrollController scrollController;

  WeightSlider(
      {@required this.maxValue,
      @required this.minValue,
      @required this.width,
      this.onValueChanged,
      this.value})
      : scrollController = new ScrollController(
          initialScrollOffset: (value - minValue) * width / 3,
        );

  // how many items should appear for user in each swipe or change (how many items there are to display.)
  // We always want to display only 3 items, so we need to know how much space one item needs to place (and set it in itemExtent).
  double get _itemExtended => this.width / 3;

  int _indexToValue(int index) => minValue + (index - 1);

  @override
  Widget build(BuildContext context) {
    int itemCount = (maxValue - minValue) + 3;
    return NotificationListener(
      onNotification: _onNotification,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        controller: scrollController,
        itemCount: itemCount,
        itemExtent: _itemExtended,
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          int value = _indexToValue(index);

          // adding 2 extra items to the ListView at the start and at the end
          // so that we can have the boundary values displayed in the middle of the widget.
          bool isExtra = index == 0 || index == itemCount - 1;

          return Center(
              child: isExtra
                  ? Container()

                  // Tap to select
                  : GestureDetector(
                      // we are using translucent hit test behavior so that both taps on texts as well as outside of them are being captured.
                      behavior: HitTestBehavior.translucent,
                      onTap: () => _animateTo(value, durationMillis: 50),
                      child: FittedBox(
                        child: Text(
                          value.toString(),
                          style: _getTextStyle(value),
                        ),
                        // for displaying number as one piece if it' size larger that alocated size
                        fit: BoxFit.scaleDown,
                      ),
                    ));
        },
      ),
    );
  }

  TextStyle _getDefaultTextStyle() {
    return new TextStyle(
      color: Color.fromRGBO(196, 197, 203, 1.0),
      fontSize: 14.0,
    );
  }

  TextStyle _getHighlightTextStyle() {
    return new TextStyle(
      color: Color.fromRGBO(77, 123, 243, 1.0),
      fontSize: 28.0,
    );
  }

  TextStyle _getTextStyle(int itemValue) {
    return itemValue == value
        ? _getHighlightTextStyle()
        : _getDefaultTextStyle();
  }

  /*
  Basically what we do is adding a NotificationListener to a ListView.
  It will invoke _onNotification on every scroll event.
  Then, we calculate the value of the middle element based on the notification’s Offset.
  If the calculated value is different than the passed value, we call onChanged method.
  */

  /*
  Centering position
  What we can also notice is a situation when after user selected value,
  it is not being centered. I think it should be. To achieve that we will use ScrollController.
  We can detect if the user stopped scrolling and if so, we can animate to the selected value
  */

  bool _userStoppedScrolling(Notification notification) {
    return notification is UserScrollNotification &&
        notification.direction == ScrollDirection.idle &&
        scrollController.position.activity is! HoldScrollActivity;
  }

  _animateTo(int valueToSelect, {int durationMillis = 200}) {
    double targetExtent = (valueToSelect - minValue) * _itemExtended;
    scrollController.animateTo(
      targetExtent,
      duration: new Duration(milliseconds: durationMillis),
      curve: Curves.decelerate,
    );
  }

  bool _onNotification(Notification notification) {
    if (notification is ScrollNotification) {
      int middleValue = _offsetToMiddleValue(notification.metrics.pixels);

      if (_userStoppedScrolling(notification)) {
        _animateTo(middleValue);
      }

      if (middleValue != value) {
        onValueChanged(middleValue);
      }
    }
    return true;
  }

  int _offsetToMiddleValue(double offset) {
    int indexOfMiddleElement = _offsetToMiddleIndex(offset);
    int middleValue = _indexToValue(indexOfMiddleElement);
    middleValue = math.max(minValue, math.min(maxValue, middleValue));
    return middleValue;
  }

  int _offsetToMiddleIndex(double offset) =>
      (offset + width / 2) ~/ _itemExtended;
}
