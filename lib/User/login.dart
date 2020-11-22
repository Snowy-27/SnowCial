import 'package:authsnow/User/registration.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:authsnow/screens/profile.dart';
import 'package:flutter/services.dart';

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);
  @override
  _Login createState() => _Login();
}

class _Login extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final firestore = FirebaseFirestore.instance;
  final emailHolder = TextEditingController();
  final passHolder = TextEditingController();
  var status = '';

  UserCredential userCredential;
  @override
  void initState() {
    super.initState();
  }

  void login() async {
    bool error = false;
    var user;
    try {
      userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailHolder.text,
        password: passHolder.text,
      );
    } catch (exp) {
      error = true;
      print(exp);
      setState(() {
        status = 'Email ou mdp invalide';
      });
    }

    if (error == false) {
      user = userCredential.user;
      print(user.uid);
      setState(() {
        status = user.email;
      });
      Route route = MaterialPageRoute(
          builder: (context) => Profile(
                email: user.email,
                name: 'dan',
                pseudo: 'snowy',
              ));
      Navigator.pushReplacement(context, route);
    }
    error = false;
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        backgroundColor: Colors.blueGrey[600],
      ),
      backgroundColor: Colors.blueGrey[900],
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
                  controller: emailHolder,
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
                'Connexion',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: login),
          Text(
            status == null ? '' : status.toString(),
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(
            height: 40,
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
              'Pas de compte s\'inscrire',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Registration()),
              );
            },
          ),
        ],
      ),
    );
  }
}
