import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';

import 'LoginPage.dart';
import 'OrderDetailsPage.dart';
import 'cart.dart';

class HomeBottomNav extends StatefulWidget {
  const HomeBottomNav({Key? key}) : super(key: key);

  @override
  State<HomeBottomNav> createState() => _HomeBottomNavState();
}

class _HomeBottomNavState extends State<HomeBottomNav> {
  bool switchValue = false;
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    // Navigator.pushReplacementNamed(context, 'LoginPage');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9),
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text('Shopping Now...'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: signOut,
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('/products').snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          // ... Your existing StreamBuilder code
          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic>? data =
              document.data() as Map<String, dynamic>?;

              if (data == null ||
                  data['products_image'] == null ||
                  data['product_title'] == null ||
                  data['seller_id'] == null ||
                  data['product_dec'] == null ||
                  data['product_price'] == null) {
                return SizedBox(); // Skip rendering if any required field is null
              }

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          OrderDetailsPage(data: data),
                    ),
                  );
                },
                child: Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Image.network(
                      data['products_image']!,
                      width: 80,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                    title: Text(data['product_title']!),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Seller ID: ${data['seller_id']}'),
                        Text('Description: ${data['product_dec']}'),
                        Text('Price: ${data['product_price']}'),
                        SizedBox(height: 8),
                        // Remove the "Order Now" button
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}