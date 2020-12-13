import 'package:authsnow/User/registration.dart';
import 'package:authsnow/screens/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  bool saveData = false;
  var prefs;
  UserCredential userCredential;
  @override
  void initState() {
    super.initState();
    loadShared();
  }

  void loadShared() async {
    prefs = await SharedPreferences.getInstance();
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
      if (user.emailVerified) {
        setState(() {
          status = user.email;
        });
        if (saveData) {
          prefs.setString('uid', user.uid);
        }
        Route route = MaterialPageRoute(
            builder: (context) => Home(
                  id: user.uid,
                ));
        Navigator.pushReplacement(context, route);
      } else {
        await user.sendEmailVerification();
        setState(() {
          status =
              'Un email de confirmation vient d\'etre envoyé, \n veuillez le confirmer \n puis vous reconnecter ';
        });
      }
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
                CheckboxListTile(
                  activeColor: Colors.red,
                  checkColor: Colors.yellow,
                  secondary: Icon(Icons.save, color: Colors.white),
                  title: Text(
                    "Se souvenir de moi",
                    style: TextStyle(color: Colors.white),
                  ),
                  value: saveData,
                  onChanged: (newValue) {
                    setState(() {
                      saveData = !saveData;
                    });
                  },
                )
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
