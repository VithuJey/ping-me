import 'package:flutter/material.dart';

import 'package:contacts_service/contacts_service.dart'; 
import 'package:permission_handler/permission_handler.dart';
import 'package:animated_floatactionbuttons/animated_floatactionbuttons.dart';
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


      floatingActionButton: AnimatedFloatingActionButton(
        //Fab list
        fabButtons: <Widget>[
            invokeContact(), invokeDayTime()
        ],
        colorStartAnimation: Colors.blue,
        colorEndAnimation: Colors.red,
        animatedIconData: AnimatedIcons.menu_close //To principal button
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

  Widget invokeContact() {
    return Container(
      child: FloatingActionButton(
        heroTag: null,
        onPressed: 
          // Invoke choose contact screen
          () async {
            List contacts = await PhoneContact().showMultiSelect(context, sortedContacts, selectedContacts);
            if(contacts != null){
              selectedContacts = contacts;
            }
            await getContactName(selectedContacts);
          },
        tooltip: 'First button',
        child: Icon(Icons.contacts),
      ),
    );
  }

  Widget invokeDayTime() {
    return Container(
      child: FloatingActionButton(
        heroTag: null,
        onPressed:
          // Invoke choose day-time screen 
          () async {
            dynamic result = await Navigator.pushNamed(context, '/day_time', arguments: dayTime);
            setState(() {
              dayTime = (result == null ? dayTime : result);
            });
          },
        tooltip: 'Second button',
        child: Icon(Icons.access_time),
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
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // IconButton(
                //   icon: Icon(
                //     Icons.cached,
                //     size: 20.0,
                //     color: Colors.blueGrey[500],
                //   ),
                //   onPressed: () {
                //     //   _onDeleteItemPressed(index);
                //   },
                // ),
                IconButton(
                  icon: Icon(
                    Icons.delete,
                    size: 20.0,
                    color: Colors.red[500],
                  ),
                  onPressed: () {
                    //   _onDeleteItemPressed(index);
                  },
                ),
              ],
            ),
          )
        );
      }
    } else if(type == "contact") {
      for(int index=0;index<typeList.length;index++) {
        list.add(
          ListTile(
            leading: CircleAvatar(
              backgroundImage: MemoryImage(typeList[index]["avatar"]),
            ),
            title: Text(typeList[index]["name"]),
            subtitle: Text(typeList[index]["phone"]),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.delete,
                    size: 20.0,
                    color: Colors.red[500],
                  ),
                  onPressed: () {
                    //   _onDeleteItemPressed(index);
                  },
                ),
              ],
            ),
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
      dynamic avatar;
      var con;

      print("PHONE");
      
      for(Contact contact in contacts) {
        phoneNum = contact.phones.first==null ? "error" : contact.phones.first.value;
        
        // email = contact.emails.first==null ? "error" : contact.emails.first.value;

        fullName = contact.displayName;

        avatar = contact.avatar;

        con = {"phone": phoneNum, "name": fullName, "email": email, "avatar": avatar };

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