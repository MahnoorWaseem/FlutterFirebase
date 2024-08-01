import 'package:firebase_database/firebase_database.dart';
import 'package:first_app/posts/postScreen.dart';
import 'package:first_app/utils/utils.dart';
import 'package:first_app/widgets/roundButton.dart';
import 'package:flutter/material.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final postController = TextEditingController();
  bool loading = false;
  final databaseRef = FirebaseDatabase.instance.ref(
      'Post'); //like creating table called post in the dattabase of the project called node -- can create mre tables like this
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Post'),
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
                  databaseRef
                      .child(
                          id) //creating a child with this id ---the id should be unique otherwise it would re write the previous id's content
                      .set({
                    'title': postController.text.toString(),
                    'id': id
                  }).then((value) {
                    setState(() {
                      loading = false;
                    });
                    Utils().succssMessage('Post has been Added!');
                    postController.clear();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PostScreen(),
                        ));
                  }).onError((error, stackTrace) {
                    setState(() {
                      loading = false;
                    });
                    Utils().toastMessage(error.toString());
                  });
                })
          ],
        ),
      ),
    );
  }
}


//insert
// for sub child

//  databaseRef.child(DateTime.now().millisecondsSinceEpoch.toString())
// .child('comments) // only this would be addded
// .set({
//  'title': postController.text.toString(),
//  'id': DateTime.now().millisecondsSinceEpoch.toString()
//      })
//.then((value) { .....


//fetch
//can be done using 2 ways 
//i. animated list (widget)
//ii. stream builder (streaam)
