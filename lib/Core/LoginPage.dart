import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:twitter/Core/Home.dart';

import '../Designs/designs.dart';
Map<String,dynamic> userdata = {};
class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          // ...
          return SignInScreen(
              sideBuilder: (context, constraints) {
                return Container(
                  height: MediaQuery.of(context).size.height,
                  child: Image.network("https://wallpapershome.com/images/pages/pic_h/23720.jpg",fit: BoxFit.fitHeight,filterQuality: FilterQuality.medium,)
                );
              },
              headerBuilder: (context, constraints, _) {
                return Expanded(
                  child: Container(
                      
                      child: Image.network("https://wallpapershome.com/images/pages/pic_h/23720.jpg",fit: BoxFit.fitHeight,filterQuality: FilterQuality.medium)

                  ),
                );
              },
              subtitleBuilder: (context, action) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: SelectableText(
                    action == AuthAction.signIn
                        ? 'Admin panel! Please sign in to continue.'
                        : 'Admin panel! Please create an account to continue',
                  ),
                );
              },
              footerBuilder: (context, _) {
                return const Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: SelectableText(
                    'By signing in, you agree to our terms and conditions.',
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              },
              providerConfigs: [
                EmailProviderConfiguration(),
              ]
          );
        }

        // Render your application if authenticated
        return HomePage();
        // ...
      },
    );
  }
}
