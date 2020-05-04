import 'package:flutter/material.dart';

class PhoneContact {
  
  List <MultiSelectDialogItem<int>> multiItem = List();

  void populateMultiselect(List sortedContacts){
    for(var i in sortedContacts){
      multiItem.add(MultiSelectDialogItem(int.parse(i["phone"].replaceAll(' ', '')), i["name"]));
      print(i["phone"]  + i["name"]);
    }
  }

  // Return a list with selected contacts as Future<List>
  Future<List> showMultiSelect(BuildContext context, List sortedContacts, List selectedContacts) async {
    multiItem = [];
    populateMultiselect(sortedContacts);
    final items = multiItem;
    dynamic con = selectedContacts.isNotEmpty ? selectedContacts.toSet() : null;
    // print(selectedContacts.runtimeType);
    // print(con);
    // print(con.runtimeType);
    // print(null.runtimeType);

    final selectedValues = await showDialog<Set<int>>(
      context: context,
      builder: (BuildContext context) {
        return MultiSelectDialog(
          items: items,
          initialSelectedValues: con,
        );
      },
    );

    // print(selectedValues.toList());
    return selectedValues.toList();
  }

}

// SelectContact - Widget
// MultiSelect class
class MultiSelectDialogItem<V> {
  const MultiSelectDialogItem(this.value, this.label);

  final V value;
  final String label;
}

// MultiSelect Stateful Widget
class MultiSelectDialog<V> extends StatefulWidget {
  MultiSelectDialog({Key key, this.items, this.initialSelectedValues}) : super(key: key);

  final List<MultiSelectDialogItem<V>> items;
  final Set<V> initialSelectedValues;

  @override
  State<StatefulWidget> createState() => _MultiSelectDialogState<V>();
}

// MultiSelect State
class _MultiSelectDialogState<V> extends State<MultiSelectDialog<V>> {
  final _selectedValues = Set<V>();

  void initState() {
    super.initState();
    if (widget.initialSelectedValues != null) {
      _selectedValues.addAll(widget.initialSelectedValues);
    }
  }

  void _onItemCheckedChange(V itemValue, bool checked) {
    setState(() {
      if (checked) {
        _selectedValues.add(itemValue);
      } else {
        _selectedValues.remove(itemValue);
      }
    });
  }

  void _onCancelTap() {
    Navigator.pop(context);
  }

  void _onSubmitTap() {
    Navigator.pop(context, _selectedValues);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select contact'),
      contentPadding: EdgeInsets.only(top: 12.0),
      content: SingleChildScrollView(
        child: ListTileTheme(
          contentPadding: EdgeInsets.fromLTRB(14.0, 0.0, 24.0, 0.0),
          child: ListBody(
            children: widget.items.map(_buildItem).toList(),
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('CANCEL'),
          onPressed: _onCancelTap,
        ),
        FlatButton(
          child: Text('OK'),
          onPressed: _onSubmitTap,
        )
      ],
    );
  }

  Widget _buildItem(MultiSelectDialogItem<V> item) {
    final checked = _selectedValues.contains(item.value);
    return CheckboxListTile(
      value: checked,
      title: Text(item.label, textAlign: TextAlign.left),
      subtitle: Text(item.value.toString(), style: TextStyle(color: Colors.grey)),
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: (checked) => _onItemCheckedChange(item.value, checked),
    );
  }
}
