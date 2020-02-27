import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:test8/SizeConfig.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test8/lobby.dart';
import 'package:test8/main.dart';

//enter question/answer
//display question
//display answers
//display winner
String qna;

class DbPage extends StatefulWidget {
  @override
  _DbPageState createState() => _DbPageState();
}
class _DbPageState extends State<DbPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Answer Votes')),
      body: Column(
        children: [_buildBody(context),

        TextFormField(
          onSaved: (input) => qna = input,
       ),
    RaisedButton(
                child: Text("submit"),
                onPressed: submitQ,
                color: Colors.red,
                textColor: Colors.yellow,
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                splashColor: Colors.grey,
              ),
          RaisedButton(
            child: Text("submit"),
            onPressed: submitA,
            color: Colors.red,
            textColor: Colors.yellow,
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            splashColor: Colors.grey,
          )])
      );

  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('users').snapshots(),
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
      key: ValueKey(record.answer),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
            title: Text(record.answer),
            trailing: Text(record.votes.toString()),
            onTap: () => record.reference.updateData({'votes': FieldValue.increment(1)})
        ),
      ),
    );
  }
}

class Record {
  final String answer;
  final int votes;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['answer'] != null),
        assert(map['votes'] != null),
        answer = map['answer'],
        votes = map['votes'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$answer:$votes>";
}

void submitQ(){
  Firestore.instance
      .collection('users')
      .document(currUser)
      .setData({
    'question': qna,
  });
}

void submitA(){
  Firestore.instance
      .collection('users')
      .document(currUser)
      .updateData({
    'answer': qna,
  });
}