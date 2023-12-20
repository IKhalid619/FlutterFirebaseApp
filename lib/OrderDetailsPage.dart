import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';

class OrderDetailsPage extends StatefulWidget {
  final Map<String, dynamic>? data;

  const OrderDetailsPage({Key? key, this.data}) : super(key: key);

  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  int quantity = 1;

  Future<String?> getCurrentUserID() async {
    final user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Order Details'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Card(
            margin: EdgeInsets.all(16.0),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Show the image here
                  Image.network(
                    widget.data?['products_image'] ?? '', // Provide the image URL here
                    width: 300, // Set the width as per your requirement
                    height: 400, // Set the height as per your requirement
                    fit: BoxFit.cover, // Adjust the fit as needed
                  ),
                  SizedBox(height: 16), // Add spacing between the image and other details
                  Text('Product Title: ${widget.data?['product_title']}'),
                  Text('Seller ID: ${widget.data?['seller_id']}'),
                  Text('Description: ${widget.data?['product_dec']}'),
                  Text('Price: ${widget.data?['product_price']}'),
                  SizedBox(height: 16), // Add spacing between the details and buttons
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          setState(() {
                            if (quantity > 1) {
                              quantity--;
                            }
                          });
                        },
                      ),
                      Text('$quantity'),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            quantity++;
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 16), // Add spacing between the quantity and "Buy Now" button
                  ElevatedButton(
                    onPressed: () async {
                      final currentUserID = await getCurrentUserID();
                      if (currentUserID != null) {
                        // Store details in a new collection in Firestore
                        FirebaseFirestore.instance.collection('purchased_items').add({
                          'user_id': currentUserID,
                          'product_title': widget.data?['product_title'],
                          'seller_id': widget.data?['seller_id'],
                          'product_dec': widget.data?['product_dec'],
                          'product_price': widget.data?['product_price'],
                          'quantity': quantity,
                          'products_image': widget.data?['products_image'],
                          // Add other necessary details
                        }).then((value) {
                          // Show a success message or navigate to a success page
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Item purchased successfully!')),
                          );
                        }).catchError((error) {
                          // Handle errors if any
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Failed to purchase item: $error')),
                          );
                        });
                      } else {
                        // Handle scenario when the user is not logged in
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please login to buy this item')),
                        );
                        // Redirect the user to the login page or any other action
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                      onPrimary: Colors.white,
                    ),
                    child: Text('Buy Now'),
                  ),
                  // Add other details as needed
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
