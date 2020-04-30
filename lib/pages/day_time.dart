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
              
            // Time_Picker
            ListTile(
              title: (_time==TimeOfDay(hour: 00,minute:00))?Text("Select a time"):Text("${_time.hour}:${_time.minute}"),
              trailing: Icon(Icons.keyboard_arrow_down),
              onTap: _pickTime,
            ),

            // Add Button
            // RaisedButton(onPressed: _clearAll, child: Text("Clear All")),
            RaisedButton(onPressed: _addDayTime, child: Text("Add")),

            // List of Day-Time
            dayTime.isNotEmpty ? Text("${dayTime.length} record added...") : Text("No day and time selected...")

          ],
        )
      ),
      floatingActionButton: FloatingActionButton(onPressed: _popDataBack, tooltip: 'Save', child: Icon(Icons.save),),
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
    this.dayTime.add({"day":this._day, "time":this._time});     
    days.remove(_day);
    setState(() {
      this._day = "Select a day";
      this._time=TimeOfDay(hour: 00,minute:00);
      this.dayTime = dayTime;
    });
  }

  _clearAll() {
    this.dayTime.clear();
    setState(() {
      this.dayTime = [];
    });
  }
  
}