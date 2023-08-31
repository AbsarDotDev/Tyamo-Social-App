import 'dart:async';

import 'package:ecometsy/Utils/utils.dart';
import 'package:ecometsy/ui/auth/login.dart';
import 'package:ecometsy/ui/posts_wtih_realtime/add_post.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Post extends StatefulWidget {
  const Post({super.key});

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  final auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.ref("Post");
  TextEditingController updateController = TextEditingController();
  StreamSubscription? _streamSubscription; // Add this line

  @override
  void dispose() {
    _streamSubscription
        ?.cancel(); // Cancel the subscription when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text('Post screen'),
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
                  Utils().showToastMessage(error.toString());
                });
              },
              icon: Icon(Icons.logout)),
          SizedBox(
            width: 20,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: ref.onValue,
              builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                Map<dynamic, dynamic> map =
                    snapshot.data!.snapshot.value as dynamic;
                List<dynamic> list = [];
                list.clear();
                list = map.values.toList();
                return ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(list[index]['title']),
                      subtitle: Text(list[index]['id']),
                      trailing: PopupMenuButton(
                          color: Colors.white,
                          elevation: 4,
                          padding: EdgeInsets.zero,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(2))),
                          icon: Icon(
                            Icons.more_vert,
                            color: Colors.black,
                          ),
                          itemBuilder: (context) => [
                                PopupMenuItem(
                                  value: 1,
                                  child: PopupMenuItem(
                                    value: 2,
                                    child: ListTile(
                                      onTap: () {
                                        Navigator.pop(context);
                                        updateController.text =
                                            list[index]['title'];
                                        showUpdateDialog(list[index]['id']);
                                      },
                                      leading: Icon(Icons.edit),
                                      title: Text('Edit'),
                                    ),
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 2,
                                  child: ListTile(
                                    onTap: () {
                                      Navigator.pop(context);

                                      ref
                                          .child(list[index]['id'])
                                          .remove()
                                          .then((value) {
                                        Utils().showToastMessage("Deleted");
                                      }).onError((error, stackTrace) {
                                        Utils()
                                            .showToastMessage(error.toString());
                                      });
                                    },
                                    leading: Icon(Icons.delete_outline),
                                    title: Text('Delete'),
                                  ),
                                ),
                              ]),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddPost(),
                ));
          }),
    );
  }

  showUpdateDialog(String id) async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: updateController,
                    decoration: InputDecoration(
                      hintText: "Enter new",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel")),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ref.child(id).update({
                      'title': updateController.text.toLowerCase()
                    }).then((value) {
                      Utils().showToastMessage("Updated");
                    }).onError((error, stackTrace) {
                      Utils().showToastMessage(error.toString());
                    });
                  },
                  child: Text("Edit"))
            ],
          );
        });
  }
}
