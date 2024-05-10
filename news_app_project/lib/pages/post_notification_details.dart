import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:news_app/pages/video_article_details.dart';

import '../models/article.dart';

class PostNotificationDetails extends StatefulWidget {
  final String postID;
  PostNotificationDetails({Key? key, required this.postID}) : super(key: key);

  @override
  _PostNotificationDetailsState createState() =>
      _PostNotificationDetailsState();
}

class _PostNotificationDetailsState extends State<PostNotificationDetails> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Future _fetchData;

  Future<Article> fetchPostByPostId() async {
    Article? article;
    final docRef = _firestore.collection('contents').doc(widget.postID);
    await docRef.get().then((DocumentSnapshot snap) {
      article = Article.fromFirestore(snap);
    });
    return article!;
  }

  @override
  void initState() {
    _fetchData = fetchPostByPostId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _fetchData,
      builder: (context, AsyncSnapshot snap) {
        if (snap.connectionState == ConnectionState.active ||
            snap.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(child: _LoadingIndicatorWidget()),
          );
        } else if (snap.hasError) {
          //print(snap.error);
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Text('Something is wrong. Please try again!'),
            ),
          );
        } else {
          Article article = snap.data;
          //print('article: ${article.title}');
           if (article.contentType == 'video') {
            return VideoArticleDetails(data: article);
          } else
            return Scaffold(
              appBar: AppBar(),
              body: Center(
                child: Text('Something is wrong1. Please try again!'),
              ),
            );
        }
      },
    );
  }
}

class _LoadingIndicatorWidget extends StatelessWidget {
  const _LoadingIndicatorWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        width: 45,
        height: 60,
        child: LoadingIndicator(
          indicatorType: Indicator.ballBeat,
          pathBackgroundColor: Theme.of(context).primaryColor,
        ));
  }
}
