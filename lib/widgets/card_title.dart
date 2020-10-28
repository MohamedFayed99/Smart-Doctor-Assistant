import 'package:assistant/utils/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CardTitle extends StatelessWidget {
  final String title;
  final String subtitle;

  CardTitle({this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(
            top: ScreenUtil().setHeight(8),
            bottom: ScreenUtil().setHeight(8),
            left: ScreenUtil().setHeight(11),
            right: ScreenUtil().setHeight(13),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                subtitle ?? "",
                style: _subtitleStyle,
              ),
              Text(
                title,
                style: _titleStyle,
              ),
            ],
          ),
        ),
        Divider(
          height: 1.0,
          color: Colors.grey[400],
        ),
      ],
    );
  }

  TextStyle _titleStyle = TextStyle(
    fontSize: 16.0,
    color: mainColor,
  );

  TextStyle _subtitleStyle = TextStyle(
    fontSize: 11.0,
    color: Colors.black,
  );
}
