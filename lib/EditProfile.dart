import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfirebaseapp/BottomNavigation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'Home.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  User? _user;
  File? _image;
  final picker = ImagePicker();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((event) {
      setState(() {
        _user = event;
        if (_user != null) {
          _fetchUserData();
        }
      });
    });
  }

  Future<void> _fetchUserData() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(_user!.uid)
          .get();

      if (userDoc.exists) {
        setState(() {
          _emailController.text = userDoc['email'] ?? '';
          _nameController.text = userDoc['name'] ?? '';
          _phoneController.text = userDoc['phone'] ?? '';
          _addressController.text = userDoc['address'] ?? '';
        });
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  Future<void> getImageGallery() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print("No Image Picked");
      }
    });
  }

  Future<void> getImageCamera() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print("No Image Picked");
      }
    });
  }

  Future<void> _updateUserProfile() async {
    if (_user != null) {
      try {
        if (_image != null) {
          await _uploadImageToFirebaseStorage();

          String imageUrl = await FirebaseStorage.instance
              .ref()
              .child("user_images/${_user!.uid}")
              .getDownloadURL();

          await FirebaseFirestore.instance
              .collection('users')
              .doc(_user!.uid)
              .update({'photoURL': imageUrl});
        }

        await FirebaseFirestore.instance
            .collection('users')
            .doc(_user!.uid)
            .update({
          'email': _emailController.text,
          'name': _nameController.text,
          'phone': _phoneController.text,
          'address': _addressController.text,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Profile updated successfully!"),
          ),
        );
      } catch (e) {
        print("Error updating profile: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error updating profile: $e"),
          ),
        );
      }
    }
  }

  Future<void> _uploadImageToFirebaseStorage() async {
    if (_image != null) {
      try {
        final storage = FirebaseStorage.instance;
        final Reference storageReference =
        storage.ref().child("user_images/${_user!.uid}");
        await storageReference.putFile(_image!);
        String imageUrl = await storageReference.getDownloadURL();
        print("Image uploaded to Firebase Storage: $imageUrl");
      } catch (e) {
        print("Error uploading image to Firebase Storage: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text("Edit Profile"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_user != null && _user!.photoURL != null)
              Center(
                child: InkWell(
                  onTap: () {
                    getImageGallery();
                  },
                  onDoubleTap: () {
                    getImageCamera();
                  },
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    height: 100,
                    width: 100,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: _image != null
                        ? Image.file(_image!.absolute)
                        : Center(
                      child: Image.network(
                        _user!.photoURL!,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            if (_user != null && _user!.email != null)
              Container(
                margin: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                child: TextField(
                  controller: _emailController,
                  onChanged: (newEmail) {},
                  decoration: InputDecoration(
                    hintText: _user!.email!,
                  ),
                ),
              ),
            Container(
              margin: const EdgeInsets.fromLTRB(15, 15, 15, 15),
              child: TextField(
                controller: _nameController,
                onChanged: (newName) {},
                decoration: InputDecoration(
                  hintText: "Name",
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(15, 15, 15, 15),
              child: TextField(
                controller: _phoneController,
                onChanged: (newPhone) {},
                decoration: InputDecoration(
                  hintText: "Phone",
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(15, 15, 15, 15),
              child: TextField(
                controller: _addressController,
                onChanged: (newAddress) {},
                decoration: InputDecoration(
                  hintText: "Address",
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(20),
              child: ElevatedButton(
                onPressed: () async {
                  await _updateUserProfile();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BottomNavigation(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.red, // Background color
                  onPrimary: Colors.white, // Text color
                ),
                child: const Text(
                  "Save Changes",
                  style: TextStyle(color: Colors.white), // Text color
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
