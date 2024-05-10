import 'package:flutter/material.dart';
import 'package:news_app/utils/app_fonts.dart';




const regular = "sans_regular";
const semibold = "sans_semibold";
const bold = "sans_bold";


EdgeInsets paddingSymmetric({double? horizontal, double? vertical}) =>
    EdgeInsets.symmetric(
        horizontal: horizontal ?? 00, vertical: vertical ?? 00);

class AppStyles {
  static TextStyle openSansTitle = TextStyle(
      fontFamily: AppFonts.openSans,
      fontSize: 20.0,
      fontWeight: FontWeight.w600);

  static TextStyle openSansMediumSize = TextStyle(
      fontFamily: AppFonts.openSans,
      fontSize: 17.0,
      fontWeight: FontWeight.w600);

  static TextStyle openSansRegular = TextStyle(
      fontFamily: AppFonts.openSans,
      fontSize: 10.0,

      fontWeight: FontWeight.w400);

  static TextStyle robotoRegular = TextStyle(
      fontFamily: AppFonts.roboto,

      fontSize: 10.0,
      fontWeight: FontWeight.w400);

  static TextStyle interRegular = TextStyle(
      fontFamily: AppFonts.inter,
color: Colors.black,
      fontSize: 10.0,
      fontWeight: FontWeight.w400);
}