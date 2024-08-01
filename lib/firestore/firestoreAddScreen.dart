import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:first_app/firestore/firestoreListScreen.dart';
import 'package:first_app/posts/postScreen.dart';
import 'package:first_app/utils/utils.dart';
import 'package:first_app/widgets/roundButton.dart';
import 'package:flutter/material.dart';

class FirestoreAddScreen extends StatefulWidget {
  const FirestoreAddScreen({super.key});

  @override
  State<FirestoreAddScreen> createState() => _FirestoreAddScreenState();
}

class _FirestoreAddScreenState extends State<FirestoreAddScreen> {
  final postController = TextEditingController();
  bool loading = false;
  final firestore = FirebaseFirestore.instance
      .collection('users'); //creating collections/documents

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Post (firestore)'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            TextFormField(
              controller: postController,
              decoration: InputDecoration(
                  hintText: "What's in your mind?",
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black))),
              maxLines: 4,
            ),
            SizedBox(
              height: 30,
            ),
            RoundButton(
                title: 'Add',
                loading: loading,
                onTap: () {
                  setState(() {
                    loading = true;
                  });
                  String id = DateTime.now().millisecondsSinceEpoch.toString();
                  firestore.doc(id).set({
                    'title': postController.text.toString(),
                    'id': id,
                  }).then((value) {
                    Utils().succssMessage('Post Added');
                    setState(() {
                      loading = false;
                      postController.text = '';
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FirestoreListScreen(),
                          ));
                    });
                  }).onError((error, stackTrace) {
                    Utils().toastMessage(error.toString());
                    setState(() {
                      loading = false;
                    });
                  });
                })
          ],
        ),
      ),
    );
  }
}



//in firestore, collection is like a node in firebase real time database (table). 
//in collection, we create documents (like child of ach node)
//in doc , it needs id ..if we donot given it will set on its own. doc id should be uniqu

//we can also create create multiple collections
//like 
//final firestore = FirebaseFirestore.instance.collection('products');
//final firestore = FirebaseFirestore.instance.collection('users');
//like multiple tables