import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart'; // For Image Picker
import 'package:firebase_storage/firebase_storage.dart'; // For File Upload To Firestore
import 'package:path/path.dart' as Path;
import 'dart:io';

class Post extends StatefulWidget {
  Post({Key key, this.name, this.email, this.pseudo}) : super(key: key);
  final String name;
  final String email;
  final String pseudo;

  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  File _image;
  var email;
  var name;
  var prefs;
  var url;
  final picker = ImagePicker();
  final firestoreInstance = Firestore.instance;
  Future chooseFile() async {
    // ignore: deprecated_member_use

    final pickedFile = await picker.getImage(
        source: ImageSource.gallery, maxHeight: 720, maxWidth: 720);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        uploadImageToFirebase(context);
      }
    });
  }

  Future uploadImageToFirebase(BuildContext context) async {
    String fileName = Path.basename(_image.path);
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('image/$fileName');
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    taskSnapshot.ref.getDownloadURL().then(
      (value) {
        setState(() {
          url = value.toString();
          addUrlToFirestore(url, widget.name);
        });
      },
    );

    setState(() {});
  }

  addUrlToFirestore(url, pseudo) async {
    await firestoreInstance
        .collection('images')
        .add({"url": url, 'pseudo': pseudo});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
          child: Center(
        child: ListView(
          children: [
            url == null
                ? Text('')
                : Column(
                    children: [
                      Text('Votre photo a ete publié'),
                      Image.network(url),
                    ],
                  ),
          ],
        ),
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: chooseFile,
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}
