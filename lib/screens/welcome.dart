import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Test extends StatefulWidget {
  Test({Key key, this.name, this.email, this.pseudo}) : super(key: key);
  final String name;
  final String email;
  final String pseudo;
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  var tes;
  final message = TextEditingController();
  final receiver = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String messageState = '';
  String receiverState = '';
  final firestoreInstance = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(
        title: Text('text'),
      ),
      body: Container(
          child: Column(
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  controller: message,
                  decoration: const InputDecoration(
                    icon: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                    labelText: 'Nom',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                  onChanged: (val) {
                    messageState = val;
                  },
                ),
                TextFormField(
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  controller: receiver,
                  decoration: const InputDecoration(
                    icon: Icon(
                      Icons.email,
                      color: Colors.white,
                    ),
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                  onChanged: (val) {
                    receiverState = val;
                  },
                ),
              ],
            ),
          ),
          RaisedButton(
            child: Text('send'),
            onPressed: () {
              firestoreInstance.collection("messages").add({
                'message': message.text,
                'pseudo': widget.pseudo,
                'corresponding': widget.pseudo + '+' + receiver.text,
                'receiver': receiver.text,
                'date': FieldValue.serverTimestamp(),
              });
            },
          )
        ],
      )),
    );
  }
}
