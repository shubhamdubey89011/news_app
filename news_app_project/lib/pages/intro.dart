import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:news_app/config/config.dart';
import 'package:news_app/screens/multi_select.dart';
import 'package:news_app/utils/next_screen.dart';

class IntroPage extends StatefulWidget {
  IntroPage({Key? key}) : super(key: key);

  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  void afterIntroComplete() {
    nextScreenReplace(context, SelectMultiCategories());
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: [
        introPage(context, tr('intro-title1'), tr('intro-description1'),
            Config().introImage1),
        introPage(context, tr('intro-title2'), tr('intro-description2'),
            Config().introImage2),
        introPage(
            context, tr('intro-title3'), tr('intro-description3'), Config().introImage3)
      ],
      onDone: () {
        afterIntroComplete();
      },
      onSkip: () {
        afterIntroComplete();
      },
      globalBackgroundColor: Colors.white,
      showSkipButton: true,
      skip:  Text(tr('skip'),
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey)),
      next: const Icon(Icons.navigate_next),
      done:  Text(tr("done"), style: TextStyle(fontWeight: FontWeight.w600)),
      dotsDecorator: DotsDecorator(
          size: const Size.square(7.0),
          activeSize: const Size(20.0, 5.0),
          activeColor: Theme.of(context).primaryColor,
          color: Colors.black26,
          spacing: const EdgeInsets.symmetric(horizontal: 3.0),
          activeShape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0))),
    );
  }
}

PageViewModel introPage(context, String title, String subtitle, String image) {
  return PageViewModel(
    titleWidget: Column(
      children: <Widget>[
        Text(
          title,
          style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.7,
              wordSpacing: 1,
              color: Colors.black),
        ),
        SizedBox(
          height: 8,
        ),
        Container(
          height: 3,
          width: 100,
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(10)),
        )
      ],
    ),
    body: subtitle,
    image: Center(child: Image(image: AssetImage(image))),
    decoration: const PageDecoration(
      pageColor: Colors.white,
      bodyTextStyle: TextStyle(
          color: Colors.black54, fontSize: 17, fontWeight: FontWeight.w500),
      bodyPadding: EdgeInsets.only(left: 30, right: 30),
      //descriptionPadding: EdgeInsets.only(left: 30, right: 30),
      imagePadding: EdgeInsets.all(30),
    ),
  );
}
