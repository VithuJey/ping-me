import 'package:flutter/material.dart';

import 'package:contacts_service/contacts_service.dart'; 
import 'package:permission_handler/permission_handler.dart';
import 'package:ping_me/pages/phone_contact.dart';

class DetailsListPage extends StatefulWidget {
  // DetailsListPage({Key key, this.title}) : super(key: key);

  // final String title;

  @override
  _DetailsListState createState() => _DetailsListState();
}

class _DetailsListState extends State<DetailsListPage> {
  
  List dayTime = [];
  List sortedContacts = [];
  List selectedContacts = [];

  @override
  void initState() {
    getContactsFromPhone();
    super.initState();
  }

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
          children: <Widget>[
            Flexible(child: list("Day - Time", "day", dayTime)),
            Flexible(child: list("Contacts", "contact", selectedContacts))
          ],
        ),
      ),
      
      floatingActionButton: FloatingActionButton(
        // onPressed: _incrementCounter,
        onPressed:
        // Invoke choose contact screen
        () async {
          List contacts = await PhoneContact().showMultiSelect(context, sortedContacts);
          if(contacts != null){
            setState(() {
              selectedContacts = contacts;
              print(selectedContacts);
            });
          }
        },
        // Invoke day-time screen
          // () async {
            // getContactsFromPhone();
            // dynamic result = await Navigator.pushNamed(context, '/day_time', arguments: dayTime);
            // setState(() {
            //   dayTime = (result == null ? [] : result);
            // });
          // },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),

    );
  }

  Widget list(String title, String type, List typeList) {
  return SingleChildScrollView(
    child: Card(
      child: ExpansionTile(
        title: Text(
          title,
          style: new TextStyle(),
          textAlign: TextAlign.center,
        ),
        children: listMyWidgets(type, typeList),
      ),
    ),
  );

  }

  List<Widget> listMyWidgets(String type, List typeList) {
    List<Widget> list = new List();
    
    if(type == "day") {
      for(int index=0;index<typeList.length;index++) {
        list.add(
          ListTile(
            title: Text("${dayTime[index]["day"]} - ${dayTime[index]["time"].hour}:${dayTime[index]["time"].minute} "),
            trailing: Icon(Icons.more_vert),
          )
        );
      }
    } else if(type == "contact") {
      for(int index=0;index<typeList.length;index++) {
        list.add(
          ListTile(
            title: Text(typeList[index]["phone"]),
            trailing: Icon(Icons.more_vert),
          )
        );
      }
    }
    
    return list;
  }

  getContactsFromPhone() async {
    PermissionStatus permissionStatus = await _getContactPermission();
    if (permissionStatus == PermissionStatus.granted) {
      Iterable<Contact> contacts = await ContactsService.getContacts();

      String phoneNum, fullName, email;
      var con;

      print("PHONE");
      
      for(Contact contact in contacts) {
        phoneNum = contact.phones.first==null ? "error" : contact.phones.first.value;
        
        // email = contact.emails.first==null ? "error" : contact.emails.first.value;

        fullName = contact.displayName;

        con = {"phone": phoneNum, "name": fullName, "email":email};

        sortedContacts.add(con);
      }

      print(sortedContacts);
      
    }
  }

  Future<PermissionStatus> _getContactPermission() async {
    PermissionStatus permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.contacts);
    if (permission != PermissionStatus.granted && permission != PermissionStatus.disabled) {
      Map<PermissionGroup, PermissionStatus> permissionStatus = await PermissionHandler().requestPermissions([PermissionGroup.contacts]);
      return permissionStatus[PermissionGroup.contacts] ?? PermissionStatus.unknown;
    } else {
      return permission;
    }
  }

}





