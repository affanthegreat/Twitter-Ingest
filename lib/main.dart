import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:twitter/Core/Home.dart';
import 'package:twitter/Core/LoginForusers.dart';
import 'package:twitter/Core/LoginPage.dart';
import 'package:twitter/Core/ViewersScreen.dart';
import 'package:twitter_intent/twitter_intent.dart';
import 'package:url_launcher/url_launcher.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options:const FirebaseOptions(
        apiKey: "AIzaSyBRcTqugJWfZLSt8TYqYrxHabCnR8clpC4",
        authDomain: "twitterdata-68bce.firebaseapp.com",
        projectId: "twitterdata-68bce",
        storageBucket: "twitterdata-68bce.appspot.com",
        messagingSenderId: "446466991994",
        appId: "1:446466991994:web:01e7fa3001dc1eace898c3"
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => const LoginForUsers(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/login': (context) => Login(),
      },
    );
  }
}

