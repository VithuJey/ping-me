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
  
  // selected day and time values
  List dayTime = [];
  // sortedContacts have all the contact details with name and phone number.
  List sortedContacts = [];
  // sortedContactsWithouSelected have all the contact details with name and phone number.
  // List sortedContactsWithouSelected = [];
  // selectedContacts have only selected contacts details with only phone number.
  List selectedContacts = [];
  // selectedContactAllDetails will have selected contacts details with name and phone number.
  List selectedContactAllDetails = [];

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
            Flexible(child: list("Contacts", "contact", selectedContactAllDetails)),
            Flexible(child: list("Day - Time", "day", dayTime)),
          ],
        ),
      ),
      
      floatingActionButton: FloatingActionButton(
        // onPressed: _incrementCounter,
        onPressed:
        // Invoke choose contact screen
        () async {
          List contacts = await PhoneContact().showMultiSelect(context, sortedContacts, selectedContacts);
          if(contacts != null){
            selectedContacts = contacts;
          }
          await getContactName(selectedContacts);
          // await removeSelectedFromSortedContacts();
        },
        // Invoke day-time screen
          // () async {
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

  // sortedContacts have all the contact details with name and phone number.
  // selectedContacts have only selected contacts details with only phone number.
  // selectedContactAllDetails will have selected contacts details with name and phone number.
  void getContactName(List selectedContacts){
    List selectedDetails = [];
    for(var i in selectedContacts){
      for(var j in sortedContacts){
        if(i == int.parse(j['phone'])) {
          selectedDetails.add(j);
        }
      }
    }
    setState(() {
      selectedContactAllDetails = selectedDetails;
    });
    print(selectedContactAllDetails);
  }

  // void removeSelectedFromSortedContacts(){
  //   List contactsWithouSelected = sortedContactsWithouSelected;
  //   for(int i=0;i<selectedContacts.length;i++){
  //     for(int j=0;j<sortedContacts.length;j++){
  //       if(i == int.parse(sortedContacts[j]['phone'])) {
  //         contactsWithouSelected.removeAt(j);
  //       }
  //     }
  //   }
  //   setState(() {
  //     sortedContactsWithouSelected = contactsWithouSelected;
  //   });
  // }

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
            title: Text(typeList[index]["name"]),
            subtitle: Text(typeList[index]["phone"]),
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
        // sortedContactsWithouSelected.add(con);
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