import 'package:ecometsy/Utils/utils.dart';
import 'package:ecometsy/Widgets/round_button.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  bool loading = false;
  final TextEditingController title = TextEditingController();
  final databaseRef = FirebaseDatabase.instance.ref("Post");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Screen"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              controller: title,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Enter your name",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            RoundButton(
                title: "Send",
                loading: loading,
                ontap: () {
                  setState(() {
                    loading = true;
                  });
                  String id = DateTime.now().millisecondsSinceEpoch.toString();
                  databaseRef.child(id).set(
                      {"id": id, "title": title.text.toString()}).then((value) {
                    setState(() {
                      loading = false;
                    });
                    Utils().showToastMessage("Post added");
                  }).onError((error, stackTrace) {
                    setState(() {
                      loading = false;
                    });
                    Utils().showToastMessage(error.toString());
                  });
                })
          ],
        ),
      ),
    );
  }
}
