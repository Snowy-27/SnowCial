import 'package:authsnow/User/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  Profile({Key key, this.name, this.email, this.pseudo}) : super(key: key);
  final String name;
  final String email;
  final String pseudo;

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  void logout() async {
    await FirebaseAuth.instance.signOut();

    Route route = MaterialPageRoute(builder: (context) => Login());
    Navigator.pushReplacement(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Home'),
          backgroundColor: Colors.blueGrey[600],
        ),
        backgroundColor: Colors.black,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              width: 342,
              height: 90,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'Email: ',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  Text(
                    widget.email,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              width: 342,
              height: 90,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'Nom: ',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  Text(
                    widget.name,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              width: 342,
              height: 90,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FlatButton(
                    child: Text(
                      'Se deconnecter',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    textColor: Colors.white,
                    onPressed: logout,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
