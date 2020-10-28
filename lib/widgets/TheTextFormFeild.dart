import 'package:assistant/utils/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';

class TheTextFormField extends StatefulWidget {
  final String hint;
  final String label;
  final bool obscureText;
  final validator;
  final onChanged;
  final prefixIcon;
  final suffixIcon;
  final double width;
  final Color backgroundColor;
  final TextInputType keyboardType;
  final double borderRaduis;
  final int maxLine;

  const TheTextFormField({
    Key key,
    this.hint,
    this.label,
    this.obscureText,
    this.validator,
    this.onChanged,
    this.prefixIcon,
    this.suffixIcon,
    this.backgroundColor,
    this.width,
    this.keyboardType,
    this.borderRaduis,
    this.maxLine,
  }) : super(key: key);

  @override
  _TheTextFormFieldState createState() => _TheTextFormFieldState();
}

class _TheTextFormFieldState extends State<TheTextFormField> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: widget.width ?? size.width * .8,
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? secondColor,
        borderRadius: BorderRadius.circular(widget.borderRaduis ?? 50),
      ),
      margin: EdgeInsets.symmetric(
        vertical: ScreenUtil().setHeight(10),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: ScreenUtil().setWidth(10),
      ),
      child: TextFormField(
        textAlign: TextAlign.right,
        maxLines: widget.maxLine ?? 1,
        keyboardType: widget.keyboardType ?? TextInputType.text,
        validator: widget.validator ?? null,
        onChanged: widget.onChanged ?? null,
        obscureText: widget.obscureText ?? false,
        decoration: InputDecoration(
          icon: widget.prefixIcon ?? null,
          suffixIcon: widget.suffixIcon ?? null,
          border: InputBorder.none,
          hintText: widget.hint == null ? null : '${widget.hint}',
          labelText: widget.label == null ? null : '${widget.label}',
        ),
      ),
    );
  }
}
