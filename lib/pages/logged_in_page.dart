import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social/pages/upload.dart';
import 'package:flutter_social/provider/google_sign_in.dart';
import 'package:provider/provider.dart';

class LogginPage extends StatefulWidget {
  @override
  _LogginPageState createState() => _LogginPageState();
}

class _LogginPageState extends State<LogginPage> {
  CollectionReference reference = FirebaseFirestore.instance.collection('users')
      .doc(FirebaseAuth.instance.currentUser.uid)
      .collection('posts');

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "Flutter Social",
          style: TextStyle(
            color: Colors.white
          ),
        ),
        backgroundColor: Colors.blue,
        actions: [
          TextButton(
            onPressed: () {
              final provider =
              Provider.of<GoogleSignInProvider>(context, listen: false);
              provider.logout();
            },
            child: Text(
                'Logout',
              style: TextStyle(
                color: Colors.white
              ),
            ),
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: FutureBuilder<QuerySnapshot>(
          future: reference.get(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
            if(snapshot.connectionState == ConnectionState.done){
              return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, int index){
                    Map data = snapshot.data.docs[index].data();
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(snapshot.data.docs[index].data()["title"]),
                          SizedBox(height: 5,),
                          Image.network(
                            snapshot.data.docs[index].data()["url"],
                            height: 300,
                            width: 400,
                            fit: BoxFit.contain,
                          ),
                          Divider(),
                        ],
                      ),
                    );
                  }
              );
            }else if(snapshot.connectionState == ConnectionState.done){
              return Text("No data");
            }
            return Center(
                child: CircularProgressIndicator()
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => UploadPage()
            ),
          ).then((value) {
            setState(() {});
          });
        },
        child: Icon(Icons.upload_outlined),
      ),
    );
  }
}
