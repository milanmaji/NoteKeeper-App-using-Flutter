import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes/screens/note_list.dart';

void main(){
  
  runApp(noteApp());
  
}
class noteApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
   
    return MaterialApp(
      title: "Notes App",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.lightBlue
      ),
      home: NoteList(),
    ) ;
      
  }
  
  
  
  
}