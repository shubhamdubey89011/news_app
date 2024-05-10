import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../config/config.dart';
import '../services/app_service.dart';

class PrivacyInfo extends StatelessWidget {
  const PrivacyInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
         Text(
          tr('By SigningUp/Logging In, You agree to our'),
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
                onTap: () => AppService().openLinkWithCustomTab(context, Config().privacyPolicyUrl.tr()),
                child:  Text(
                  tr('Terms of Services'),
                  style: TextStyle(decoration: TextDecoration.underline, color: Colors.blue),
                )),
            const SizedBox(
              width: 5,
            ),
             Text(tr('and')),
            const SizedBox(
              width: 5,
            ),
            InkWell(
                onTap: () => AppService().openLinkWithCustomTab(context, Config().privacyPolicyUrl.tr()),
                child:  Text(
                  tr('Privacy Policy'),
                  style: TextStyle(decoration: TextDecoration.underline, color: Colors.blue),
                ))
          ],
        )
      ],
    );
  }
}
