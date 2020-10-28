import 'package:assistant/utils/consts.dart';
import 'package:flutter/material.dart';

class ShapesPainter extends CustomPainter {
  final Offset shapeCenter;
  final double raduis;
  final Color color;

  ShapesPainter({
    this.shapeCenter,
    this.raduis,
    this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    // set the color property of the paint
    paint.color = color ?? mainColor;
    var center = shapeCenter ?? Offset(0, size.height);
    canvas.drawCircle(center, raduis ?? 75.0, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
