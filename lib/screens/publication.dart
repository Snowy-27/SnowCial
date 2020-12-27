import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:authsnow/ad_manager.dart';
import 'package:firebase_admob/firebase_admob.dart';

class Publication extends StatefulWidget {
  Publication({Key key, this.name, this.email, this.pseudo}) : super(key: key);
  final String name;
  final String email;
  final String pseudo;

  @override
  _Publication createState() => _Publication();
}

class _Publication extends State<Publication> {
  var ams = AdManager();
  BannerAd myBanner;

  @override
  void initState() {
    super.initState();
    FirebaseAdMob.instance.initialize(appId: ams.getappId());
    myBanner = BannerAd(
      adUnitId: 'ca-app-pub-1380656527637231/1560905200',
      size: AdSize.banner,
      listener: (MobileAdEvent event) {
        print("BannerAd event is $event");
      },
    );
    myBanner
      ..load()
      ..show(
        // Positions the banner ad 60 pixels from the bottom of the screen
        anchorOffset: 0.0,
        // Positions the banner ad 10 pixels from the center of the screen to the right
        horizontalCenterOffset: 0,
        // Banner Position
        anchorType: AnchorType.bottom,
      );
  }

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

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: StreamBuilder(
        stream: firestoreInstance
            .collection("images")
            .where('pseudo', isEqualTo: widget.pseudo)
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
                        Image.network(url['url']),
                        Container(
                          alignment: Alignment.bottomCenter,
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
