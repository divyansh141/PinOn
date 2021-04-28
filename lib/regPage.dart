import 'package:TimesWall/NewsFeed.dart';
import 'package:TimesWall/helper/widgets.dart';
import 'package:TimesWall/loginPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';

var fs = FirebaseFirestore.instance;

class RegPage extends StatefulWidget {
  @override
  _RegPageState createState() => _RegPageState();
}

class _RegPageState extends State<RegPage> {
  var fs = FirebaseFirestore.instance;
  var auth = FirebaseAuth.instance;
  bool loading = false;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  String email;
  String password;
  String username;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent[400],
        elevation: 0,
        toolbarHeight: 80,
        title: Text(
          'Pin on',
          style: TextStyle(
            color: Colors.white,
            fontSize: 48,
            fontFamily: 'Pacifico',
          ),
        ),
      ),
      key: _scaffoldKey,
      backgroundColor: Colors.lightBlueAccent[400],
      body: ModalProgressHUD(
        inAsyncCall: loading,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Register Now',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 46,
                    fontFamily: 'FredokaOne',
                  ),
                ),
                Text(
                  'Sign up to get started',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  onChanged: (value) {
                    username = value;
                  },
                  cursorColor: Colors.white,
                  style: TextStyle(color: Colors.white),
                  decoration:
                      textFieldDecor('Username', Icons.account_circle_outlined),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  onChanged: (value) {
                    email = value;
                  },
                  cursorColor: Colors.white,
                  style: TextStyle(color: Colors.white),
                  decoration: textFieldDecor('Email', Icons.mail_outline),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                    onChanged: (value) {
                      password = value;
                    },
                    obscureText: true,
                    cursorColor: Colors.white,
                    style: TextStyle(color: Colors.white),
                    decoration: textFieldDecor('Password', Icons.lock_outline)),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: double.infinity,
                  child: FloatingActionButton.extended(
                      backgroundColor: Color(0xffffffff),
                      onPressed: () async {
                        setState(() {
                          loading = true;
                        });
                        try {
                          var user = await auth.createUserWithEmailAndPassword(
                              email: email, password: password);
                          if (user.additionalUserInfo.isNewUser == true) {
                            setState(() {
                              loading = false;
                            });
                            await fs.collection('users').doc(email).set({
                              'username': username,
                              'email': email,
                              'profile photo': null,
                            });
                            SharedPreferences sharedPref =
                                await SharedPreferences.getInstance();
                            sharedPref.setString('email', email);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NewsFeed()));
                          }
                        } catch (e) {
                          setState(() {
                            loading = false;
                          });

                          final snackBar = SnackBar(
                            content: Text(
                                'The email address is already in use by another account'),
                            backgroundColor: Colors.red,
                          );

                          _scaffoldKey.currentState.showSnackBar(snackBar);
                          print(e);
                        }
                      },
                      label: Text('Sign Up',
                          style: TextStyle(
                            color: Colors.lightBlueAccent[400],
                          ))),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an Account? ',
                      style: TextStyle(color: Colors.white),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()));
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 2),
                        child: Text(
                          'Log In',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
