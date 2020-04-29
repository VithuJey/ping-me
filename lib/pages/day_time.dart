import 'package:flutter/material.dart';

class DayTimePage extends StatefulWidget {
  @override
  _DayTimeState createState() => _DayTimeState();
}

class _DayTimeState extends State<DayTimePage> {

  Map<String, TimeOfDay> _day_time = new Map<String, TimeOfDay>();

  List<String> days = ["Select a day", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"];
  String _day;
  TimeOfDay _time;

  @override
  void initState() {
    super.initState();
    _day = "Select a day";
    _time = TimeOfDay(hour: 00,minute:00);
  }


  @override
  Widget build(BuildContext context) {
    
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
                RaisedButton(onPressed: _addDayTime, child: Text("Add")),

              ],
            )
      )
      
    );
  }

  _pickTime() async {
    TimeOfDay t = await showTimePicker(
        context: context,
        initialTime: _time
      );    if(t != null)
        setState(() {
          _time = t;
        });  
  }

  _addDayTime() async {
      _day_time.putIfAbsent(_day, () => _time);      
      days.remove(_day);
      setState(() {
        _day = "Select a day";
        _time=TimeOfDay(hour: 00,minute:00);
      });
      print(days);
      print(_day_time);
  }
  
}