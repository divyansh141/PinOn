import 'package:TimesWall/NewsFeed.dart';
import 'package:TimesWall/WriteAnArticle.dart';
import 'package:TimesWall/communityPage.dart';
import 'package:TimesWall/loginPage.dart';
import 'package:TimesWall/pins.dart';
import 'package:TimesWall/profilePage.dart';
import 'package:TimesWall/profileView.dart';
import 'package:TimesWall/regPage.dart';
import 'package:TimesWall/searchPage.dart';
import 'package:TimesWall/userArticleView.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences sharedPref = await SharedPreferences.getInstance();
  var finalEmail = sharedPref.getString('email');
  runApp(MyApp(finalEmail: finalEmail));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  var finalEmail;
  MyApp({
    @required this.finalEmail,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      initialRoute: finalEmail == null ? 'loginPage' : 'home',
      routes: {
        'home': (context) => NewsFeed(),
        'loginPage': (context) => LoginPage(),
        'regPage': (context) => RegPage(),
        'pins': (context) => Pins(),
        'profilePage': (context) => ProfilePage(),
        'writeArticle': (context) => WriteAnArticle(),
        'communityPage': (context) => CommunityPage(),
        'searchPage': (context) => SearchPage(),
        'profileView': (context) => ProfileView(),
        'userAricleView': (context) => UserArticleView(),
      },
    );
  }
}
