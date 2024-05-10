import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:news_app/controller/auth_controller.dart';


class Constants {
  static final String fcmSubscriptionTopic = 'all';
  static final notificationTag = 'notifications';
  
}
const regular = "sans_regular";
const semibold = "sans_semibold";
const bold = "sans_bold";

const Color textfieldGrey = Color.fromRGBO(209, 209, 209, 1);
const Color fontGrey = Color.fromRGBO(107, 115, 119, 1);
const Color darkFontGrey = Color.fromRGBO(62, 68, 71, 1);
const Color whiteColor = Color.fromRGBO(255, 255, 255, 1);
const Color lightGrey = Color.fromRGBO(239, 239, 239, 1);
const Color redColor = Color.fromRGBO(230, 46, 4, 1);
const Color golden = Color.fromRGBO(255, 168, 0, 1);
const Color lightGolden = Color(0xffFEEAD1);


List pages = [
  // VideoScreen(),
  // SearchScreen(),
  //  AddVideo(),
  Text('Messages Screen'),
//  ProfileScreen(uid: authController.user.uid),
];

// COLORS
const backgroundColor = Colors.black;
var buttonColor = Colors.red[400];
const borderColor = Colors.grey;

// FIREBASE
var firebaseAuth = FirebaseAuth.instance;
var firebaseStorage = FirebaseStorage.instance;
var firestore = FirebaseFirestore.instance;

// CONTROLLER
var authController = AuthController.instance;


final FirebaseAuth auth1 = FirebaseAuth.instance;

final FirebaseFirestore firestore1 = FirebaseFirestore.instance;

final FirebaseStorage storage = FirebaseStorage.instance;




const Kheight10 = SizedBox(
  height: 10,
);
const Kheight20 = SizedBox(
  height: 20,
);
const Kheight30 = SizedBox(
  height: 30,
);

const Kheight60 = SizedBox(
  height: 60,
);

String image =
    'https://www.themoviedb.org/t/p/original/Ia3dzj5LnCj1ZBdlVeJrbKJQxG.jpg';

BorderRadiusGeometry radiuss = BorderRadius.circular(10);