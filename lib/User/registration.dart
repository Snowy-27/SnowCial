import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
  @override
  void initState() {
    super.initState();
  }

  void addUser() async {
    var error = false;
    var id;
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailHolder.text, password: passHolder.text);
      id = userCredential.user.uid;
    } on FirebaseAuthException catch (e) {
      error = true;
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        setState(() {
          status = 'Le mot de passe est trop court';
        });
      } else if (e.code == 'email-already-in-use') {
        setState(() {
          status = "Un compte avec cet email existe deja";
        });
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
    if (!error) {
      firestore.collection('user').add({
        'idUser': id.toString(),
        'email': emailHolder.text,
        'name': nameHolder.text,
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
    error = false;
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
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
              'logout',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: logout,
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
