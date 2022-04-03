import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:twitter/Core/LoginPage.dart';

import '../Designs/designs.dart';

class SideView extends StatelessWidget {
  const SideView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [



        Container(
          margin: EdgeInsets.only(top: 10,bottom: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(userdata['username']??"Null",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: h3),),
              CircleAvatar(
                radius: h3,
              ),
            ],
          ),
        ),
        Container(
          height: 30,
          margin: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: BorderRadius.circular(5)
          ),
          child: InkWell(
            onTap: (){
              FirebaseAuth.instance.signOut();
              if(FirebaseAuth.instance.currentUser == null){
                Navigator.pop(context);
              }
            },
            child: Center(
              child: Text("Sign out",style: TextStyle(color: Colors.grey,fontSize: h4,fontWeight: FontWeight.bold),),
            ),
          ),
        ),

        Wrap(
          children: [
            Container(
                margin: EdgeInsets.only(left: 10,right: 10),
                child: Text("Delete Account",style:  TextStyle(color: Colors.grey,fontSize: h5),)),
            Container(
                margin: EdgeInsets.only(left: 10,right: 10),
                child: Text("About",style:  TextStyle(color: Colors.grey,fontSize: h5),)),
            Container(
                margin: EdgeInsets.only(left: 10,right: 10),
                child: Text("Contact Us",style:  TextStyle(color: Colors.grey,fontSize: h5),)),

          ],
        )

      ],
    );
  }
}
