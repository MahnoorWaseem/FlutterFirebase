import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:first_app/auth/loginSceen.dart';
import 'package:first_app/firestore/firestoreAddScreen.dart';
import 'package:first_app/posts/addPost.dart';
import 'package:first_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FirestoreListScreen extends StatefulWidget {
  const FirestoreListScreen({super.key});

  @override
  State<FirestoreListScreen> createState() => _FirestoreListScreenState();
}

class _FirestoreListScreenState extends State<FirestoreListScreen> {
  final auth = FirebaseAuth.instance;
  // final SearchController = TextEditingController();
  final editController = TextEditingController();
  final firestore = FirebaseFirestore.instance
      .collection('users')
      .snapshots(); //this is snapshot

  CollectionReference ref =
      FirebaseFirestore.instance.collection('users'); //this is for ref

  bool hasMatches = false;

  Future<void> showMyDialog(String title, String id) async {
    editController.text = title;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Update'),
          content: Container(
            child: TextField(
              controller: editController,
              decoration: InputDecoration(hintText: 'Edit'),
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel')),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  ref.doc(id).update({
                    'title': editController.text.toString(),
                  }).then((value) {
                    Utils().succssMessage('Updated Successfully');
                  }).onError((error, stackTrace) {
                    Utils().toastMessage(error.toString());
                  });
                },
                child: Text('Update'))
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Posts (firestore)'),
        actions: [
          IconButton(
            onPressed: () {
              auth.signOut().then((value) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ));
              }).onError((error, stackTrace) {
                Utils().toastMessage(error.toString());
              });
            },
            icon: Icon(Icons.logout),
          ),
          SizedBox(
            width: 10,
          ),
        ],
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FirestoreAddScreen(),
              ));
        },
        child: Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            StreamBuilder(
              stream: firestore,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return CircularProgressIndicator();

                if (snapshot.hasError) return Text('Some error occured!');

                return Expanded(
                    child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final title =
                        snapshot.data!.docs[index]['title'].toString();
                    final id = snapshot.data!.docs[index]['id'].toString();
                    return ListTile(
                      title:
                          Text(snapshot.data!.docs[index]['title'].toString()),
                      trailing: PopupMenuButton(
                        icon: const Icon(Icons.more_vert),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                              value: 1,
                              //first child

                              child: ListTile(
                                onTap: () {
                                  Navigator.pop(context);
                                  showMyDialog(title, id);
                                },
                                leading: Icon(Icons.edit),
                                title: Text('Edit'),
                              )),
                          PopupMenuItem(
                              value: 2,
                              child: ListTile(
                                onTap: () {
                                  Navigator.pop(context);
                                  ref.doc(id).delete();
                                },
                                leading: Icon(Icons.delete),
                                title: Text('Delete'),
                              ))
                        ],
                      ),
                    );
                  },
                ));
              },
            ),
          ],
        ),
      ),
    );
  }
}

//we should put some checks t not allow any empty field o be submitted other =wise error in database and also while displaying the content..(not done in this cde)


//expalnation
// What is a Stream?
// A stream is a sequence of asynchronous events. In Dart, a stream provides a way to receive a series of values over time. Streams are often used for handling asynchronous data, such as data from a network request, user inputs, or real-time data updates.

// There are two main types of streams:

// Single-subscription streams: These can be listened to by only one listener at a time.
// Broadcast streams: These can be listened to by multiple listeners simultaneously.



// What is a Snapshot?
// A snapshot is a representation of the data at a particular point in time. In the context of Firestore, a snapshot contains the current data of a query or document, including any updates or changes since the last snapshot was received.

// In Firestore, snapshots are provided by streams, allowing you to listen for real-time updates. Each snapshot contains the data and metadata, such as the state of the connection and any errors that may have occurred.

// FirebaseFirestore.instance.collection('users').snapshots(): This creates a stream of snapshots from the 'users' collection in Firestore. It continuously listens for real-time updates in the 'users' collection and provides the snapshots to the firestore variable.

// StreamBuilder: A widget that builds itself based on the latest snapshot of interaction with a stream.
// stream: firestore: The stream that the StreamBuilder listens to. In this case, it listens to real-time updates from the 'users' collection in Firestore.
// builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot): A function that is called whenever the stream's state changes. It takes the current BuildContext and an AsyncSnapshot of the stream data.