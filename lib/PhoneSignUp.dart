import 'package:flutterfirebaseapp/BottomNavigation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutterfirebaseapp/widgets/CustomElevatedButton.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'LoginPage.dart';



class PhoneSignUp extends StatefulWidget {
  const PhoneSignUp({super.key});

  @override
  State<PhoneSignUp> createState() => _PhoneSignUpState();
}


void navigateToBottomNavigation(BuildContext context) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => BottomNavigation()),
  );
}
class _PhoneSignUpState extends State<PhoneSignUp> {

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController address = TextEditingController();

  bool isLoading = false; // Track loading state


  Future<void> userData(BuildContext context) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final userData = {
          "id": user.uid, // Using user UID as the unique identifier
          "name": name.text,
          "email": email.text,
          "phone": phone.text,
          "address": address.text,
        };

        // Store user data in Firestore 'users' collection
        await FirebaseFirestore.instance.collection("users").doc(user.uid).set(userData);

        // Save the UID to SharedPreferences (optional, if needed for future sessions)
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('userDocId', user.uid);

        // Navigate to the desired screen after successful registration
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BottomNavigation(), // Navigate to the desired screen
          ),
        );
      } else {
        print('User is null, cannot proceed with user registration.');
        Fluttertoast.showToast(msg: 'Error: User is null');
      }
    } catch (e) {
      print('Error storing user data: $e');
      Fluttertoast.showToast(msg: 'Registration failed');
    }
  }




  Future<String?> getStoredDocId() async {
    final prefs = await SharedPreferences.getInstance();
    final storedDocId = prefs.getString('userDocId');
    return storedDocId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: ListView(
        children: [
          const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 100),
              child: Text(
                'Sign Up',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.only(left: 50, top: 50, bottom: 5),
            child: Text(
              'Full Name *',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 35, right: 35),
            child: SizedBox(
              height: 65,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                color: Colors.white54,
                shadowColor: Colors.black,
                elevation: 10,

                child: TextField(
                  //email authentication
                  controller: name,
                  keyboardType: TextInputType.text,
                  cursorColor: Colors.white,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      hintText: "Enter your name",
                      border: InputBorder.none,
                      iconColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(vertical: 18),
                      hintStyle:
                      TextStyle(color: Colors.white70, fontSize: 18),
                      // prefixIcon: Icon(Icons.person,),
                      prefixIconColor: Colors.white),
                ),
              ),
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.only(left: 50, top: 30, bottom: 5),
              child: Text(
                'Email *',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.only(left: 35, right: 35),
              child: SizedBox(
                height: 65,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: Colors.white54,
                  shadowColor: Colors.black,
                  elevation: 10,
                  child: TextField(
                    //email authentication
                    controller: email,
                    keyboardType: TextInputType.emailAddress,
                    cursorColor: Colors.white,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.mail),
                        hintText: "Enter your email",
                        border: InputBorder.none,
                        iconColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(vertical: 18),
                        hintStyle:
                        TextStyle(color: Colors.white70, fontSize: 18),
                        // prefixIcon: Icon(Icons.person,),
                        prefixIconColor: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.only(left: 50, top: 30, bottom: 5),
              child: Text(
                'Mobile No *',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.only(left: 35, right: 35),
              child: SizedBox(
                height: 65,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: Colors.white54,
                  shadowColor: Colors.black,
                  elevation: 10,
                  child: TextField(
                    //email authentication
                    controller: phone,
                    keyboardType: TextInputType.phone,
                    cursorColor: Colors.white,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.phone),
                        hintText: "Enter your Mobile No.",
                        border: InputBorder.none,
                        iconColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(vertical: 18),
                        hintStyle:
                        TextStyle(color: Colors.white70, fontSize: 18),
                        // prefixIcon: Icon(Icons.person,),
                        prefixIconColor: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.only(left: 50, top: 30, bottom: 5),
              child: Text(
                'Current Address *',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.only(left: 35, right: 35),
              child: SizedBox(
                height: 65,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: Colors.white54,
                  shadowColor: Colors.black,
                  elevation: 10,
                  child: TextField(
                    //email authentication
                    controller: address,
                    keyboardType: TextInputType.streetAddress,
                    cursorColor: Colors.white,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.add_location_alt),
                        hintText: "Enter your address",
                        border: InputBorder.none,
                        iconColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(vertical: 18),
                        hintStyle:
                        TextStyle(color: Colors.white70, fontSize: 18),
                        // prefixIcon: Icon(Icons.person,),
                        prefixIconColor: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          Container(
            child: Padding(
              padding: EdgeInsets.only(left: 40, right: 40, top: 30),
              child: CustomElevatedButton(
                elevation: 10,
                padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
                primary: Colors.white,
                shape: StadiumBorder(),
                onPressed: isLoading
                    ? null
                    : () async {
                  setState(() {
                    isLoading = true; // Set loading state to true
                  });

                  try {
                    // Simulate registration (replace this with your actual registration logic)
                    // Remove the 'some_fake_uid' assignment as it's not needed here

                    // Validate the form data before proceeding with registration
                    if (name.text.isNotEmpty &&
                        email.text.isNotEmpty &&
                        phone.text.isNotEmpty &&
                        address.text.isNotEmpty) {
                      await userData(context); // Call userData function with the context only
                    } else {
                      Fluttertoast.showToast(msg: 'Please fill in all fields');
                    }
                  } catch (e) {
                    // Handle registration errors
                    print('Error during registration: $e');
                    Fluttertoast.showToast(msg: 'Registration failed');
                  } finally {
                    setState(() {
                      isLoading = false; // Set loading state to false
                    });
                  }
                },


                child: isLoading
                    ? CircularProgressIndicator()
                    : Text(
                  'SUBMIT',
                  style: TextStyle(color: Colors.green, fontSize: 20),
                ),
              ),
            ),
          ),


          Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Text(
                      "If you have an Account?",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 18),
                    ),
                  ),
                  Container(
                    child: TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginPage(),
                              ));
                        },
                        child: Text(" Login",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18))),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
