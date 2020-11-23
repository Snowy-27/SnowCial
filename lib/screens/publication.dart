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
  var name;
  List a = [];
  var status;
  var prefs;
  var url;
  var count = 0;
  bool oneTime = false;
  final picker = ImagePicker();
  final firestoreInstance = FirebaseFirestore.instance;
  @override
  void initState() {
    super.initState();
  }

  addUrlToFirestore(url, pseudo) async {
    await firestoreInstance
        .collection('images')
        .add({"url": url, 'pseudo': pseudo});
  }

  createImage(var index) {}

  getimage(bool widge, var index, bool getimg) {
    if (getimg) {
      firestoreInstance
          .collection('images')
          .where('pseudo', isEqualTo: widget.name)
          .get()
          .then((QuerySnapshot value) {
        if (value.docs.isEmpty) {
          setState(() {
            setState(() {
              status = 'Aucun image';
            });
          });
        } else {
          for (var doc in value.docs) {
            setState(() {
              a.add(doc['url'].toString());
            });
            setState(() {
              count = a.length;
            });
          }
        }
      });
    }
    if (widge) {
      return Column(
        children: [
          Image.network(a[index].toString()),
          RaisedButton(
            child: Text('Download'),
            onPressed: () {},
          ),
          Divider(
            color: Colors.white,
            height: 50,
          )
        ],
      );
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
            return getimage(true, index, oneTime == true ? false : true);
          },
        ));
  }
}
