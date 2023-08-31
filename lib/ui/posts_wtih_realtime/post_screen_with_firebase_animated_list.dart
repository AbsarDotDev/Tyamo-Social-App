import 'package:ecometsy/Utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class PostScreenFBAL extends StatefulWidget {
  const PostScreenFBAL({super.key});

  @override
  State<PostScreenFBAL> createState() => _PostScreenFBALState();
}

class _PostScreenFBALState extends State<PostScreenFBAL> {
  final auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.ref("Post");
  TextEditingController updateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Expanded(
        child: FirebaseAnimatedList(
            query: ref,
            itemBuilder: (context, snapshot, animation, index) {
              return ListTile(
                title: Text(snapshot.child('title').value.toString()),
                subtitle: Text(snapshot.child('id').value.toString()),
                trailing: PopupMenuButton(
                    color: Colors.white,
                    elevation: 4,
                    padding: EdgeInsets.zero,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(2))),
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
                                      snapshot.child('title').value.toString();
                                  showUpdateDialog(
                                      snapshot.child('id').value.toString());
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
                                    .child(
                                        snapshot.child('id').value.toString())
                                    .remove()
                                    .then((value) {
                                  Utils().showToastMessage("Deleted");
                                }).onError((error, stackTrace) {
                                  Utils().showToastMessage(error.toString());
                                });
                              },
                              leading: Icon(Icons.delete_outline),
                              title: Text('Delete'),
                            ),
                          ),
                        ]),
              );
            }),
      ),
    );
  }

  showUpdateDialog(String id) async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Container(
              child: Column(
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
