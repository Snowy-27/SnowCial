import 'package:authsnow/User/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  Profile({Key key, this.name, this.email, this.pseudo}) : super(key: key);
  final String name;
  final String email;
  final String pseudo;

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var prefs;

  @override
  void initState() {
    super.initState();
    loadShared();
  }

  void loadShared() async {
    prefs = await SharedPreferences.getInstance();
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
    prefs.remove('uid');
    Route route = MaterialPageRoute(builder: (context) => Login());
    Navigator.pushReplacement(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
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
                    style: GoogleFonts.hanaleiFill(
                        textStyle:
                            TextStyle(fontSize: 20, color: Colors.white)),
                  ),
                  Text(
                    widget.email,
                    style: GoogleFonts.hanaleiFill(
                        textStyle:
                            TextStyle(fontSize: 20, color: Colors.white)),
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
                    style: GoogleFonts.hanaleiFill(
                        textStyle:
                            TextStyle(fontSize: 20, color: Colors.white)),
                  ),
                  Text(
                    widget.name,
                    style: GoogleFonts.hanaleiFill(
                        textStyle:
                            TextStyle(fontSize: 20, color: Colors.white)),
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
                      style: GoogleFonts.hanaleiFill(
                          textStyle:
                              TextStyle(fontSize: 20, color: Colors.white)),
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
