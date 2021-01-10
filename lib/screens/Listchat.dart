import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Chat.dart';

class Listcontact extends StatefulWidget {
  Listcontact({Key key, this.name, this.email, this.pseudo}) : super(key: key);
  final String name;
  final String email;
  final String pseudo;
  @override
  _ListcontactState createState() => _ListcontactState();
}

class _ListcontactState extends State<Listcontact> {
  final firestoreInstance = FirebaseFirestore.instance;

  _buildcontact(var pseudo, var lastmessage) {
    final Container msg = Container(
        padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
        height: 140,
        decoration: BoxDecoration(
          color: Color.fromRGBO(10, 4, 16, 1),
          borderRadius: BorderRadius.all(
            Radius.circular(15.0),
          ),
        ),
        child: Column(
          children: [
            Divider(
              color: Color.fromRGBO(122, 49, 196, 1),
            ),
            Expanded(
              child: FlatButton(
                focusColor: Colors.blue,
                color: Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(pseudo,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.hanaleiFill(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                          ),
                        )),
                  ],
                ),
                onPressed: () {
                  print(widget.name);
                  print(widget.email);
                  print(widget.pseudo);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Chat(
                              email: widget.email,
                              name: widget.name,
                              receiver: pseudo,
                              pseudo: widget.pseudo,
                            )),
                  );
                },
              ),
            ),
          ],
        ));

    return msg;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(10, 4, 16, 2),
      child: Container(
        child: ClipRRect(
            child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("contact").snapshots(),
          builder: (context, snapshot) {
            return !snapshot.hasData
                ? Text('PLease Wait')
                : ListView.builder(
                    padding: EdgeInsets.only(top: 15.0),
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot message = snapshot.data.documents[index];
                      bool isNotMe = message['pseudo'] != widget.pseudo;
                      return isNotMe
                          ? _buildcontact(
                              message['pseudo'],
                              '',
                            )
                          : Container(
                              width: 0,
                              height: 0,
                            );
                    },
                  );
          },
        )),
      ),
    );
  }
}
