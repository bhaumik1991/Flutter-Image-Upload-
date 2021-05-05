import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:path/path.dart' as Path;


class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {

  String title;
  File _image;
  final picker = ImagePicker();
  var storage = FirebaseStorage.instance;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text(
            "Upload a post",
            style: TextStyle(
                color: Colors.white
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                        onPressed: uploadPost,
                        child: Text(
                            "Post",
                          style: TextStyle(
                            color: Colors.white
                          ),
                        ),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Colors.green
                          )
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 12.0,),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Form(
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "What's on your mind?",
                          fillColor: Colors.black,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide()
                          )
                        ),
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                        onChanged: (val){
                          title = val;
                        },
                        maxLines: 2,
                      ),
                      SizedBox(height: 20,),
                      _image == null
                      ? Text("No image selected")
                      : Container(
                        height: 200,
                          width: MediaQuery.of(context).size.width,
                          child: Image.file(_image)
                      ),
                      SizedBox(height: 16,),
                      ElevatedButton(
                          onPressed: getImage,
                          child: Text("Add Image")
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future getImage() async{
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if(pickedFile != null){
        _image = File(pickedFile.path);
      }else{
        print("No Image selected");
      }
    });
  }

  void uploadPost() async{
    TaskSnapshot snapshot = await storage.ref().child("images/${Path.basename(_image.path)}").putFile(_image);
    if(snapshot.state == TaskState.success){
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      await FirebaseFirestore.instance.collection('users')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .collection('posts')
          .add({"title" : title, "url" : downloadUrl, "created" : DateTime.now()});
    }

    Navigator.of(context).pop();
  }
}
