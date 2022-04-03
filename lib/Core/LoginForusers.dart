import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';

import 'ViewersScreen.dart';

class LoginForUsers extends StatefulWidget {
  const LoginForUsers({Key? key}) : super(key: key);

  @override
  State<LoginForUsers> createState() => _LoginForUsersState();
}

class _LoginForUsersState extends State<LoginForUsers> {
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
                    child: Image.network("https://4kwallpapers.com/images/wallpapers/floral-background-colorful-3d-background-digital-art-3840x3840-7650.jpg",fit: BoxFit.fitHeight,filterQuality: FilterQuality.medium,)
                );
              },
              headerBuilder: (context, constraints, _) {
                return Expanded(
                  child: Container(
                      child: Image.network("https://4kwallpapers.com/images/wallpapers/floral-background-colorful-3d-background-digital-art-3840x3840-7650.jpg",fit: BoxFit.fitHeight,filterQuality: FilterQuality.medium)

                  ),
                );
              },
              subtitleBuilder: (context, action) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: SelectableText(
                    action == AuthAction.signIn
                        ? 'Welcome to Twitter Thingy! Please sign in to continue.'
                        : 'Welcome to Twitter Thingy! Please create an account to continue',
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
        return ViewersScreen();
        // ...
      },
    );
  }
}
