import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '투표 앱',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("투표"),
      ),
      body: _buildBody(
          context), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

Widget _buildBody(BuildContext context) {
  return StreamBuilder<QuerySnapshot>(
    stream: Firestore.instance.collection('option').snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return LinearProgressIndicator();
      return _buildList(context, snapshot.data.documents);
    },
  );
}

Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
  return ListView(
    padding: const EdgeInsets.only(top: 20),

    /** snapshot.map을 통해 Firebase에서 받아온 data를 list 형식으로 변경,
     *  buildListItem의 widget형태로 배열하여 render
     */
    children: snapshot.map((data) => _buildListItem(context, data)).toList(),
  );
}

Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
  // Firebase에서 받아오는 data : record
  final record = Record.fromSnapshot(data);

  return Padding(
    key: ValueKey(record.name),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5)),
      child: ListTile(
        // 위의 final record의 field중 name과 votes를 미리 지정해 두었기때문에 이용 가능
        title: Text(record.name),
        trailing: Text(record.votes.toString()),
        // Tap을 통해 Votes의 숫자를 증가시키고, 이를 firebase database에 등록시킴
        onTap: () =>
            record.reference.updateData({'votes': FieldValue.increment(1)}),
      ),
    ),
  );
}

// Record class로 이용하기 위해 정의함
class Record {
  final String name;
  final int votes;
  final DocumentReference reference;

  //Firebase database 에서 data를 받아 mapping 하는 부분
  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['votes'] != null),
        name = map['name'],
        votes = map['votes'];
  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$name:$votes>";
}
