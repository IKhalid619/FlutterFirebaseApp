import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import the Firestore package

import 'EditProfile.dart';

class AccountBottomNav extends StatefulWidget {
  const AccountBottomNav({super.key});

  @override
  State<AccountBottomNav> createState() => _AccountBottomNavState();
}

class _AccountBottomNavState extends State<AccountBottomNav> {
  User? _user;
  String? _userName;
  String? _userEmail;
  String? _userPhone;
  String? _userAddress;
  // Add more variables for other user data (phone, address, etc.)

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((event) {
      setState(() {
        _user = event;

        // Fetch additional user information from Firestore
        if (_user != null) {
          FirebaseFirestore.instance
              .collection('users') // Replace with your Firestore collection name
              .doc(_user!.uid)
              .get()
              .then((DocumentSnapshot documentSnapshot) {
            if (documentSnapshot.exists) {
              setState(() {
                _userName = documentSnapshot['name'];
                _userEmail = documentSnapshot['email'];
                _userPhone = documentSnapshot['phone'];
                _userAddress = documentSnapshot['address'];
                // Fetch other user data as needed
              });
            }
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text('Account'),
      ),
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              if (_user != null && _user!.photoURL != null)
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(_user!.photoURL!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              SizedBox(height: 15,),
              if (_userName != null)
                Text(_userName!),
              if (_userEmail != null)
                Text(_userEmail!),
              if (_userPhone != null)
                Text(_userPhone!),
              if (_userAddress != null)
                Text(_userAddress!),
              Container(
                margin: EdgeInsets.all(10),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditProfile()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red, // Background color
                    onPrimary: Colors.white, // Text color
                  ),
                  child: Text(
                    "Edit Profile",
                    style: TextStyle(
                      color: Colors.white, // Text color if needed
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
