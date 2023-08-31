import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecometsy/Utils/utils.dart';
import 'package:ecometsy/ui/auth/login.dart';
import 'package:ecometsy/ui/posts_wtih_firestore/add_post.dart';
import 'package:ecometsy/ui/posts_wtih_realtime/add_post.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class PostFireStore extends StatefulWidget {
  const PostFireStore({super.key});

  @override
  State<PostFireStore> createState() => _PostFireStoreState();
}

class _PostFireStoreState extends State<PostFireStore> {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance.collection('Posts').snapshots();
  final ref = FirebaseFirestore.instance.collection('Posts');
  TextEditingController search = TextEditingController();
  TextEditingController updateController = TextEditingController();

  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text('Fire Store'),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextFormField(
              controller: search,
              decoration: InputDecoration(
                hintText: "Search your post",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: firestore,
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Text("Error");
              }

              return Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final title =
                        snapshot.data!.docs[index]['title'].toString();
                    if (search.text.isEmpty) {
                      return ListTile(
                        title: Text(
                            snapshot.data!.docs[index]['title'].toString()),
                        subtitle:
                            Text(snapshot.data!.docs[index]['id'].toString()),
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
                                          updateController.text = snapshot
                                              .data!.docs[index]['title']
                                              .toString();
                                          showUpdateDialog(snapshot
                                              .data!.docs[index]['id']
                                              .toString());
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
                                            .doc(snapshot
                                                .data!.docs[index]['id']
                                                .toString())
                                            .delete()
                                            .then((value) {
                                          Utils().showToastMessage("Deleted");
                                        }).onError((error, stackTrace) {
                                          Utils().showToastMessage(
                                              error.toString());
                                        });
                                      },
                                      leading: Icon(Icons.delete_outline),
                                      title: Text('Delete'),
                                    ),
                                  ),
                                ]),
                      );
                    } else if (title
                        .toLowerCase()
                        .contains(search.text.toLowerCase().toString())) {
                      return ListTile(
                        title: Text(
                            snapshot.data!.docs[index]['title'].toString()),
                        subtitle:
                            Text(snapshot.data!.docs[index]['id'].toString()),
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
                                          updateController.text = snapshot
                                              .data!.docs[index]['title']
                                              .toString();
                                          showUpdateDialog(snapshot
                                              .data!.docs[index]['id']
                                              .toString());
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
                                            .doc(snapshot
                                                .data!.docs[index]['id']
                                                .toString())
                                            .delete()
                                            .then((value) {
                                          Utils().showToastMessage("Deleted");
                                        }).onError((error, stackTrace) {
                                          Utils().showToastMessage(
                                              error.toString());
                                        });
                                      },
                                      leading: Icon(Icons.delete_outline),
                                      title: Text('Delete'),
                                    ),
                                  ),
                                ]),
                      );
                    }
                  },
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddPostFireStore(),
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
                    ref.doc(id).update({
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
