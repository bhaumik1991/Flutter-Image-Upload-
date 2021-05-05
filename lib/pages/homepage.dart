import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social/pages/logged_in_page.dart';
import 'package:flutter_social/pages/signup_page.dart';
import 'package:flutter_social/provider/google_sign_in.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';


class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (context) => GoogleSignInProvider(),
        child: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot){
            final provider = Provider.of<GoogleSignInProvider>(context);

            if(provider.isSigningIn){
              return buildLoading();
            } else if(snapshot.hasData){
              return LogginPage();
            } else{
              return SignUpPage();
            }
          },
        ),
      ),
    );
  }

  Widget buildLoading() => Stack(
    fit: StackFit.expand,
    children: [
      Center(child: CircularProgressIndicator()),
    ],
  );
}
