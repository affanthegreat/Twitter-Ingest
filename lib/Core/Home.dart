import 'dart:html';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:twitter/Core/SideView.dart';
import 'package:twitter/Designs/designs.dart';
import 'dart:ui' as ui;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../Model/Post.dart';
import 'LoginPage.dart';
import 'dart:math';
import 'package:http/http.dart' as http;


firebase_storage.FirebaseStorage storage =
    firebase_storage.FirebaseStorage.instance;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var newPost = Post();
  var text = "";
  var hashtags = "";
  int random(min, max) {
    return min + Random().nextInt(max - min);
  }
  var isLoading = false;

  Future<bool> checkUsersDetails(dynamic map) async {
    DocumentSnapshot ds = await FirebaseFirestore.instance
        .collection("Users")
        .doc(map['useremail'])
        .get();
    return ds.exists;
  }
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  File? _photo;
  Uint8List? bytesFromPicker = null;

  Future uploadFile() async {

    bytesFromPicker = await ImagePickerWeb.getImageAsBytes();
    setState(() {

    });
  }

  slave() async {
    var user = FirebaseAuth.instance.currentUser;
    userdata = {
      "useremail": user!.email.toString(),
    };
    await checkUsersDetails(userdata).then((value) {
      if (!value) {
        print("Here");
        String username = "";
        BuildContext dialogContext;
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            dialogContext = context;
            return Align(
              alignment: Alignment.center,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 800),
                child: Stack(
                  children: [
                    Container(
                      decoration: new BoxDecoration(),
                      //I blured the parent container to blur background image, you can get rid of this part
                      child: new BackdropFilter(
                        filter:
                            new ui.ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                        child: new Container(
                          //you can change opacity with color here(I used black) for background.
                          decoration: new BoxDecoration(
                              color: Colors.black.withOpacity(0.2)),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        margin: EdgeInsets.only(
                            left: 30, right: 30, top: 20, bottom: 20),
                        width: 500,
                        height: 330,
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: Colors.grey.shade800, width: 0.5)),
                        child: Container(
                          color: Colors.black,
                          margin: EdgeInsets.only(
                              top: 15, bottom: 35, left: 40, right: 40),
                          child: Material(
                            color: Colors.black,
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: 30),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Welcome to Twitter Thingy!",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: h1),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 10),
                                  child: Row(
                                    children: [
                                      Text(
                                        "You will need a username to continue.",
                                        style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontSize: h4),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 30),
                                  child: TextField(
                                    onChanged: (val) {
                                      username = val;
                                    },
                                    style: TextStyle(
                                        color: Colors.white, fontSize: h4),
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.teal)),
                                      disabledBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.teal)),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.teal)),
                                      label: Text(
                                        "Your username",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      hintText: 'Enter a search term',
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 20),
                                  height: 50,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        userdata["username"] = username;
                                        userdata["uid"] = FirebaseAuth
                                            .instance.currentUser!.uid;
                                      });
                                      FirebaseFirestore.instance
                                          .collection("Users")
                                          .doc(FirebaseAuth
                                              .instance.currentUser!.email)
                                          .set(userdata);
                                      Navigator.pop(context);
                                    },
                                    child: Center(
                                      child: Text(
                                        "Set as current username",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: h4,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                    margin: EdgeInsets.only(top: 10),
                                    child: Text(
                                      "Once set, username is unchangable.",
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: h6,
                                          fontWeight: FontWeight.bold),
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      } else {
        var d = FirebaseFirestore.instance
            .collection("Users")
            .doc(FirebaseAuth.instance.currentUser!.email)
            .get()
            .then((value) {
          setState(() {
            userdata['useremail'] = value['useremail'];
            userdata['username'] = value['username'];
            userdata["uid"] = FirebaseAuth.instance.currentUser!.uid;
          });
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    slave();
    super.initState();
  }
  var txtController = TextEditingController();
  var hashtagController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: isLoading? Center(child: CircularProgressIndicator(),):Align(
        alignment: Alignment.center,
        child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 800),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: ListView(
                    children: [
                      Container(
                        margin: EdgeInsets.all(15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Text(
                                "Home",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: h3,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        //height: 120,
                        width: 100,
                        margin: EdgeInsets.all(25),
                        decoration: BoxDecoration(
                            // border: Border.all(color: Colors.grey.shade700,width: 0.3),
                            // borderRadius: BorderRadius.circular(5)
                            ),
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              text = value;
                            });
                          },
                          controller: txtController,
                          style: TextStyle(color: Colors.white, fontSize: h3),
                          minLines: 1,
                          maxLines: 5,
                          maxLength: 280,
                          decoration: InputDecoration(
                            counterStyle:
                                TextStyle(color: Colors.blue, fontSize: h6),
                            border: InputBorder.none,
                            hintText: 'Your Tweet..',
                            hintStyle: TextStyle(
                                color: Colors.white,
                                fontSize: h3,
                                fontWeight: FontWeight.w200),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5, left: 25),
                        child: TextField(
                          onChanged: (val) {
                            setState(() {
                              hashtags = val;
                            });
                          },
                          controller: hashtagController,
                          style: TextStyle(color: Colors.blue, fontSize: h4),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            label: Text(
                              "HashTags",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: h4),
                            ),
                          ),
                        ),
                      ),
                      bytesFromPicker == null ? Container():Container(
                        height: 300,
                        width: 300,
                        margin: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white,width: 0.3),
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: Image.memory(bytesFromPicker!,fit: BoxFit.fitHeight,),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: EdgeInsets.all(15),
                            child: Row(
                              children: [
                                IconButton(onPressed: (){
                                  uploadFile();
                                }, icon: Icon(Icons.add_a_photo,color: Colors.white,))
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                height: 40,
                                width: 90,
                                margin: EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                    color: Colors.blue.shade600,
                                    borderRadius: BorderRadius.circular(40),
                                    border: Border.all(
                                        color: Colors.grey.shade700,
                                        width: 0.2)),
                                child: InkWell(
                                  onTap: () async {
                                    setState(() {
                                      isLoading = !isLoading;
                                    });
                                    List<String> hashtagGenerator(String b) {
                                      List<String> res = [];
                                      var e = b.split(" ");
                                      for (int i = 0; i < e.length; i++) {
                                        if (e[i][0] == "#") {
                                          var t =
                                              e[i].substring(1, e[i].length);
                                          res.add(t);
                                        } else {
                                          res.add(e[i]);
                                        }
                                      }
                                      return res;
                                    }

                                    newPost.useremail = userdata['useremail'];
                                    newPost.hashtags = hashtags.isEmpty
                                        ? []
                                        : hashtagGenerator(hashtags);
                                    newPost.text = text;
                                    newPost.index = posts.length;
                                    newPost.TimeStamp = DateTime.now()
                                        .millisecondsSinceEpoch
                                        .toString();

                                    var snackBar = SnackBar(
                                      backgroundColor: Colors.green,
                                      content: Text('Tweet posted',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: h4,
                                              fontWeight: FontWeight.bold)),
                                    );
                                    var t = (random(1000000,999999999) + DateTime.now().millisecondsSinceEpoch).toString();
                                    Future imageupload() async {
                                        final ref = firebase_storage.FirebaseStorage.instance
                                            .ref(t);
                                        await ref.putData(bytesFromPicker!,firebase_storage.SettableMetadata(contentType: 'image/jpeg'));
                                        newPost.url = await ref.getDownloadURL();
                                        bytesFromPicker = null;
                                        print(newPost.url);
                                        print(t);
                                    }
                                    if(bytesFromPicker != null){
                                     await imageupload();
                                    }
                                    newPost.filename = t;
                                    newPost.toCloud();
                                    posts.add(newPost);

                                    void apiCall() async {
                                      var url = 'https://shivanshjoshi282001.pythonanywhere.com/uploadimage?imageurl=${newPost.url}&text=Demotext&filename=${t}';
                                      print(url);
                                      var dio = Dio();
                                      await dio.get(url,queryParameters: {
                                        "imageurl":newPost.url,
                                        "text":"demo",
                                        "filename":t,
                                      });
                                    }
                                    apiCall();
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                   txtController.clear();
                                   hashtagController.clear();
                                    bytesFromPicker = null;
                                    setState(() {
                                      isLoading = !isLoading;
                                    });
                                    newPost = Post();
                                  },
                                  child: Center(
                                    child: SelectableText(
                                      "Post",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: h4,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Divider(
                        color: Colors.grey.shade600,
                        thickness: 0.4,
                      ),
                      Container(
                        margin: EdgeInsets.all(15),
                        child: SelectableText("All your recent posts",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: h2,
                                fontWeight: FontWeight.bold)),
                      ),
                      StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection("Posts")
                              .where("username",
                                  isEqualTo: userdata['useremail'])
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
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
                                //temp.hashtags = slotMap['hashtags'] as List<String>;
                                List<String> hashtags = [];
                                for (int j = 0;
                                    j < slotMap['hashtags'].length;
                                    j++) {
                                  hashtags.add(slotMap['hashtags'][j]);
                                }
                                temp.hashtags = hashtags;
                                temp.url = slotMap['url'];
                                posts.add(temp);
                              }
                              if (data.isEmpty) {
                                return Container(
                                  margin: EdgeInsets.only(top: 100),
                                  child: Center(
                                    child: SelectableText(
                                      "You haven't post anything yet.",
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: h4,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                );
                              }
                              return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: posts.length,
                                  itemBuilder: (context, index) {
                                    return posts[index].view(context);
                                  });
                            }
                            return Container(
                              child: Center(
                                child: SelectableText(
                                  "You haven't post anything yet.",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: h4,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            );
                          })
                    ],
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(
                              width: 0.7, color: Colors.grey.shade800),
                        ),
                      ),
                      child: Column(
                        children: [
                          SideView(),
                        ],
                      ),
                    )),
              ],
            )),
      ),
    );
  }
}
