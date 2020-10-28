import 'package:flutter/material.dart';

import '../utils/consts.dart';

Widget appBar({
  @required BuildContext context,
  @required String title,
  @required IconData leadingIcon,
  Function onLeadingIconPressed,
  TextStyle titleStyle,
  Color leadingIconColor,
  bool centerTitle,
  List<Widget> actions,
}) {
  return AppBar(
    centerTitle: centerTitle ?? true,
    backgroundColor: mainColor,
    title: Text(
      title,
      style: titleStyle ??
          TextStyle(
            color: Colors.white,
          ),
    ),
    actions: actions,
    leading: IconButton(
      icon: IconButton(
        icon: Icon(
          leadingIcon,
          color: leadingIconColor ?? Colors.white,
        ),
        onPressed: onLeadingIconPressed ??
            () {
              Navigator.of(context).pop();
            },
      ),
      onPressed: onLeadingIconPressed,
    ),
  );
}
