import 'package:flutter/material.dart';
import 'package:wodada/common/colors.dart';

class BoldText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;

  const BoldText({
    required this.text,
    this.fontSize = 12,
    this.color = TITLE_COLOR, // 기본 색상
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        color: color,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
