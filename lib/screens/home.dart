import 'package:authsnow/User/login.dart';
import 'package:authsnow/screens/Listchat.dart';
import 'package:authsnow/screens/post.dart';
import 'package:authsnow/screens/profile.dart';
import 'package:authsnow/screens/publication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'publication.dart';

class Home extends StatefulWidget {
  Home({Key key, this.id}) : super(key: key);
  final String id;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var prefs;
  var email;
  var name;
  var pseudo;
  final firestoreInstance = FirebaseFirestore.instance;
  @override
  void initState() {
    super.initState();
    setValues();
  }

  void setValues() async {
    await firestoreInstance
        .collection('user')
        .where('idUser', isEqualTo: widget.id)
        .get()
        .then((QuerySnapshot value) {
      if (value.docs.isNotEmpty) {
        setState(() {
          email = value.docs[0]['email'];
          name = value.docs[0]['name'];
          pseudo = value.docs[0]['pseudo'];
        });
      }
    });
  }

  delete() async {
    prefs.remove('email');
    prefs.remove('name');
    Route route = MaterialPageRoute(builder: (context) => Login());
    Navigator.pushReplacement(context, route);
  }

  addUrlToFirestore(url, pseudo) async {
    await firestoreInstance
        .collection('images')
        .add({"url": url, 'pseudo': pseudo});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Snowy'),
          actions: [
            Container(
              width: 40,
              child: CircleAvatar(
                radius: 50.0,
                backgroundImage: NetworkImage(
                    "https://e7.pngegg.com/pngimages/1008/377/png-clipart-computer-icons-avatar-user-profile-avatar-heroes-black-hair.png"),
                backgroundColor: Colors.transparent,
              ),
            ),
          ],
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        backgroundColor: Colors.black,
        body: DefaultTabController(
          length: 4,
          child: Scaffold(
            body: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: [
                new Container(
                  child: Publication(
                    name: name,
                    email: email,
                    pseudo: pseudo,
                  ),
                ),
                new Container(
                  child: Listcontact(
                    email: email,
                    name: name,
                    pseudo: pseudo,
                  ),
                ),
                new Container(
                  child: Post(
                    email: email,
                    name: name,
                    pseudo: pseudo,
                  ),
                ),
                new Container(
                  child: Profile(
                    email: email == null ? '' : email,
                    name: name == null ? '' : name,
                    pseudo: pseudo == null ? '' : pseudo,
                  ),
                ),
              ],
            ),
            bottomNavigationBar: Container(
              color: Colors.black,
              child: TabBar(
                tabs: [
                  Tab(
                    icon: new Icon(Icons.home),
                  ),
                  Tab(
                    icon: new Icon(Icons.chat),
                  ),
                  Tab(
                    icon: new Icon(Icons.add),
                  ),
                  Tab(
                    icon: new Icon(Icons.person),
                  ),
                ],
                labelColor: Colors.yellow,
                unselectedLabelColor: Colors.white,
                indicatorSize: TabBarIndicatorSize.label,
                indicatorColor: Colors.transparent,
              ),
            ),
          ),
        ));
  }
}
