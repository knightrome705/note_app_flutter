import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:note_app/Edit.dart';
import 'package:note_app/Notes.dart';
import 'package:note_app/NotesAdd.dart';

class Homepage extends StatefulWidget {


  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  var data;
  Future<dynamic> displayNotes()async{
   Response response=await get(Uri.parse("http://192.168.1.34:8080/getNotes"));
    if(response.statusCode==200){
       data=jsonDecode(response.body);
       return data;
    }

  }
  removeNotes(String id)async{
    var data3={
      "id":id
    };
   Response response=await post(Uri.parse("http://192.168.1.34:8080/removeNotes"),body:jsonEncode(data3));
   if(response.statusCode==200){
     var data5=jsonDecode(response.body);
     if(data5["message"]=="deleted"){
       setState(() {

       });

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
      ),
      body: FutureBuilder(
        future: displayNotes(),
        builder: (context,AsyncSnapshot snapshot) {


          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if(snapshot.hasData){
            return ListView.builder(
                itemCount:snapshot.data["message"].length,
                itemBuilder: (context,index) {

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (builder)=>Edit(title:snapshot.data["message"][index]["title"] ,content:snapshot.data["message"][index]["content"] ,id: snapshot.data["message"][index]["id"].toString(),)));
                      },
                      child: Container(
                        height: 100,
                        width: 550,
                        decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(15)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Stack(
                            children: [
                              Column(
                                children: [
                                  Align(
                                    alignment: Alignment.topRight,
                                      child: InkWell(
                                        onTap: (){
                                          removeNotes(snapshot.data["message"][index]["id"].toString());

                                        },
                                          child: Icon(Icons.delete,size: 30,))),
                                  Align(
                                    alignment: Alignment.center,
                                      child: Text(snapshot.data["message"][index]["title"])),
                                  Align(alignment:Alignment.center,
                                      child: Text(snapshot.data["message"][index]["content"]))
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );

                }
            );
          }
          else{
            return Center(child: Text("Something went wrong"),);
          }


        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:(){
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Notes()));
        },
      ),
    );
  }
}
