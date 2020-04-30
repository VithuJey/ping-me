import 'package:flutter/material.dart';
import 'package:contact_picker/contact_picker.dart';

class DetailsListPage extends StatefulWidget {
  // DetailsListPage({Key key, this.title}) : super(key: key);

  // final String title;

  @override
  _DetailsListState createState() => _DetailsListState();
}

class _DetailsListState extends State<DetailsListPage> {

  final ContactPicker _contactPicker = new ContactPicker();
  Contact _contact;
  
  List dayTime = [];

  @override
  Widget build(BuildContext context) {

    // this.dayTime = this.dayTime.isEmpty ? ModalRoute.of(context).settings.arguments : this.dayTime;
    print(dayTime);

    return Scaffold(
      appBar: AppBar(
      ),
      body: Container(
        padding: EdgeInsets.all(15.0),
        child: Column(
          children: <Widget>[Flexible(child: dayTimeList())],
        ),
      ),
      
      floatingActionButton: FloatingActionButton(
        // onPressed: _incrementCounter,
        onPressed: () async {
                  Contact contact = await _contactPicker.selectContact();
                  setState(() {
                    _contact = contact;
                    print(_contact);
                  });
                },
        
        // () async {
        //   dynamic result = await Navigator.pushNamed(context, '/day_time', arguments: dayTime);
        //   setState(() {
        //     dayTime = (result == null ? [] : result);
        //   });
        // },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget dayTimeList() {
  return SingleChildScrollView(
    child: Card(
      child: ExpansionTile(
        title: Text(
          "Day - Time",
          style: new TextStyle(),
          textAlign: TextAlign.center,
        ),
        children: ListMyWidgets(),
      ),
    ),
  );
}

  List<Widget> ListMyWidgets() {
    List<Widget> list = new List();
    for(int index=0;index<dayTime.length;index++) {
      list.add( 
        ListTile(
            title: Text("${dayTime[index]["day"]} - ${dayTime[index]["time"].hour}:${dayTime[index]["time"].minute} "),
            trailing: Icon(Icons.more_vert),
          ),
        
      );
    }
    return list;
  }

}

