import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:first_app/auth/loginSceen.dart';
import 'package:first_app/posts/addPost.dart';
import 'package:first_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.ref('Post');
  final SearchController = TextEditingController();
  final editController = TextEditingController();

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

                  ref.child(id).update(
                      {'title': editController.text.toString()}).then((value) {
                    Utils().succssMessage('Updated Succesfully');
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
        title: Text('My Posts'),
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
                builder: (context) => AddPost(),
              ));
        },
        child: Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: TextFormField(
                controller: SearchController,
                decoration: InputDecoration(
                  hintText: 'Search',
                ),
                onChanged: (value) {
                  setState(() {});
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            // Text('Using Firebase animated list'),
            Expanded(
              child: FirebaseAnimatedList(
                query: ref,
                defaultChild: Padding(
                  padding: EdgeInsets.only(top: 20, left: 20),
                  child: Text('Loading'),
                ),
                itemBuilder: (context, snapshot, animation, index) {
                  final title = snapshot.child('title').value.toString();
                  final id = snapshot.child('id').value.toString();

                  if (SearchController.text.isEmpty) {
                    return ListTile(
                      title: Text(snapshot.child('title').value.toString()),
                      subtitle: Text(snapshot.child('id').value.toString()),
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
                                  ref
                                      .child(
                                          snapshot.child('id').value.toString())
                                      .remove();
                                },
                                leading: Icon(Icons.delete),
                                title: Text('Delete'),
                              )
                              )
                        ],
                      ),
                    );
                  } else if (title.toLowerCase().contains(
                      //if its not empty then it will skip the title which dont have serachController text in it
                      SearchController.text.toLowerCase().toString())) {
                    return ListTile(
                      title: Text(snapshot.child('title').value.toString()),
                      subtitle: Text(snapshot.child('id').value.toString()),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),

            // Text('Using Stream builder'),
            // Expanded(
            //     //couldn't understand it
            //     child: StreamBuilder(
            //   stream: ref.onValue,
            //   builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
            //     if (!snapshot.hasData) {
            //       return CircularProgressIndicator();

            //     } else {
            //       Map<dynamic, dynamic> map =
            //           snapshot.data!.snapshot.value as dynamic;
            //       List<dynamic> list = [];
            //       list.clear();
            //       list = map.values.toList();
            //       return ListView.builder(
            //         itemCount: snapshot.data!.snapshot.children.length,
            //         itemBuilder: (context, index) {
            //           return ListTile(
            //             title: Text(list[index]['title']),
            //             subtitle: Text(list[index]['id']),
            //           );
            //         },
            //       );
            //     }
            //   },
            // )),
          ],
        ),
      ),
    );
  }
}
