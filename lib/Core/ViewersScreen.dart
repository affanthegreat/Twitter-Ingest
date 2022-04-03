import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:twitter/Core/LoginForusers.dart';

import '../Designs/designs.dart';
import '../Model/Post.dart';
import 'LoginPage.dart';

class ViewersScreen extends StatefulWidget {
  const ViewersScreen({Key? key}) : super(key: key);

  @override
  _ViewersScreenState createState() => _ViewersScreenState();
}

class _ViewersScreenState extends State<ViewersScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.black,
      body: Align(
        alignment:Alignment.center,
        child: ConstrainedBox(
          constraints: BoxConstraints(
              maxWidth: 800
          ),
          child: ListView(
            children: [
              Container(
                  margin: EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("All Posts",style: TextStyle(color: Colors.white,fontSize: h2,fontWeight: FontWeight.bold),),
                      InkWell(
                        onTap: (){
                          FirebaseAuth.instance.signOut();
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginForUsers()));

                        },
                        child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade700,width: 2),
                              borderRadius: BorderRadius.circular(10)
                            ),
                            child: Container(
                                margin: EdgeInsets.all(5),
                                child: Text("Sign out",style: TextStyle(color: Colors.grey,fontSize: h4,fontWeight: FontWeight.normal),))),
                      ),
                    ],
                  )),
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("Posts")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if(snapshot.hasData){
                      var data = snapshot.data!.docs;
                      data = data.reversed.toList();
                      posts = [];
                      for (int i = 0; i < data.length; i++) {
                        var slotMap = data[i];
                        var temp = Post();
                        temp.TimeStamp = slotMap['timestamp'];
                        temp.index = posts.length;
                        temp.text = slotMap['text'];
                        temp.useremail = slotMap['username'];
                        temp.filename = slotMap['filename'];
                        //temp.hashtags = slotMap['hashtags'] as List<String>;
                        List<String> hashtags =[];
                        for(int j =0; j< slotMap['hashtags'].length; j++){
                          hashtags.add(slotMap['hashtags'][j]);
                        }
                        temp.hashtags = hashtags;
                        temp.url = slotMap['url'];
                        posts.add(temp);
                      }
                      if(data.isEmpty){
                        return Container(
                          margin: EdgeInsets.only(top: 100),
                          child: Center(
                            child: Text("You haven't post anything yet.",style: TextStyle(color: Colors.grey,fontSize: h4,fontWeight: FontWeight.bold),),
                          ),
                        );
                      }
                      return Align(
                        alignment: Alignment.topCenter,
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: posts.length,
                            itemBuilder: (context,index){
                              return posts[index].safeview(context);
                            }),
                      );
                    }
                    else{
                      return Center(child:CircularProgressIndicator());
                    }
                    return Container();

                  }
              ),
            ],
          ),
        ),
      ),
    );


  }
}
