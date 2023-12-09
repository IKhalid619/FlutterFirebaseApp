import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
// import 'package:firebseauthentication/Screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutterfirebaseapp/BottomNavigation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class MultiImageVideo extends StatefulWidget {
  const MultiImageVideo({Key? key}) : super(key: key);

  @override
  State<MultiImageVideo> createState() => _MultiImageVideoState();
}

class _MultiImageVideoState extends State<MultiImageVideo> {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();
  final CollectionReference _items =
  FirebaseFirestore.instance.collection('MultiImageVideo');

  List<File> _images = [];
  List<File> _videos = [];
  XFile? _video;
  bool isPlaying = false;
  bool isMuted = false;
  late VideoPlayerController _videoController;
  late Future<void> _initializeVideoPlayerFuture;

  Future<void> getImageGallery() async {
    List<XFile>? pickedFiles = await _picker.pickMultiImage();

    if (pickedFiles != null) {
      setState(() {
        _images = pickedFiles.map((XFile file) => File(file.path)).toList();
      });
    }
  }

  Future<void> getVideoGallery() async {
    XFile? pickedVideo = (await _picker.pickMultipleMedia()) as XFile?;

    if (pickedVideo != null) {
      setState(() {
        _video = pickedVideo;
        _videoController = VideoPlayerController.file(File(_video!.path))
          ..addListener(() {
            if (!mounted) return;
            setState(() {});
          });
        _initializeVideoPlayerFuture = _videoController.initialize();
        _videoController.setLooping(true); // Optional: Enable looping
      });
    }
  }

  Future<void> _uploadImagesAndVideo() async {
    // Upload images
    for (File image in _images) {
      String imageName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref = _storage.ref().child('multi_image_video/$imageName.jpg');
      UploadTask uploadTask = ref.putFile(image);

      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);

      String downloadURL = await taskSnapshot.ref.getDownloadURL();

      // Save the downloadURL to Firebase Firestore or perform any other necessary action
      await _items.add({'imageURL': downloadURL});
    }

    // Upload video
    if (_video != null) {
      String videoName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference videoRef =
      _storage.ref().child('multi_image_video/$videoName.mp4');
      UploadTask videoUploadTask = videoRef.putFile(File(_video!.path));

      TaskSnapshot videoTaskSnapshot =
      await videoUploadTask.whenComplete(() => null);

      String videoDownloadURL = await videoTaskSnapshot.ref.getDownloadURL();

      // Save the videoDownloadURL to Firebase Firestore or perform any other necessary action
      await _items.add({'videoURL': videoDownloadURL});
    }

    // Show a toast message
    Fluttertoast.showToast(
        msg: "Data successfully registered in Firebase",
        backgroundColor: Colors.blueGrey,
        timeInSecForIosWeb: 7);

    // Navigate to the dashboard screen
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => BottomNavigation()));

    // Clear the images and video variables after uploading
    setState(() {
      _images.clear();
      _video = null;
    });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("Multiple Image Video upload"),
      ),
      body: Column(
        children: [
          Center(
            child: InkWell(
              onTap: () {
                getImageGallery();
              },
              child: Container(
                margin: EdgeInsets.all(20),
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                  ),
                ),
                child: _images.isNotEmpty
                    ? Image.file(_images.first)
                    : Center(child: Icon(Icons.image)),
              ),
            ),
          ),
          Center(
            child: InkWell(
              onTap: () {
                getVideoGallery();
              },
              child: Container(
                margin: EdgeInsets.all(20),
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                  ),
                ),
                child: _video != null
                    ? AspectRatio(
                  aspectRatio: _videoController.value.aspectRatio,
                  child: VideoPlayer(_videoController),
                )
                    : const Center(child: Icon(Icons.video_library)),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                onPressed: () {
                  setState(() {
                    if (isPlaying) {
                      _videoController.pause();
                    } else {
                      _videoController.play();
                    }
                    isPlaying = !isPlaying;
                  });
                },
              ),
              const SizedBox(width: 16),
              IconButton(
                icon: Icon(Icons.stop),
                onPressed: () {
                  setState(() {
                    _videoController.pause();
                    _videoController.seekTo(Duration.zero);
                    isPlaying = false;
                  });
                },
              ),
              const SizedBox(width: 16),
              IconButton(
                icon: Icon(isMuted ? Icons.volume_off : Icons.volume_up),
                onPressed: () {
                  setState(() {
                    isMuted = !isMuted;
                    _videoController.setVolume(isMuted ? 0.0 : 1.0);
                  });
                },
              ),
            ],
          ),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: (_images.isNotEmpty || _video != null)
                  ? _uploadImagesAndVideo
                  : null,
              child: Text("Upload"),
            ),
          )
        ],
      ),
    );
  }
}
