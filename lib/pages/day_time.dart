import 'package:flutter/material.dart';

class DayTimePage extends StatefulWidget {
  @override
  _DayTimeState createState() => _DayTimeState();
}

class _DayTimeState extends State<DayTimePage> {

  List dayTime = [];
  // {"day":"Monday", "time":TimeOfDay(hour: 12,minute:00)}

  List<String> days = ["Select a day", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"];
  String _day;
  TimeOfDay _time;

  @override
  void initState() {
    super.initState();
    _day = "Select a day";
    _time = TimeOfDay(hour: 00,minute:00);
  }

  _popDataBack() async {

    Navigator.pop(context, dayTime);
  }

  @override
  Widget build(BuildContext context) {

    this.dayTime = this.dayTime.isEmpty ? ModalRoute.of(context).settings.arguments : this.dayTime;

    if(dayTime.isNotEmpty) {
      for(int i=0;i<dayTime.length;i++) {
        days.remove(dayTime[i]["day"]);
      }
    }
    
    return Scaffold(
      appBar: AppBar(
      title: Text("Select Day and Time"),
      backgroundColor: Colors.blue,

      ),
      body:Padding(
        padding: const EdgeInsets.all(20.0),
        child:Column(
          children: <Widget>[

            new Container(
              width: 360,
              child: 
                // Day_Dropdown
                DropdownButton<String>(
                  isExpanded: true,
                  items : days.map((String value){
                    return DropdownMenuItem<String>(
                    value :value,
                    child: Text (value)
                    );
                  }).toList(),
                  value: this._day,
                  onChanged:(String value) {
                      setState(() {
                        this._day = value;
                      });
                  }
                ),
            ),

            SizedBox(height: 10),
              
            // Time_Picker
            ListTile(
              title: (_time==TimeOfDay(hour: 00,minute:00))?Text("Select a time"):Text("${_time.hour}:${_time.minute}"),
              trailing: Icon(Icons.keyboard_arrow_down),
              onTap: _pickTime,
            ),

            SizedBox(height: 10),

            // Add Button
            // RaisedButton(onPressed: _clearAll, child: Text("Clear All")),
            RaisedButton(onPressed: _addDayTime, child: Text("Add", style: TextStyle(color: Colors.white),), shape: StadiumBorder(), highlightElevation: 2, elevation: 6, color: Colors.lightBlue[400],),

            SizedBox(height: 50),

            // List of Added Day-Time
            new Flexible(
              child: new ListView.builder
                (
                itemCount: dayTime.length,
                itemBuilder: (BuildContext context, int index) {
                  return new ListTile(
                    title: Text("${dayTime[index]["day"]} - ${dayTime[index]["time"].hour}:${dayTime[index]["time"].minute} "),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(
                            Icons.cancel,
                            size: 20.0,
                            color: Colors.red[500],
                          ),
                          onPressed: () {
                              _onDeleteItemPressed(index);
                          },
                        ),
                      ]
                    )
                  );
                }
              )
            ),


            // SizedBox(height: 20), 
            // List of Day-Time
            // dayTime.isNotEmpty ? Text("${dayTime.length} record added...") : Text("No day and time selected..."),           

          ],
        )
      ),
      // floatingActionButton: FloatingActionButton(onPressed: _popDataBack, tooltip: 'Save', child: Icon(Icons.save),),
    );
  }

  _pickTime() async {
    TimeOfDay t = await showTimePicker(
      context: context,
      initialTime: _time
    );    
    if(t != null)
    setState(() {
      _time = t;
    });
  }

  _addDayTime() {
    if (_day != "Select a day" && _time != TimeOfDay(hour: 00,minute:00)){
      this.dayTime.add({"day":this._day, "time":this._time});     
      days.remove(_day);
      setState(() {
        this._day = "Select a day";
        this._time=TimeOfDay(hour: 00,minute:00);
        this.dayTime = dayTime;
      });
    } else {
      return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Note'),
        content: const Text('Select a suitable Day and Time.'),
        actions: <Widget>[
          FlatButton(
            child: Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
    }
  }

  _onDeleteItemPressed(dynamic index) {
    this.dayTime.removeAt(index);
    setState(() {
      dayTime = dayTime;
    });
  }

  _clearAll() {
    this.dayTime.clear();
    setState(() {
      this.dayTime = [];
    });
  }
  
}