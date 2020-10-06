import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes/models/note.dart';
import 'package:notes/utils/database_helper.dart';

class NoteDetail extends StatefulWidget {
  final String appBarTitle;
  final Note note;

  NoteDetail(this.note, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return NoteDetailState(this.note, this.appBarTitle);
  }
}

class NoteDetailState extends State<NoteDetail> {
  static var _priorities = ['High', 'low'];
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String appBarTitle;
  Note note;
  DatabaseHelper helper = DatabaseHelper();

  NoteDetailState(this.note, this.appBarTitle);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.headline6;
    titleController.text = note.title;
    descriptionController.text = note.description;
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            title: Text(appBarTitle),
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  moveToLastScreen();
                }),
          ),
          body: Padding(
            padding: EdgeInsets.only(
                top: 15.0, left: 10.0, right: 10.0, bottom: 15.0),
            child: ListView(
              children: [
                ListTile(
                  title: DropdownButton(
                    items: _priorities.map((String iteams) {
                      return DropdownMenuItem<String>(
                          value: iteams, child: Text(iteams));
                    }).toList(),
                    style: textStyle,
                    value: getPriorityAsString(note.priority),
                    onChanged: (valuSelectedByUser) {
                      setState(() {
                        debugPrint("user selected $valuSelectedByUser");
                        updatePriorityAsInt(valuSelectedByUser);
                      });
                    },
                  ),
                ),
                //second Element
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: titleController,
                    style: textStyle,
                    onChanged: (value) {
                      debugPrint("Something change in textField");
                      updateTitle();
                    },
                    decoration: InputDecoration(
                        labelText: "Title",
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        )),
                  ),
                ),
                //third Element
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: descriptionController,
                    onChanged: (value) {
                      debugPrint("something change in description textfield.");
                      updateDescription();
                    },
                    decoration: InputDecoration(
                        labelText: "Description",
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),
                //Fourth Element
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: Row(
                    children: [
                      Expanded(
                          child: RaisedButton(
                              color: Theme.of(context).primaryColorDark,
                              textColor: Theme.of(context).primaryColorLight,
                              child: Text(
                                "Save",
                                textScaleFactor: 1.5,
                              ),
                              onPressed: () {
                                debugPrint("Save button clicked");
                                _save();
                              })),
                      Container(
                        width: 5.0,
                      ),
                      Expanded(
                          child: RaisedButton(
                              color: Theme.of(context).primaryColorDark,
                              textColor: Theme.of(context).primaryColorLight,
                              child: Text(
                                "Delete",
                                textScaleFactor: 1.5,
                              ),
                              onPressed: () {
                                debugPrint("Delete button clicked");
                                _delete();
                              }))
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        onWillPop: () {
          moveToLastScreen();
        });
  }

  void moveToLastScreen() {
    Navigator.pop(context,true);
  }

  void updatePriorityAsInt(String value) {
    switch (value) {
      case 'High':
        note.priority = 1;
        break;
      case 'Low':
        note.priority = 2;
        break;
    }
  }

  String getPriorityAsString(int value) {
    String priority;
    switch (value) {
      case 1:
        priority = _priorities[0];
        break;
      case 2:
        priority = _priorities[1];
        break;
    }
    return priority;
  }

  void updateTitle() {
    note.title = titleController.text;
  }

  void updateDescription() {
    note.description = descriptionController.text;
  }

  void _save() async {

    moveToLastScreen();
    note.date=DateFormat.yMMMd().format(DateTime.now());
    debugPrint(note.date);
    int result;
    if (note.id != null) {
      result = await helper.updateNote(note);
    } else {
      result = await helper.insertNote(note);
    }


    if (result != 0) {
      _showAlertDialog('Status', 'Note Saved Successfully');
    } else {
      _showAlertDialog('Status', 'Problem Saving Note');
    }
  }

  void _delete() async{

    moveToLastScreen();
    //if new i.e no note present
    if(note.id==null){
      _showAlertDialog('Status', 'No Note was deleted');
      return;
    }
    //note id present
    int result=await helper.deleteNote(note.id);
    if (result != 0) {
      _showAlertDialog('Status', 'Note Deleted Successfully');
    } else {
      _showAlertDialog('Status', 'Error occoured while deleting note');
    }

  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );

    showDialog(context: context, builder: (_) => alertDialog);
  }


}
