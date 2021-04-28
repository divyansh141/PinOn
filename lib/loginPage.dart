import 'package:TimesWall/NewsFeed.dart';
import 'package:TimesWall/helper/widgets.dart';
import 'package:TimesWall/regPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  var auth = FirebaseAuth.instance;
  String email;
  String password;
  bool loading = false;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: loading,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
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
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hi !!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontFamily: 'FredokaOne',
                    ),
                  ),
                  Text(
                    'Welcome Back',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontFamily: 'FredokaOne',
                    ),
                  ),
                  Text(
                    'Sign in to continue',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    onChanged: (value) => email = value,
                    cursorColor: Colors.white,
                    style: TextStyle(color: Colors.white),
                    decoration: textFieldDecor('Email', Icons.mail_outline),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    onChanged: (value) => password = value,
                    obscureText: true,
                    cursorColor: Colors.white,
                    style: TextStyle(color: Colors.white),
                    decoration: textFieldDecor('Password', Icons.lock_outline),
                  ),
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
                            var login = await auth.signInWithEmailAndPassword(
                                email: email, password: password);
                            //print(login);
                            if (login != null) {
                              setState(() {
                                loading = false;
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
                                  'Please check your Email and Password again'),
                              backgroundColor: Colors.red,
                            );

                            _scaffoldKey.currentState.showSnackBar(snackBar);

                            print(e);
                          }
                        },
                        label: Text('LOG IN',
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
                        'Don\'t have an Account? ',
                        style: TextStyle(color: Colors.white),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegPage()));
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 2),
                          child: Text(
                            'Sign Up',
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
      ),
    );
  }
}
