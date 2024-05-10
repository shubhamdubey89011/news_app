import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/config/config.dart';
import 'package:news_app/constants/constants.dart';

class NotificationBloc1 extends ChangeNotifier {

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  
  Future sendPostNotification (String title, String postId,  String contentType, String description) async{
    await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=${Config().serverToken}',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': 'Click here to read more details',
            'title': title,
            'sound':'default'
          },
          'priority': 'normal',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done',
            'post_id': postId,
           
            'notification_type': 'post',
            'content_type': contentType,
            'description': description
          },
          'to': "/topics/${Constants.fcmSubscriptionTopic}",
        },
      ),
    );
  }

  Future sendCustomNotification (String title, String description) async{
    await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=${Config().serverToken}',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': 'Click here to read more details',
            'title': title,
            'sound':'default'
          },
          'priority': 'normal',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done',
            'notification_type': 'custom',
            'description': description
          },
          'to': "/topics/${Constants.fcmSubscriptionTopic}",
        },
      ),
    );
  }


  
}
