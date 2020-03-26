import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'package:test8/main.dart';
import 'package:test8/room.dart';
import 'package:test8/GameScreenQ.dart';
import 'package:test8/lobby.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test8/lobbyO.dart';
import 'package:test8/lobbyJ.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

String joinRoomNum;

class lobbyPage extends StatefulWidget {
  @override
  _lobbyState createState() => _lobbyState();
}

class _lobbyState extends State<lobbyPage> {
  int roomDocIndex;
  String player1;
  String player2;
  String _roomNum;
  final myController = TextEditingController();
  int roomListLength;
  AudioCache _audioCache;
  @override
  void initState() {
    super.initState();
    _audioCache = AudioCache(prefix: "audio/", fixedPlayer: AudioPlayer()..setReleaseMode(ReleaseMode.STOP));
  }

//  int room() async{
//    var ran = await Firestore.instance
//        .collection('gameSessions').getDocuments();
//    int xx = ran.documents.length;
//    return xx;
//  }
//  void initState(){
//    int z;
//    //var x = Firestore.instance
//      //.collection('gameSessions').getDocuments().then((var y)=>z = y.documents.length);
//    Firestore.instance
//        .collection('gameSessions').getDocuments().then((var y)=>roomListLength = y.documents.length);
//   // x.then((var y)=>z = y.documents.length);
//    print("xx");
//    z = await room();
//   print(room());
//   print('zz');
//  }
//  Widget roomList(BuildContext context){
//    return ListView.builder(
//
//        itemCount: ,
//        itemBuilder: (context, index) => Text(names[index])
//    )
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("lobby"),
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () async {
                  _audioCache.play('button.mp3');
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyApp()));
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
        ),
        body: Column(children: [
          RaisedButton(
            child: Text("Start a Room"),
            onPressed: () {
              _audioCache.play('button.mp3');
              startRoom();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => lobbyOPage()));
            },
            color: Colors.orangeAccent,
            textColor: Colors.white,
            padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
            splashColor: Colors.grey,
          ),
          TextField(
            controller: myController,
          ),
          RaisedButton(
            child: Text("Join a Room"),
            onPressed: () {
              _audioCache.play('button.mp3');
              joinRoom();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => lobbyJPage()));
            },
            color: Colors.orangeAccent,
            textColor: Colors.white,
            padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
            splashColor: Colors.grey,
          ),

          Flexible(
            child: _buildBody(context),
          ),
          //roomList(context)
        ]));
//    }
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('gameSessions').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = Record.fromSnapshot(data);
    return Padding(
      key: ValueKey(record.name),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
            title: Text(record.name),
            trailing: Text("0"),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => MyRoom()));
              joinRoomNum = record.name;
            }),
      ),
    );
  }

  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  int roomListNumber() {
    int z;
    //x.then((var y)=>z = y.documents.length);
    return z;
    //print(z);
  }

  void startRoom() {
    var randNum = new Random();
    //print(currUser);
    _roomNum = randNum.nextInt(10000).toString();

    //print(_roomNum);
    if (currUser != null) {
      Firestore.instance.collection('gameSessions').document(_roomNum).setData({
        'GameOpen': false,
        'roomNumber': _roomNum,
      });
      Firestore.instance
          .collection('gameSessions')
          .document(_roomNum)
          .collection('players')
          .document(currUser)
          .setData({
        'question': '',
        'answer': '',
      });
      Firestore.instance
          .collection('users')
          .document(currUser)
          .updateData({'room': _roomNum, 'owner': true});
    }
  }

  void joinRoom() async {
    _roomNum = myController.text;

    //print(getPlayers().then((onValue)=>print(onValue)));
    // print(getPlayers());
    //print("ii");
    //print(_roomNum);

//      List<DocumentSnapshot> templist;
//
//      var players = Firestore.instance.collection('gameSessions').getDocuments().toString();

    //List<String> players = (List<String>) Firestore.instance.collection('gameSessions').
    //List<String> group = (List<String>) document.get("dungeon_group");
    //var testing =  players.docs.map(doc => doc.data());

//      var list = templist.map((DocumentSnapshot players){
//        return players.data;
//      }).toList();

//    List<DocumentSnapshot> templist;
//    List<Map<dynamic, dynamic>> list = new List();
//    CollectionReference collectionRef = Firestore.instance.collection(
//        "gameSessions");
//    QuerySnapshot collectionSnapshot = await collectionRef.getDocuments();
//
//    templist = collectionSnapshot.documents;
//
//    list = templist.map((DocumentSnapshot docSnapshot) {
//      return docSnapshot.data;
//    }).toList();
//
//    var room;
//
//    for (var i = 0; i < list.length; i++) {
//      print(_roomNum);
//      if (list[i]["roomNumber"] == _roomNum) {
//        room = list[i];
//      }
//    }
//
//    int numPlayers = 1;
//    for (var key in room.keys) {
//      if (key.startsWith("player")) numPlayers++;
//    }
///////////////////////////////////////////
    //   var playerNumString = "player" + numPlayers.toString();

    if (currUser != null) {
      Firestore.instance
          .collection('gameSessions')
          .document(_roomNum)
          .collection('players')
          .document(currUser)
          .setData({
        'question': '',
        'answer': '',
      });
      Firestore.instance
          .collection('users')
          .document(currUser)
          .updateData({'room': _roomNum, 'owner': false});
      print(_roomNum + "ii");
    }
  }

  // this function grabs and returns a list of players in a specified gameSession
  Future<List<String>> getPlayers() async {
//      var grabtest = Firestore.instance.collection('gameSessions').document(_roomNum).collection('players').getDocuments();
//
//      _roomNum = 7382.toString();

    List<DocumentSnapshot> templist;
    List<String> list = new List();
    CollectionReference collectionRef = Firestore.instance
        .collection('gameSessions')
        .document(_roomNum)
        .collection('players');
    QuerySnapshot collectionSnapshot = await collectionRef.getDocuments();

    templist = collectionSnapshot.documents; // <--- ERROR

    list = templist.map((DocumentSnapshot docSnapshot) {
      return docSnapshot.documentID;
    }).toList();
    //print(list);
    //print("00 ");

//    print("before testing print line !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
//      print(list);
//      for (var i = 0; i < list.length; i++) {
//        print(list[i]);
//      }
//    print("after testing print line  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");

    return list;
  }

  Future completeRoom(context) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => MyGame()));
  }

  Future<QuerySnapshot> getDocuments() async {
    return await Firestore.instance
        .collection('gameSessions')
        .document(_roomNum)
        .collection('players')
        .getDocuments();
  }
}

class Record {
  final String name;

  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['roomNumber'] != null),
        name = map['roomNumber'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$name>";

}










