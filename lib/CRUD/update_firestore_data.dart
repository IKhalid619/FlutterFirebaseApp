import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UpdateFirestoreData extends StatefulWidget {
  const UpdateFirestoreData({Key? key}) : super(key: key);

  @override
  State<UpdateFirestoreData> createState() => _UpdateFirestoreDataState();
}

class _UpdateFirestoreDataState extends State<UpdateFirestoreData> {
  final CollectionReference _items = FirebaseFirestore.instance.collection('UsersData');
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();
  File? _image;
  var taskSnapshot;


  Future getImageGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  final TextEditingController _searchController = TextEditingController();
  String searchText = '';

  var userUpdateNameStoreController = TextEditingController();
  var userUpdateEmailStoreController = TextEditingController();
  var userUpdateContactStoreController = TextEditingController();

  // for Update operation
  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      userUpdateNameStoreController.text = documentSnapshot['name'];
      userUpdateEmailStoreController.text = documentSnapshot['email'].toString();
      userUpdateContactStoreController.text = documentSnapshot['contact'].toString();
    }
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                right: 20,
                left: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: InkWell(
                    onTap: () {
                      getImageGallery();
                    },
                    child: Container(
                      margin: EdgeInsets.all(20),
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                        ),
                      ),
                      child: _image != null
                          ? Image.file(_image!.absolute)
                          : Center(child: Image.network(
                        documentSnapshot!['url'].toString(),
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),),
                    ),
                  ),
                ),
                Container(
                    margin: EdgeInsets.all(15),
                    child: TextField(
                        controller: userUpdateNameStoreController,
                        decoration: InputDecoration(
                          hintText: "Name",
                        ))),
                Container(
                    margin: EdgeInsets.all(15),
                    child: TextField(
                        controller: userUpdateEmailStoreController,
                        decoration: InputDecoration(
                          hintText: "Email",
                        ))),
                Container(
                    margin: EdgeInsets.all(15),
                    child: TextField(
                        controller: userUpdateContactStoreController,
                        decoration: InputDecoration(
                          hintText: "Contact",
                        ))),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: () async {
                      try {
                        if (_image != null) {
                          String imageName = DateTime.now().millisecondsSinceEpoch.toString();
                          Reference reference = _storage.ref().child('images/$imageName.jpg');
                          UploadTask uploadTask = reference.putFile(_image!);
                          taskSnapshot = await uploadTask.whenComplete(() => print('Image uploaded.'));

                          // Get the download URL
                          String downloadURL = await taskSnapshot.ref.getDownloadURL();

                          final String name = userUpdateNameStoreController.text;
                          final String email = userUpdateEmailStoreController.text;
                          final String contact = userUpdateContactStoreController.text;

                          await _items
                              .doc(documentSnapshot!.id)
                              .update({'url': downloadURL,"name": name, "email": email, "contact": contact});
                          userUpdateNameStoreController.text = '';
                          userUpdateEmailStoreController.text = '';
                          userUpdateContactStoreController.text = '';

                          Navigator.of(context).pop();
                        } else {
                          print('No image selected');
                        }
                      } catch (e) {
                        print('Error uploading image: $e');
                      }
                    },
                    child: const Text("Update"))
              ],
            ),
          );
        });
  }


  // for delete operation
  Future<void> _delete(String productID) async {
    await _items.doc(productID).delete();

    // for snackBar
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You have successfully deleted a itmes")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Update Register Data"),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(20),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search by Name',
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        searchText = _searchController.text;
                      });
                    },
                    icon: Icon(Icons.search),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: _items.snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                if (streamSnapshot.hasData) {
                  final List<DocumentSnapshot> items = streamSnapshot.data!.docs
                      .where((doc) =>
                      doc['name'].toLowerCase().contains(searchText.toLowerCase()))
                      .toList();
                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final DocumentSnapshot documentSnapshot = items[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          margin: const EdgeInsets.all(10),
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 17,
                              child: Image.network(
                                documentSnapshot['url'].toString(),
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text(
                              documentSnapshot['name'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            subtitle: Text(documentSnapshot['email'].toString()),
                            // Add other fields as needed
                            trailing: SizedBox(
                              width: 100,
                              child: Row(
                                children: [
                                  IconButton(
                                    color: Colors.black,
                                    onPressed: () {
                                      _update(documentSnapshot);
                                    },
                                    icon: const Icon(Icons.edit),
                                  ),
                                  IconButton(
                                    color: Colors.black,
                                    onPressed: () {
                                      _delete(documentSnapshot.id);
                                    },
                                    icon: const Icon(Icons.delete),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}