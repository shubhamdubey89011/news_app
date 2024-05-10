import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class AppName extends StatelessWidget {
  final double fontSize;

  const AppName({Key? key, required this.fontSize}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: context.tr('Apna'), // Explicitly use tr() from context
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: fontSize,
          fontWeight: FontWeight.w900,
          color: Colors.grey[800],
        ),
        children: <TextSpan>[
          TextSpan(
            text: context.tr('Shahar'), // Explicitly use tr() from context
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.orangeAccent,
            ),
          ),
        ],
      ),
    );
  }
}
