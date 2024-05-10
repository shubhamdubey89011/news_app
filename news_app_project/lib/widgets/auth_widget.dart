import 'package:flutter/material.dart';
import 'package:news_app/utils/app_styles.dart';
import 'package:news_app/utils/color_constant.dart';
//import 'package:responsive_sizer/responsive_sizer.dart';

class AuthWidget {
  static elevatedButton({required String text, required VoidCallback onTap}) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
            width: 300.0,
            height: 50.0,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(35.0),
                gradient: const LinearGradient(
                    colors: ColorConstants.linearGradientColor)),
            child: Text(
              text,
              style: AppStyles.openSansMediumSize
                  .copyWith(color: Colors.black54, fontSize: 20.0),
            )),
      );

        static richText(
          {required String text1,
          required String text2,
          Color? text2Color,
          Color? text1Color,
          TextAlign? textAlign,
          VoidCallback? onTap}) =>
      Center(
        child: GestureDetector(
          onTap: onTap,
          child: RichText(
              textAlign: textAlign ?? TextAlign.center,
              text: TextSpan(
                  text: text1,
                  style: AppStyles.interRegular.copyWith(color: text1Color),
                  children: [
                    TextSpan(
                      text: text2,
                      style: AppStyles.interRegular.copyWith(
                          color: text2Color ?? ColorConstants.appMainColorPink),
                    )
                  ])),
        ),
      );
}