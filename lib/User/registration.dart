import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Registration extends StatefulWidget {
  Registration({Key key}) : super(key: key);
  @override
  _Registration createState() => _Registration();
}

class _Registration extends State<Registration> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final firestore = FirebaseFirestore.instance;
  final emailHolder = TextEditingController();
  final passHolder = TextEditingController();
  final nameHolder = TextEditingController();
  final pseudoHolder = TextEditingController();

  var status = '';

  var error = 'no';
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.blueGrey[900],
    ));
  }

  void addUser() async {
    var id;
    try {
      await firestore
          .collection('user')
          .where('pseudo', isEqualTo: pseudoHolder.text)
          .get()
          .then((QuerySnapshot value) {
        if (pseudoHolder.text == value.docs[0]['pseudo']) {
          setState(() {
            status = 'Ce pseudo est deja utilisé';
            error = 'yes';
          });
        }
      });
    } catch (e) {
      print(e);
    }
    print('________________0' +
        error.toString() +
        ' ççççççççççççççççççççççççççç');
    
    if (error == 'no') {
      print('--------------------' + error.toString() + '----------------');
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailHolder.text, password: passHolder.text);
        id = userCredential.user.uid;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          setState(() {
            status = 'Le mot de passe est trop court';
            error = 'yes';
          });
        } else if (e.code == 'email-already-in-use') {
          setState(() {
            error = 'yes';
            status = "Un compte avec cet email existe deja";
          });
        }
      } catch (e) {
        print(e);
        error = 'yes';
      }
    }
    if (error == 'no') {
      var tok;
      final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

      await _firebaseMessaging.getToken().then((token) {
        setState(() {
          tok = token.toString();
        });
        print(_firebaseMessaging.getToken().then((token) {
          print(token);
        }));
      });
      firestore.collection('user').add({
        'idUser': id.toString(),
        'email': emailHolder.text,
        'name': nameHolder.text,
        'pseudo': pseudoHolder.text,
        'token': tok,
        'liked': [],
      });
      await firestore.collection("contact").add({
        'pseudo': pseudoHolder.text,
      });
      User user = FirebaseAuth.instance.currentUser;
      await user.sendEmailVerification();
      setState(() {
        status =
            "Inscription Reussi \n vous allez recevoir un mail de confiramtion";
      });
      pseudoHolder.clear();
      passHolder.clear();
      emailHolder.clear();
      nameHolder.clear();
    }
    error = 'no';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[700],
        title: Text('Dan'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Form(
              key: _formKey,
              child: Column(children: [
                TextFormField(
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  controller: nameHolder,
                  decoration: const InputDecoration(
                    icon: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                    labelText: 'Name',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                  onChanged: (val) {},
                ),
                TextFormField(
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  controller: pseudoHolder,
                  decoration: const InputDecoration(
                    icon: Icon(
                      Icons.people_alt_outlined,
                      color: Colors.white,
                    ),
                    labelText: 'pseudo',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                  onChanged: (val) {},
                ),
                TextFormField(
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  controller: emailHolder,
                  enableSuggestions: false,
                  decoration: const InputDecoration(
                    icon: Icon(
                      Icons.email,
                      color: Colors.white,
                    ),
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                  onChanged: (val) {},
                ),
                TextFormField(
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  controller: passHolder,
                  enableSuggestions: false,
                  autocorrect: false,
                  obscureText: true,
                  decoration: const InputDecoration(
                    icon: Icon(
                      Icons.lock,
                      color: Colors.white,
                    ),
                    labelText: 'Mot de passe',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                  onChanged: (val) {},
                ),
              ])),
          FlatButton(
            child: Text(
              'Inscription',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: addUser,
          ),
          Text(status == null ? '' : status.toString(),
              style: TextStyle(
                color: Colors.white,
              )),
          SizedBox(
            height: 20,
          ),
          FlatButton(
            child: Text(
              'Vous avez deja un compte, se connecter',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
