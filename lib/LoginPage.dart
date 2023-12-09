import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'BottomNavigation.dart';
import 'EditProfile.dart';
import 'PhoneAuth/SendOtp.dart';
import 'SignUpPage.dart';
// import 'auth/login.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();



  userLogin() async {
    var mAuth = FirebaseAuth.instance;
    try {
      await mAuth.signInWithEmailAndPassword(
          email: email.text, password: password.text);
      Fluttertoast.showToast(
          msg: "Login Successful ", textColor: Colors.white);

      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const BottomNavigation()));
    } catch (e) {
      Fluttertoast.showToast(msg: "Invalid email and password");
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: ListView(
        children: [
          Container(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 80),
                child: Text(
                  'Sign In',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.only(left: 50, top: 50, bottom: 5),
              child: Text(
                'Email',
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
                    // controller: user_email,

                    controller: email,
                    keyboardType: TextInputType.emailAddress,
                    cursorColor: Colors.white,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person),
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
                'Password',
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
                    // controller: user_password,

                    controller: password,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    cursorColor: Colors.white,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock),
                        hintText: "Enter your password",
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
              padding: const EdgeInsets.only(left: 220, top: 10),
              child: TextButton(
                  onPressed: () {
                    // Navigator.pushReplacement(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => ForgotPassword(),
                    //     ));
                  },
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  )),
            ),
          ),

          Container(
            child: Padding(
              padding: const EdgeInsets.only(left: 40, right: 40, top: 20),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 10,
                      padding: EdgeInsets.symmetric(
                          horizontal: 40.0, vertical: 20.0),
                      primary: Colors.white,
                      shape: StadiumBorder()),
                  onPressed: () {
                    userLogin();
                  },
                  child: Text(
                    'LOGIN',
                    style: TextStyle(color: Colors.red, fontSize: 20),
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              child: Center(
                  child: Text(
                    '- OR -',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 14),
            child: Container(
              child: Center(
                  child: Text(
                    'Sign In with',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  )),
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: Container(
                    child: SizedBox(
                      height: 60,
                      width: 60,
                      child: ElevatedButton(
                        onPressed: () {

                          signInWithGoogle();
                        },
                        child: Image(
                            image: NetworkImage(
                                'https://cdn-icons-png.flaticon.com/512/281/281764.png')),
                        style: ElevatedButton.styleFrom(
                            elevation: 10,
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50))),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 40, top: 25),
                  child: Container(
                    child: SizedBox(
                      height: 60,
                      width: 60,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PhoneNumber(),));
                        },
                        child: Image(
                            image: NetworkImage(
                                'https://cdn-icons-png.flaticon.com/128/3437/3437364.png')),
                        style: ElevatedButton.styleFrom(
                            elevation: 10,
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50))),
                      ),
                    ),
                  ),
                ),
              ],
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
                      "Don't have an Account?",
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
                                builder: (context) => SignUpPage(),
                              ));
                        },
                        child: Text(" Sign Up",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18))),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser
        ?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  BottomNavigation(),));
    return userCredential;

  }
}