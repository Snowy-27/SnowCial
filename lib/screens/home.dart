import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:snow/screens/Chat.dart';
import 'package:snow/screens/Listchat.dart';
import 'package:snow/screens/profile.dart';
import 'package:snow/screens/welcome.dart';
import 'publication.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snow/screens/publication.dart';
import 'package:snow/screens/post.dart';
import 'package:snow/users/connexion.dart';

class Home extends StatefulWidget {
  Home({Key key, this.name, this.email, this.pseudo}) : super(key: key);
  final String name;
  final String email;
  final String pseudo;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var prefs;
  final firestoreInstance = Firestore.instance;

  @override
  void initState() {
    super.initState();
    getShared();
  }

  getShared() async {
    prefs = await SharedPreferences.getInstance();
  }

  delete() async {
    prefs.remove('email');
    prefs.remove('name');
    Route route = MaterialPageRoute(builder: (context) => FormConnexion());
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
                    name: widget.name,
                    email: widget.email,
                    pseudo: widget.pseudo,
                  ),
                ),
                new Container(
                  child: Listcontact(
                    email: widget.email,
                    name: widget.name,
                    pseudo: widget.pseudo,
                  ),
                ),
                new Container(
                  child: Post(
                    email: widget.email,
                    name: widget.name,
                    pseudo: widget.pseudo,
                  ),
                ),
                new Container(
                  child: Profile(
                    email: widget.email,
                    name: widget.name,
                    deco: delete,
                    pseudo: widget.pseudo,
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
