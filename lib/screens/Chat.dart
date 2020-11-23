import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  Chat({Key key, this.name, this.email, this.pseudo, this.receiver})
      : super(key: key);
  final String name;
  final String email;
  final String pseudo;
  final String receiver;

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  List messages = [];
  final messageHolder = TextEditingController();

  var st = '';
  var ist = false;
  final firestoreInstance = FirebaseFirestore.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  getMessage() {
    StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("messages")
          .where('corresponding',
              isEqualTo: widget.pseudo + '+' + widget.receiver)
          .orderBy('timestamp')
          .snapshots(),
      builder: (context, snapshot) {
        return !snapshot.hasData
            ? Container(
                width: 0,
                height: 0,
              )
            : ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot message = snapshot.data.documents[index];
                  return Text(message != null ? message.toString() : 'me');
                },
              );
      },
    );
  }

  _buildMessage(var message, bool isMe, var time) {
    final Container msg = Container(
      margin: isMe
          ? EdgeInsets.only(
              top: 8.0,
              bottom: 8.0,
              left: 80.0,
            )
          : EdgeInsets.only(
              top: 8.0,
              bottom: 8.0,
            ),
      padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
      width: (MediaQuery.of(context).size.width) * 0.75,
      height: 76,
      decoration: BoxDecoration(
        color: isMe ? Colors.indigo[500] : Colors.blueGrey[900],
        borderRadius: isMe
            ? BorderRadius.only(
                topLeft: Radius.circular(15.0),
                bottomLeft: Radius.circular(15.0),
              )
            : BorderRadius.only(
                topRight: Radius.circular(15.0),
                bottomRight: Radius.circular(15.0),
              ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            time.toString(),
            style: TextStyle(
              color: Colors.blueGrey,
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            message,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
    if (isMe) {
      return msg;
    }
    return Row(
      children: <Widget>[
        msg,
      ],
    );
  }

  _buildMessageComposer() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      height: 45.0,
      color: Colors.blueGrey[900],
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.photo),
            iconSize: 25.0,
            color: Theme.of(context).primaryColor,
            onPressed: () {},
          ),
          Expanded(
              child: Form(
            key: _formKey,
            child: TextFormField(
              style: TextStyle(color: Colors.white),
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration.collapsed(
                hintText: st,
              ),
              controller: messageHolder,
            ),
          )),
          IconButton(
            icon: Icon(Icons.send),
            iconSize: 25.0,
            color: Theme.of(context).primaryColor,
            onPressed: () {
              firestoreInstance.collection("messages").add({
                'message': messageHolder.text,
                'pseudo': widget.pseudo,
                'corresponding': widget.pseudo + '+' + widget.receiver,
                'receiver': widget.receiver,
                'heure': DateTime.now().hour.toString() +
                    DateTime.now().minute.toString() +
                    DateTime.now().second.toString(),
                'time': DateTime.now()
              });
              messageHolder.clear();
            },
          ),
        ],
      ),
    );
  }

  streamquery() {
    List<Stream<QuerySnapshot>> streams = [];
    final someCollection = FirebaseFirestore.instance.collection("messages");
    var firstQuery = someCollection
        .where('receiver', isEqualTo: widget.receiver)
        .snapshots();

    var secondQuery =
        someCollection.where('pseudo', isEqualTo: widget.pseudo).snapshots();

    streams.add(firstQuery);
    streams.add(secondQuery);

    return streams;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          widget.receiver,
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.more_horiz),
            iconSize: 30.0,
            color: Colors.white,
            onPressed: () {},
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
                child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    ),
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("messages")
                          .where('corresponding', whereIn: [
                            widget.pseudo + '+' + widget.receiver,
                            widget.receiver + '+' + widget.pseudo
                          ])
                          .orderBy("time", descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        return !snapshot.hasData
                            ? Text('PLease Wait')
                            : ListView.builder(
                                reverse: true,
                                padding: EdgeInsets.only(top: 15.0),
                                itemCount: snapshot.data.documents.length,
                                itemBuilder: (context, index) {
                                  DocumentSnapshot message =
                                      snapshot.data.documents[index];
                                  bool isMe = message['corresponding']
                                          .toString()
                                          .split('+')[1] !=
                                      widget.pseudo;
                                  var hourList = message['heure'];
                                  var hour = hourList[0] +
                                      hourList[1] +
                                      'h' +
                                      hourList[2] +
                                      hourList[3];
                                  messages.add(message.data);

                                  return _buildMessage(
                                      message['message'], isMe, hour);
                                },
                              );
                      },
                    )),
              ),
            ),
            _buildMessageComposer(),
          ],
        ),
      ),
    );
  }
}
