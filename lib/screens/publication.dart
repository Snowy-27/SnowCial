import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Publication extends StatefulWidget {
  Publication({Key key, this.name, this.email, this.pseudo}) : super(key: key);
  final String name;
  final String email;
  final String pseudo;

  @override
  _Publication createState() => _Publication();
}

class _Publication extends State<Publication> {
  var email;
  var currentUrl = [];
  var likeNumber = 0;
  List a = [];
  var status;
  var prefs;
  var url;
  Stream dataList;
  var count = 0;
  bool oneTime = false;
  final picker = ImagePicker();
  final firestoreInstance = FirebaseFirestore.instance;
  Stream test;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: StreamBuilder(
        stream: firestoreInstance
            .collection("images")
            .where('pseudo', isEqualTo: widget.pseudo)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        // ignore: missing_return
        builder: (context, snapshot) {
          return !snapshot.hasData
              ? Container(
                  width: 0,
                  height: 0,
                )
              : ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot url = snapshot.data.documents[index];
                    return Image.network(url['url']);
                  },
                );
        },
      ),
    );
  }
}
