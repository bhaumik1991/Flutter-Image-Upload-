import 'package:flutter/material.dart';
import 'package:flutter_social/provider/google_sign_in.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
                Theme.of(context).accentColor,
                Theme.of(context).primaryColor
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter
          ),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Flutter Social",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30
              ),
            ),
            SizedBox(height: 20,),
            GestureDetector(
              onTap: (){
                final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
                provider.login();
              },
              child: Container(
                height: 40,
                width: 270,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/google_signin_button.png'),
                        fit: BoxFit.cover
                    )
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
