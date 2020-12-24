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

  like() {
    dataList = firestoreInstance
        .collection('images')
        .where('url', isEqualTo: currentUrl)
        .snapshots();

    return dataList;
  }

  getimage(bool widge, var index) {
    firestoreInstance
        .collection('images')
        .where('pseudo', isEqualTo: widget.name)
        .orderBy('timestamp', descending: true)
        .get()
        .then((QuerySnapshot value) {
      if (value.docs.isEmpty) {
        setState(() {
          status = 'Aucun image';
        });
        print('aucune ');
      } else if (index > value.docs.length) {
        setState(() {
          status = 'aucune image';
        });
      } else {
        for (var doc in value.docs) {
          setState(() {
            a.add(doc['url'].toString());
            count = doc.data().length;
          });
        }
      }
    });
    if (widge) {
      like();
      try {
        return Column(
          children: [
            Image.network(a[index].toString()),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Like: ' + '4',
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
            Divider(
              color: Colors.white,
              height: 50,
            ),
          ],
        );
      } catch (RangeError) {
        print('sqdd');
      }
    } else {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.black,
        child: ListView.builder(
          itemBuilder: (BuildContext ctx, int index) {
            return getimage(true, index);
          },
        ));
  }
}
