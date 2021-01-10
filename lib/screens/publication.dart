import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';

class Publication extends StatefulWidget {
  Publication({Key key, this.name, this.email, this.pseudo}) : super(key: key);
  final String name;
  final String email;
  final String pseudo;

  @override
  _Publication createState() => _Publication();
}

class _Publication extends State<Publication> {
  var email;
  var currentUrl = [];
  var likeNumber = 0;
  List a = [];
  var status;
  var prefs;
  var url;
  Stream dataList;
  var count = 0;
  bool oneTime = false;
  final picker = ImagePicker();
  final firestoreInstance = FirebaseFirestore.instance;
  Stream test;
  var icon = Ionicons.heart_outline;
  var liked = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: StreamBuilder(
        stream: firestoreInstance
            .collection("images")
            .orderBy('timestamp', descending: true)
            .snapshots(),
        // ignore: missing_return
        builder: (context, snapshot) {
          return !snapshot.hasData
              ? Container(
                  width: 0,
                  height: 0,
                )
              : ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot url = snapshot.data.documents[index];
                    return Column(
                      children: [
                        Container(
                          color: Colors.blueGrey[900],
                          height: 45,
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.only(left: 10),
                                height: 40,
                                width: 40,
                                child: CircleAvatar(
                                  radius: 50.0,
                                  backgroundImage: NetworkImage(
                                      "https://e7.pngegg.com/pngimages/1008/377/png-clipart-computer-icons-avatar-user-profile-avatar-heroes-black-hair.png"),
                                  backgroundColor: Colors.transparent,
                                ),
                              ),
                              SizedBox(
                                width: 40,
                              ),
                              Text(
                                url['pseudo'],
                                style: GoogleFonts.hanaleiFill(
                                  textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 2.4,
                              ),
                              ClipRRect(
                                  child: RaisedButton(
                                onPressed: () {
                                  print(MediaQuery.of(context).size.width);
                                },
                                child: Padding(
                                  child: Icon(
                                    Icons.more_vert,
                                    color: Colors.white,
                                  ),
                                  padding: EdgeInsets.only(left: 28),
                                ),
                                elevation: 0,
                                color: Colors.transparent,
                              ))
                            ],
                          ),
                        ),
                        Image.network(url['url']),
                        Row(
                          children: [
                            RaisedButton(
                                onPressed: () {
                                  if (!liked) {
                                    setState(() {
                                      icon = Ionicons.heart;
                                      liked = true;
                                    });
                                  } else {
                                    setState(() {
                                      icon = Ionicons.heart_outline;
                                      liked = false;
                                    });
                                  }
                                },
                                color: Colors.transparent,
                                child: Padding(
                                  child: Icon(
                                    icon,
                                    color: Colors.white,
                                  ),
                                  padding: EdgeInsets.only(
                                    right: 30,
                                  ),
                                ))
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    );
                  },
                );
        },
      ),
    );
  }
}
