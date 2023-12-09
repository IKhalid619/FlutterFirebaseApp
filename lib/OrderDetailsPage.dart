import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class OrderDetailsPage extends StatefulWidget {
  final Map<String, dynamic>? data;

  const OrderDetailsPage({Key? key, this.data}) : super(key: key);

  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  int quantity = 1;

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
                    widget.data?['products_image'] ?? '',
                    width: 300,
                    height: 400,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 16),
                  Text('Product Title: ${widget.data?['product_title']}'),
                  Text('Seller ID: ${widget.data?['seller_id']}'),
                  Text('Description: ${widget.data?['product_dec']}'),
                  Text('Price: ${widget.data?['product_price']}'),
                  SizedBox(height: 16),
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
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Implement "Buy Now" functionality here
                      FirebaseFirestore.instance.collection('purchased_items').add({
                        'product_title': widget.data?['product_title'],
                        'seller_id': widget.data?['seller_id'],
                        'product_dec': widget.data?['product_dec'],
                        'product_price': widget.data?['product_price'],
                        'quantity': quantity,
                      }).then((value) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Item purchased successfully!')),
                        );
                      }).catchError((error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to purchase item: $error')),
                        );
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                      onPrimary: Colors.white,
                    ),
                    child: Text('Buy Now'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
