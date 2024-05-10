import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization/easy_localization.dart' show context;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:news_app/pages/comments.dart';
import 'package:news_app/pages/extra.dart';
import 'package:news_app/pages/notifications.dart';
import 'package:news_app/pages/search.dart';
import 'package:news_app/pages/selection_location.dart';
import 'package:news_app/utils/app_name.dart';
import 'package:news_app/utils/next_screen.dart';
import 'package:news_app/widgets/drawer.dart';
import 'package:share/share.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:video_player/video_player.dart';

class PlayVideos extends StatefulWidget {
  @override
  _PlayVideosState createState() => _PlayVideosState();
}

class _PlayVideosState extends State<PlayVideos> {
  late ScrollController _scrollController;
  late List<String> _categories;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  Map<String, bool> _likedVideos = {};

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _categories = [];
    _fetchCategories();
  }

  void _fetchCategories() async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection('contents').get();
    final categories = querySnapshot.docs
        .map((doc) => doc.data().containsKey('category')
            ? doc['category'] as String
            : null)
        .where((category) => category != null) // Filter out null values
        .map((category) =>
            category!) // Cast nullable strings to non-nullable strings
        .toSet()
        .toList();
    setState(() {
      _categories = categories;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: DrawerMenu(),
      key: scaffoldKey,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            new SliverAppBar(
              automaticallyImplyLeading: false,
              centerTitle: false,
              titleSpacing: 0,
              title: AppName(fontSize: 19.0),
              leading: IconButton(
                icon: Icon(
                  Feather.menu,
                  size: 25,
                ),
                onPressed: () {
                  scaffoldKey.currentState!.openDrawer();
                },
              ),
              elevation: 1,
              actions: <Widget>[
                // IconButton(
                //   icon: Icon(
                //     Icons.location_on_outlined,
                //     size: 22,
                //   ),
                //   onPressed: () {
                //     nextScreen(context, SelectLocation());
                //   },
                // ),
                IconButton(
                  icon: Icon(
                    Icons.search,
                    size: 22,
                  ),
                  onPressed: () {
                    nextScreen(context, SearchPage());
                  },
                ),
                IconButton(
                  icon: Icon(
                    LineIcons.bell,
                    size: 25,
                  ),
                  onPressed: () {
                    nextScreen(context, Notifications());
                  },
                ),
                SizedBox(
                  width: 5,
                )
              ],
              pinned: true,
              floating: true,
              forceElevated: innerBoxIsScrolled,
            ),
          ];
        },
        body: DefaultTabController(
          length: _categories.length,
          child: Column(
            children: [
              TabBar(
                isScrollable: true,
                labelColor: Colors.black,
                tabs: _categories
                    .map((category) => Tab(text: tr(category)))
                    .toList(),
              ),
              Expanded(
                child: TabBarView(
                  children: _categories.map((category) {
                    return _buildVideosForCategory(category);
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVideosForCategory(String category) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('contents')
          .where('category', isEqualTo: category)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final docs = snapshot.data!.docs.reversed.toList();
        if (docs.isEmpty) {
          return Center(child: Text('No videos found for this category').tr());
        }
        return ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final data = docs[index].data() as Map<String, dynamic>;
            final videoUrl = data['youtube url'] as String?;
            final timestamp = data['timestamp'] as String;
            final title = data['title'] as String?;
            final time = data['date'] as String?;

            if (videoUrl != null && videoUrl.isNotEmpty) {
              final isLiked = _likedVideos.containsKey(timestamp)
                  ? _likedVideos[timestamp]!
                  : false;

              // Create a new ScrollController for each ListView.builder
              final scrollController = ScrollController();

              return Card(
                margin: EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    VideoPlayerItem(
                      videoUrl: videoUrl,
                      title: title,
                      time: time,
                      scrollController:
                          scrollController, // Pass the new ScrollController
                      index: index,
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            _toggleLike(timestamp);
                            _incrementLoveCount(timestamp);
                          },
                          icon: Icon(
                            isLiked ? Icons.favorite : Icons.favorite_border,
                            color: isLiked ? Colors.red : null,
                          ),
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.04),

                        IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CommentsPage(timestamp: timestamp)),
                              );
                            },
                            icon: Icon(Icons.comment_rounded)),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.04),
                        IconButton(
                            onPressed: () {
                              Share.share(videoUrl);
                            },
                            icon: Icon(Icons.share_rounded)),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.04),
                        IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => VideoUploader()),
                              );
                            },
                            icon: Icon(Icons.videocam_rounded)),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.04),
                        IconButton(
                          onPressed: () {
                            _toggleBookmark(timestamp);
                          },
                          icon: Icon(
                            isLiked
                                ? Icons.bookmark
                                : Icons
                                    .bookmark_border, // Use isLiked to determine the icon
                          ),
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.04),

                        // Other icon buttons...
                      ],
                    ),
                  ],
                ),
              );
            } else {
              return SizedBox(); // If URL is null or empty, return an empty SizedBox
            }
          },
        );
      },
    );
  }

  void _incrementLoveCount(String timestamp) async {
    // Trim any leading or trailing whitespace from the timestamp
    timestamp = timestamp.trim();

    // Check if the timestamp is empty or null
    if (timestamp.isEmpty) {
      print('Timestamp is empty');
      return;
    }

    // Ensure that the timestamp doesn't contain double slashes
    if (timestamp.contains('//')) {
      print('Invalid timestamp format');
      return;
    }

    // Get the reference to the video document in Firestore
    DocumentReference videoRef =
        FirebaseFirestore.instance.collection('contents').doc(timestamp);

    // Run a transaction to atomically update the love count
    FirebaseFirestore.instance.runTransaction((transaction) async {
      // Get the current data snapshot
      DocumentSnapshot snapshot = await transaction.get(videoRef);

      if (snapshot.exists) {
        // Cast the data to a Map<String, dynamic>
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

        // Get the current love count
        int currentLoveCount = data['loves'] ?? 0;

        // Increment the love count by 1
        int newLoveCount = currentLoveCount + 1;

        // Update the love count in Firestore
        transaction.update(videoRef, {'loves': newLoveCount});
        print('Love count incremented successfully!');
      } else {
        print('Document does not exist');
      }
    }).then((value) {
      print('Transaction complete');
    }).catchError((error) {
      print('Failed to increment love count: $error');
      return; // Add the return statement here
    });
  }

  void _toggleLike(String timestamp) {
    setState(() {
      if (_likedVideos.containsKey(timestamp)) {
        _likedVideos[timestamp] = !_likedVideos[timestamp]!;
      } else {
        _likedVideos[timestamp] = true;
      }
    });
  }

  void _toggleBookmark(String timestamp) async {
    // Get the reference to the document in Firestore
    final String? uid = FirebaseAuth.instance.currentUser?.uid;
    DocumentReference videoRef =
        FirebaseFirestore.instance.collection('users').doc(uid);

    // Check if the current user ID is already bookmarked
    bool isBookmarked = false;
    DocumentSnapshot snapshot = await videoRef.get();
    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      List<String> bookmarkedItems =
          List<String>.from(data['bookmarked items'] ?? []);
      isBookmarked = bookmarkedItems.contains(timestamp);
    }

    // Toggle the bookmark status
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(videoRef);
      if (snapshot.exists) {
        List<String> bookmarkedItems =
            List<String>.from(snapshot.get('bookmarked items') ?? []);

        if (isBookmarked) {
          bookmarkedItems.remove(timestamp);
        } else {
          bookmarkedItems.add(timestamp);
        }

        transaction.update(videoRef, {'bookmarked items': bookmarkedItems});
      }
    }).then((_) {
      print('Bookmark status toggled successfully');
      setState(() {
        _likedVideos[timestamp] =
            !isBookmarked; // Update the state of the bookmark icon
      });
    }).catchError((error) {
      print('Failed to toggle bookmark status: $error');
    });
  }
}

class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;
  final String? title;
  final String? time;

  final ScrollController scrollController;
  final int index;
  // final String userId;

  const VideoPlayerItem({
    Key? key,
    required this.videoUrl,
    this.title,
    this.time,
    // required this.userId,
    required this.scrollController,
    required this.index,
  }) : super(key: key);

  @override
  _VideoPlayerItemState createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  bool _isPlaying = false;
  double _aspectRatio = 16 / 9;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..addListener(() {
        final isPlaying = _controller.value.isPlaying;
        if (isPlaying != _isPlaying) {
          setState(() {
            _isPlaying = isPlaying;
          });
        }
      });
    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      if (widget.scrollController != null) {
        widget.scrollController.addListener(_scrollListener);
      }
      _updatePlayState();
      setState(() {
        _aspectRatio = _controller.value.aspectRatio;
      });
    });
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_scrollListener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 260,
          child: AspectRatio(
            aspectRatio: _aspectRatio,
            child: Stack(
              children: [
                VideoPlayer(_controller),
                Center(
                  child: IconButton(
                    icon: Icon(
                      _isPlaying ? Icons.pause : Icons.play_arrow,
                      size: 50,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      _isPlaying ? _controller.pause() : _controller.play();
                    },
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.fast_rewind,
                        color: Colors.transparent,
                      ),
                      onPressed: () {
                        _controller.seekTo(Duration(
                            seconds:
                                _controller.value.position.inSeconds - 10));
                      },
                    ),
                    SizedBox(width: 20),
                    IconButton(
                      icon: Icon(
                        Icons.fast_forward,
                        color: Colors.transparent,
                      ),
                      onPressed: () {
                        _controller.seekTo(Duration(
                            seconds:
                                _controller.value.position.inSeconds + 10));
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (widget.title != null) ...[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.title ?? '',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ],
        if (widget.time != null) ...[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(Feather.clock, size: 12),
                SizedBox(
                  width: 5,
                ),
                Text(
                  widget.time ?? '',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  void _scrollListener() {
    _updatePlayState();
  }

  void _updatePlayState() {
    if (widget.scrollController != null &&
        widget.scrollController.hasClients &&
        widget.scrollController.position.hasViewportDimension) {
      final videoRect = Rect.fromPoints(
        _controller.value.size.bottomLeft(Offset.zero),
        _controller.value.size.topRight(Offset.zero),
      );

      final viewportRect = Rect.fromPoints(
        Offset.zero,
        Offset(
          widget.scrollController.position.viewportDimension,
          widget.scrollController.position.viewportDimension,
        ),
      );

      if (videoRect.overlaps(viewportRect)) {
        // Auto-play logic can be added here if needed
      } else {
        if (_controller.value.isPlaying) {
          _controller.pause();
        }
      }
    }
  }
}


