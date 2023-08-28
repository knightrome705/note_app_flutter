import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:note_app/Homepage.dart';
import 'package:note_app/Notes.dart';

class Notes extends StatefulWidget {
  const Notes({Key? key}) : super(key: key);

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  TextEditingController controller=TextEditingController();
  TextEditingController controller1=TextEditingController();
  Addnotes()async{
    var data={
      "title":controller.text,
      "content":controller1.text
    };
    Response response=await post(Uri.parse("http://192.168.1.34:8080/addNotes"),body:jsonEncode(data));
    if(response.statusCode==200){
     var data1=jsonDecode(response.body);
     if(data1["message"]=="inserted"){
       Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Homepage()));
     }

    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: Text("Notes"),
        centerTitle: true,
        elevation: 3,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          TextField(
            controller:controller ,
            decoration: InputDecoration(
              label: Text("Add a title"),
              border: OutlineInputBorder(
              )
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            controller:controller1 ,
            decoration: InputDecoration(
              label: Text("Enter Notes"),
              border: OutlineInputBorder()
            ),
          ),
          ElevatedButton(onPressed: (){
            Addnotes();
          }, child:Text("Add"))
        ],
      ),
    );
  }
}
