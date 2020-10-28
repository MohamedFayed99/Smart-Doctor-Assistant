import 'package:assistant/utils/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'gender_card.dart';

class InputSummaryCard extends StatelessWidget {
  final GenderType gender;
  final int height;
  final int weight;
  final Color backgroundColor;

  const InputSummaryCard({
    Key key,
    this.gender,
    this.height,
    this.weight,
    this.backgroundColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor,
      margin: EdgeInsets.only(
        top: ScreenUtil().setHeight(16.0),
        bottom: ScreenUtil().setHeight(5.0),
        left: ScreenUtil().setHeight(16.0),
        right: ScreenUtil().setHeight(16.0),
      ),
      child: SizedBox(
        height: ScreenUtil().setHeight(50.0),
        child: Row(
          children: <Widget>[
            Expanded(child: _genderText()),
            _divider(),
            Expanded(
              child: _text(
                "${weight} كجم ",
              ),
            ),
            _divider(),
            Expanded(child: _text("${height} سم ")),
          ],
        ),
      ),
    );
  }

  Widget _genderText() {
    String genderText = gender == GenderType.other
        ? '-'
        : (gender == GenderType.male ? 'ذكر' : 'انثي');
    return _text(genderText);
  }

  Widget _text(String text) {
    return Text(
      text,
      style: TextStyle(
        color: mainColor,
        fontSize: 15.0,
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.rtl,
    );
  }

  Widget _divider() {
    return Container(
      width: 1.0,
      color: secondColor,
    );
  }
}
