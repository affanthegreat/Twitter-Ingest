import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:twitter_intent/twitter_intent.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui' as ui;
import '../Designs/designs.dart';

var posts = [];

class Post {
  String text = "";
  String url = "";
  List<String> hashtags = [];
  var TimeStamp;
  int index = -1;
  String filename = "";
  String useremail = "";
  String toHTML() {
    return """<head>
                  <meta name="twitter:card" content="summary" />
                 <meta name="twitter:site" content="@tapaway" />
                 <meta name="twitter:title" content="${text}" />
                 <meta name="twitter:description" content="${text}" />
                 <meta name="twitter:image" content="${url}" />
                 <meta name="twitter:url" content="https://twitter.com" />
               </head>
               <body>
                <img src="${url}" />
               </body>""";
  }

  dynamic toMap() {
    var m = {
      "text": text,
      "url": url,
      "hashtags": hashtags,
      "timestamp": TimeStamp,
      "username": useremail,
      "filename": filename
    };

    return m;
  }

  toCloud() {
    var m =  toMap();
    print(m);
    FirebaseFirestore.instance.collection("Posts").doc(TimeStamp).set(m);
  }

  Widget view(BuildContext context) {
    return ViewForPost(index: index);
  }

  Widget safeview(BuildContext context) {
    return ReadOnly(index: index);
  }
}

class ViewForPost extends StatefulWidget {
  int index = -1;
  ViewForPost({Key? key, required this.index}) : super(key: key);

  @override
  _ViewForPostState createState() => _ViewForPostState();
}

class _ViewForPostState extends State<ViewForPost> {
  bool editMode = false;
  var e = "";
  slave() {
    DateTime date = new DateTime.fromMillisecondsSinceEpoch(
        int.parse(posts[widget.index].TimeStamp));
    var current = DateTime.now();
    if (date.day == current.day &&
        date.month == current.month &&
        date.year == current.year) {
      e = current.difference(date).inHours.toString() + 'h';
    } else {
      e = current.difference(date).inDays.toString() +
          ' Days | ' +
          date.day.toString() +
          "/" +
          date.month.toString() +
          "/" +
          date.year.toString();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    slave();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    child: Text(posts[widget.index].useremail[0].toString().toUpperCase()),
                  ),
                  Container(
                      margin: EdgeInsets.only(left: 10),
                      child: SelectableText(
                        posts[widget.index].useremail,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: h4,
                            fontWeight: FontWeight.bold),
                      )),
                  Icon(
                    Icons.verified,
                    color: Colors.white,
                    size: h4,
                  )
                ],
              ),
              Container(
                  margin: EdgeInsets.only(left: 10),
                  child: SelectableText(
                    e,
                    style: TextStyle(color: Colors.grey, fontSize: h6),
                  )),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                    margin: EdgeInsets.only(top: 10, bottom: 10, left: 50),
                    child: editMode == true
                        ? TextFormField(
                            onChanged: (value) {
                              setState(() {
                                posts[widget.index].text = value;
                              });
                              FirebaseFirestore.instance
                                  .collection("Posts")
                                  .doc(posts[widget.index].TimeStamp)
                                  .set(posts[widget.index].toMap());
                            },
                            initialValue: posts[widget.index].text,
                            maxLines: null,
                            style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: h4,
                                fontWeight: FontWeight.w400),
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
                          )
                        : Text(
                            posts[widget.index].text,
                            maxLines: null,
                            style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: h4,
                                fontWeight: FontWeight.w400),
                          )),
              ),
            ],
          ),
          posts[widget.index].url == ""?Container(): Container(
            margin: EdgeInsets.only(left: 50),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(width: 0.5,color: Colors.white)
            ),
            child: Image.network(posts[widget.index].url)
          ),
          posts[widget.index].hashtags.isEmpty
              ? Container()
              : Container(
                  margin: EdgeInsets.only(top: 10, bottom: 10, left: 50),
                  child: Row(
                    children: [
                      SelectableText(
                        "Currently used Hashtags",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: h5,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
          posts[widget.index].hashtags.isEmpty
              ? Container()
              : Container(
                  height: h2,
                  margin: EdgeInsets.only(left: 50),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: posts[widget.index].hashtags.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Text(
                            "#" + posts[widget.index].hashtags[index] + " ",
                            style: TextStyle(color: Colors.blue, fontSize: h3),
                          );
                        }),
                  ),
                ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    editMode = !editMode;
                  });
                  if (editMode == false) {
                    posts[widget.index].posts[widget.index].toCloud();
                  }
                },
                icon: Icon(
                  Icons.edit,
                  color: Colors.blue,
                ),
              ),
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (BuildContext context) {
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
                                  filter: new ui.ImageFilter.blur(
                                      sigmaX: 3.0, sigmaY: 3.0),
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
                                  height: 150,
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: Colors.grey.shade800,
                                          width: 0.5)),
                                  child: Container(
                                    color: Colors.black,
                                    margin: EdgeInsets.only(
                                        top: 15,
                                        bottom: 35,
                                        left: 40,
                                        right: 40),
                                    child: Material(
                                      color: Colors.black,
                                      child: Column(
                                        children: [
                                          Container(
                                              margin: EdgeInsets.only(
                                                  top: 10, bottom: 10),
                                              child: SelectableText(
                                                "Are you sure you want to delete this post?",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: h5,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Container(
                                                height: 50,
                                                width: 160,
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.white,
                                                        width: 1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                child: InkWell(
                                                  onTap: () {
                                                    FirebaseFirestore.instance
                                                        .collection("Posts")
                                                        .doc(posts[widget.index]
                                                            .TimeStamp)
                                                        .delete();
                                                    Navigator.pop(context);
                                                  },
                                                  child: Center(
                                                    child: Text(
                                                      "Delete This Post",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: h5,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                height: 50,
                                                width: 160,
                                                decoration: BoxDecoration(
                                                    color: Colors.blue,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                child: InkWell(
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Center(
                                                    child: Text(
                                                      "No, Go back.",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: h5,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          )
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
                },
                icon: Icon(
                  Icons.delete,
                  color: Colors.blue,
                ),
              )
            ],
          ),
          Divider(
            color: Colors.grey.shade800,
            thickness: 0.6,
          ),
        ],
      ),
    );
  }
}

class ReadOnly extends StatefulWidget {
  int index = -1;
  ReadOnly({Key? key, required this.index}) : super(key: key);

  @override
  _ReadOnlyState createState() => _ReadOnlyState();
}

class _ReadOnlyState extends State<ReadOnly> {
  var e = "";
  launchTwitterIntent() async {
    print(posts[widget.index].filename);
    var intent = TweetIntent(
      hashtags: posts[widget.index].hashtags,
      text: posts[widget.index].text,
      url: posts[widget.index].filename == "" ?null: "https://shivanshjoshi282001.pythonanywhere.com/getimage/" + posts[widget.index].filename,
    );
    await launch('$intent');
  }

  slave() {
    DateTime date = new DateTime.fromMillisecondsSinceEpoch(
        int.parse(posts[widget.index].TimeStamp));
    var current = DateTime.now();
    if (date.day == current.day &&
        date.month == current.month &&
        date.year == current.year) {
      e = current.difference(date).inHours.toString() + 'h';
    } else {
      e = current.difference(date).inDays.toString() +
          ' Days | ' +
          date.day.toString() +
          " / " +
          date.month.toString() +
          " / " +
          date.year.toString();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    slave();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    child: Text(posts[widget.index].useremail[0].toString().toUpperCase()),
                  ),
                  Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Text(
                        posts[widget.index].useremail,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: h4,
                            fontWeight: FontWeight.bold),
                      )),
                  Icon(
                    Icons.verified,
                    color: Colors.white,
                    size: h4,
                  )
                ],
              ),
              Container(
                  margin: EdgeInsets.only(left: 10),
                  child: SelectableText(
                    e,
                    style: TextStyle(color: Colors.grey, fontSize: h6),
                  )),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                    margin: EdgeInsets.only(top: 10, bottom: 10, left: 50),
                    child: SelectableText(
                      posts[widget.index].text,
                      maxLines: null,
                      style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: h4,
                          fontWeight: FontWeight.w400),
                    )),
              ),
            ],
          ),
          posts[widget.index].url == ""? Container():Container(
            width: 300,
            height: 300,
            child: Image.network(posts[widget.index].url),
          ),
          posts[widget.index].hashtags.isEmpty
              ? Container()
              : Container(
                  margin: EdgeInsets.only(top: 10, bottom: 10, left: 50),
                  child: Row(
                    children: [
                      Text(
                        "Currently used Hashtags",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: h5,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
          posts[widget.index].hashtags.isEmpty
              ? Container()
              : Container(
                  height: h2,
                  margin: EdgeInsets.only(left: 50),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: posts[widget.index].hashtags.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Text(
                            "#" + posts[widget.index].hashtags[index] + " ",
                            style: TextStyle(color: Colors.blue, fontSize: h3),
                          );
                        }),
                  ),
                ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: 40,
                width: 150,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20)),
                child: InkWell(
                    onTap: () {
                      launchTwitterIntent();
                    },
                    child: Center(
                        child: Text(
                      "Open in Twitter",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: h4,
                          fontWeight: FontWeight.bold),
                    ))),
              )
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Divider(
              color: Colors.grey.shade700,
              thickness: 0.4,
            ),
          ),
        ],
      ),
    );
  }
}
