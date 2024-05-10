import 'package:flutter/material.dart';
import 'package:news_app/constants/constants.dart';
import 'package:velocity_x/velocity_x.dart';

Widget customTextField(
    {String? title, String? hint, controller, isPass, inputType, decoration}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      title!.text.color(redColor).fontFamily(semibold).size(16).make(),
      5.heightBox,
      TextFormField(
      //  initialValue: '+91',
        keyboardType: inputType,
        obscureText: isPass,
        controller: controller,
        decoration: decoration,
      ),
    ],
  );
}
