import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class Config {
  final String appName = 'Apna Shahar';
  final String splashIcon = 'assets/images/splash.png';
  final String record = 'assets/images/RecordVideo.png';
  final String supportEmail = 'YOUR_EMAIL';
  final String privacyPolicyUrl = 'https://www.mrb-lab.com/privacy-policy';
  final String ourWebsiteUrl = 'https://www.mrb-lab.com';
  final String iOSAppId = '000000';

  //social links
  static const String facebookPageUrl = 'https://www.facebook.com/mrblab24';
  static const String youtubeChannelUrl =
      'https://www.youtube.com/channel/UCnNr2eppWVVo-NpRIy1ra7A';
  static const String twitterUrl = 'https://twitter.com/FlutterDev';

  //app theme color
  final Color appColor = Colors.deepPurpleAccent;

  //Intro images
  final String introImage1 = 'assets/images/news1.png';
  final String introImage2 = 'assets/images/news6.png';
  final String introImage3 = 'assets/images/news7.png';

  //animation files
  final String doneAsset = 'assets/animation_files/done.json';

  //Language Setup
  final List<String> languages = ['Hindi',  'English'];

  final String serverToken =
      'AAAAPGnbWRs:APA91bFs5YdIJGj5kvUrPvzECAkCl8Xw4D8NYObk3TDT7cY5UmVifTJTnVWfo90ChE6MsS7EPsHYG926wKts6c6Y-KbPWikRa9nWgQb6o97wUGgmqGH2hutVn6eZ9FoETCg948S4nho-';
  final String icon = 'assets/images/icon.png'; // app icon

  //don't edit or remove this
  final List contentTypes = [
    'image',
    'video',
  ];


List<String> initialCategories = [
  'Entertainment',
  'Sports',
  'Politics',
  'Travel'
];


}







