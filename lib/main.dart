import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);
  @override
  _MyApp createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
  }

  void addUser() async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: "barry.allen@example.com", password: "SuperSecretPassword!");
      print(userCredential.user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  void login() {}
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(''),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                child: Icon(Icons.app_registration),
                onPressed: addUser,
              ),
              FlatButton(
                child: Icon(Icons.login),
                onPressed: login,
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: addUser,
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
