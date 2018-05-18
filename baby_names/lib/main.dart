
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// link codelab: https://codelabs.developers.google.com/codelabs/flutter-firebase/#1

void main()=> runApp(new MyApp());

class MyApp extends StatelessWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Baby Names',
      home: const MyHomePage(title: 'Baby Name Votes'),
    );

  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text(title),),
      body: new StreamBuilder(
          stream: Firestore.instance.collection('baby').snapshots(),
          builder: (context, snapshot) {
            if(!snapshot.hasData) return const Text('Loading...');
            return new ListView.builder(
                itemCount: snapshot.data.documents.length,
                padding: const EdgeInsets.only(top: 10.0),
                itemExtent:50.0,
                itemBuilder: (context, index) =>
                  _buildListItem(context, snapshot.data.documents[index]));
          }),
    );
  }

  _buildListItem(BuildContext context, document) {
    return new ListTile(
      key: new ValueKey(document.documentID),
      title: new Container(
        decoration: new BoxDecoration(
          border: new Border.all(color: const Color(0x80000000)),
          borderRadius: new BorderRadius.circular(5.0),
        ),
        padding: const EdgeInsets.all(10.0),
        child: new Row(
          children: <Widget>[
            new Expanded(
                child: Text(document['name']),
            ),
            new Text(
              document['votes'].toString(),
            )
          ],
        ),
      ),
      onTap: () => Firestore.instance.runTransaction((transaction) async {
        DocumentSnapshot freshSnap = await transaction.get(document.reference);
        await transaction.update(freshSnap.reference, {'votes': freshSnap['votes'] + 1});
      }),
    );
  }
}