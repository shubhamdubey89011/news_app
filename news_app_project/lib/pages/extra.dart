import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart' show LocationData;
import 'package:geocoding/geocoding.dart';

class VideoUploader extends StatefulWidget {
  @override
  _VideoUploaderState createState() => _VideoUploaderState();
}

class _VideoUploaderState extends State<VideoUploader> {
  File? _video;
  String _description = '';
  String? _selectedCategory;final picker = ImagePicker();
//  location.LocationData? _currentLocation;
//   final location.Location _location = location.Location();

  List<Category> categories = [];

  @override
  void initState() {
    super.initState();
    fetchCategories();
    // _getLocation();
  }

 Future<void> fetchCategories() async {
  final QuerySnapshot<Map<String, dynamic>> snapshot =
      await FirebaseFirestore.instance.collection('categories').get();
  setState(() {
    categories = snapshot.docs.map((doc) => Category.fromSnapshot(doc)).toList();
  });
}

//  Future<void> _getLocation() async {
//     LocationData locationData;
//     try {
//       locationData = await location.getLocation();
//       setState(() {
//         _currentLocation = locationData;
//       });
//     } catch (e) {
//       print('Failed to get location: $e');
//     }
//   }
  Future<void> pickVideo(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select video source'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.video_library),
                title: Text('Pick video from gallery'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickVideoFromGallery();
                },
              ),
              ListTile(
                leading: Icon(Icons.videocam),
                title: Text('Capture video from camera'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickVideoFromCamera();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickVideoFromGallery() async {
    final pickedFile = await picker.getVideo(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _video = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickVideoFromCamera() async {
    final pickedFile = await picker.getVideo(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _video = File(pickedFile.path);
      });
    }
  }

  Future<void> uploadVideo() async {
    if (_video == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Please select a video first')));
      return;
    }

    Reference ref = FirebaseStorage.instance
        .ref()
        .child('videos')
        .child('${DateTime.now()}.mp4');
    UploadTask uploadTask = ref.putFile(_video!);
    TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);
    String videoUrl = await snapshot.ref.getDownloadURL();
      Map<String, dynamic> videoData = {
      'videoUrl': videoUrl,
      'description': _description,
      'category': _selectedCategory,
    };

    // Add location data if available
    // if (_currentLocation != null) {
    //   videoData['latitude'] = _currentLocation!.latitude;
    //   videoData['longitude'] = _currentLocation!.longitude;
    // }

    await FirebaseFirestore.instance.collection('contents').add({
      'videoUrl': videoUrl,
      'description': _description,
      'category': _selectedCategory,
    });

    setState(() {
      _video = null;
      _description = '';
      _selectedCategory = null;
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Video uploaded successfully')));
  }

  Future<String?> getCityFromLocation(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        return placemarks.first.locality;
      }
    } catch (e) {
      print('Error fetching city: $e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Uploader'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _video == null
                ? Text('')
                : Text(
                    'Selected video: ${_video!.path ?? ''}'),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 100,
                  width: 200,
                  child: TextField(
                    maxLines: 3,
                    cursorWidth: 2,
                    expands: false,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      labelText: 'Description',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _description = value;
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(4),
                  child: GestureDetector(
                    onTap: () => pickVideo(context),
                    child: ImageIcon(
                      AssetImage('assets/images/RecordVideo.png'),
                      size: 90,
                      color: Colors.deepPurple,
                    ),
                  ),
                )
              ],
            ),

            DropdownButton<String>(
              value: _selectedCategory,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCategory = newValue;
                });
              },
              items: categories
                  .map<DropdownMenuItem<String>>((Category category) {
                return DropdownMenuItem<String>(
                  value: category.name,
                  child: Text(category.name),
                );
              }).toList(),
              hint: Text('Select a category'),
            ),
            SizedBox(height: 30,),
            // _currentLocation != null
            //     ? Text(
            //         'Current Location: ${_currentLocation!.latitude}, ${_currentLocation!.longitude}')
            //     : CircularProgressIndicator(),

            // SizedBox(height: 20.0),
            // _currentLocation != null
            //     ? Text(
            //         'Current Location: ${_currentLocation!.latitude}, ${_currentLocation!.longitude}')
            //     : CircularProgressIndicator(),
            // SizedBox(height: 20),
            // _currentLocation != null
            //     ? FutureBuilder<String?>(
            //         future: getCityFromLocation(
            //             _currentLocation!.latitude!, _currentLocation!.longitude!),
            //         builder: (context, snapshot) {
            //           if (snapshot.connectionState == ConnectionState.waiting) {
            //             return CircularProgressIndicator();
            //           } else if (snapshot.hasError) {
            //             return Text('Error: ${snapshot.error}');
            //           } else {
            //             return Text('City: ${snapshot.data ?? "Unknown"}');
            //           }
            //         },
            //       ):

            Container(
              height: 300,
              alignment: Alignment.topRight,
              padding: EdgeInsets.all(10),
              child: TextButton(
                onPressed: uploadVideo,
                child: Text('Submit', style: TextStyle(fontSize: 20)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Category {
  final String name;

  Category(this.name);

  Category.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : name = snapshot['name'] as String;
}
