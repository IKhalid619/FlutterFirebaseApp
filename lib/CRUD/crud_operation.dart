import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerUpload extends StatefulWidget {
  const ImagePickerUpload({super.key});

  @override
  State<ImagePickerUpload> createState() => _ImagePickerUploadState();
}

class _ImagePickerUploadState extends State<ImagePickerUpload> {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  final CollectionReference _items =
  FirebaseFirestore.instance.collection('UsersData');

  var taskSnapshot;

  File? _image;


  var userNameStoreController = TextEditingController();
  var userEmailStoreController = TextEditingController();
  var userContactStoreController = TextEditingController();

  Future getImageGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    try {
      if (_image != null) {
        String imageName = DateTime.now().millisecondsSinceEpoch.toString();
        Reference reference = _storage.ref().child('images/$imageName.jpg');
        UploadTask uploadTask = reference.putFile(_image!);
        taskSnapshot = await uploadTask.whenComplete(() => print('Image uploaded.'));

        // Get the download URL
        String downloadURL = await taskSnapshot.ref.getDownloadURL();

        final String name = userNameStoreController.text;
        final String email = userEmailStoreController.text;
        final String contact = userContactStoreController.text;

        await _items.add({'url': downloadURL, "name": name, "email": email, "contact": contact});

        userNameStoreController.text = '';
        userEmailStoreController.text = '';
        userContactStoreController.text = '';

        // Show a toast message
        Fluttertoast.showToast(
          msg: "Data successfully registered in Firebase",
          backgroundColor: Colors.blueGrey,
          timeInSecForIosWeb: 5,
        );

        Navigator.of(context).pop();
      } else {
        print('No image selected');
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Image Upload In Firebase"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
                  child: _image != null
                      ? Image.file(_image!.absolute)
                      : Center(child: Icon(Icons.image)),
                ),
              ),
            ),
            Container(
                margin: EdgeInsets.all(15),
                child: TextField(
                    controller: userNameStoreController,
                    decoration: InputDecoration(
                      hintText: "Name",
                    ))),
            Container(
                margin: EdgeInsets.all(15),
                child: TextField(
                    controller: userEmailStoreController,
                    decoration: InputDecoration(
                      hintText: "Email",
                    ))),
            Container(
                margin: EdgeInsets.all(15),
                child: TextField(
                    controller: userContactStoreController,
                    decoration: InputDecoration(
                      hintText: "Contact",
                    ))),
            SizedBox(
              height: 20,
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(20),
              child: ElevatedButton(
                onPressed: () {
                  _uploadImage(); // Corrected the function call
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.green), // Background color
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // Text color
                ),
                child: Text("Upload"),
              ),
            )

          ],
        ),
      ),
    );
  }
}