import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:note_app/Homepage.dart';

class Edit extends StatefulWidget {
  String? title,content,id;
  Edit({required this.title,required this.content,required this.id});

  @override
  State<Edit> createState() => _EditState();
}

class _EditState extends State<Edit> {
  TextEditingController controller1=TextEditingController();
  TextEditingController controller2=TextEditingController();
  @override
  void initState() {
    controller1.text=widget.title.toString();
    controller2.text=widget.title.toString();
    // TODO: implement initState
    super.initState();
  }
  updataNote()async{
    var data={
      "title":controller1.text,
      "content":controller2.text,
        "id":widget.id.toString()
    };
    Response response=await post(Uri.parse("http://192.168.1.34:8080/updateNotes"),body: jsonEncode(data));
    if(response.statusCode==200){
      var data2=jsonDecode(response.body);
      print(data2);
      if(data2["message"]=="note updated"){
        Navigator.of(context).push(MaterialPageRoute(builder: (builder)=>Homepage()));
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: Text("Edit"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          TextField(
            decoration: InputDecoration(
              label: Text("title"),
              border: OutlineInputBorder()
            ),
            controller: controller1,
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            controller: controller2,
            decoration: InputDecoration(
              label: Text("content"),
              border: OutlineInputBorder()
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Center(child: ElevatedButton(onPressed: (){
            updataNote();
          }, child:Text("Edit")))
        ],
      ),
    );
  }
}
