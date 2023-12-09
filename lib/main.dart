import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../BottomNavigation.dart';
import '../SplashScreen.dart';
import '../firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          storageBucket: 'gs://flutterfirebaseapp-9f04c.appspot.com',
          apiKey: 'AIzaSyB0CuRw5rqYxpSDXQmH-ppXDvctwYroRRw',
          appId: '1:340943489994:android:905339ffd1915c83b19d33',
          messagingSenderId: '340943489994',
          projectId: 'flutterfirebaseapp-9f04c'

      )

  );
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),

      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          return const BottomNavigation();
        }
        else {
          return const SplashScreen();

        }
      },
    );
  }
}
