import 'dart:io';

import 'package:TimesWall/NewsFeed.dart';
import 'package:TimesWall/helper/databaseHandle.dart';
import 'package:TimesWall/profilePage.dart';
import 'package:TimesWall/searchPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:TimesWall/helper/widgets.dart';

class CommunityPage extends StatefulWidget {
  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  Stream articleStream;
  DatabaseMethods databaseMethods = DatabaseMethods();

  Widget ArticleList() {
    return Container(
      height: double.maxFinite,
      margin: EdgeInsets.only(bottom: 50),
      child: StreamBuilder<QuerySnapshot>(
          stream: articleStream,
          builder: (context, snapshot) {
            return snapshot.hasData
                ? ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      return PostTile(
                        title: snapshot.data.docs[index].data()['articleTitle'],
                        desc: snapshot.data.docs[index].data()['articleDesc'],
                        imgUrl: snapshot.data.docs[index].data()['imageUrl'],
                        shortDesc:
                            snapshot.data.docs[index].data()['shortDesc'],
                        authorEmail:
                            snapshot.data.docs[index].data()['authorEmail'],
                      );
                    })
                : Container(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(),
                  );
          }),
    );
  }

  Feed() {
    FirebaseFirestore.instance
        .collection('data')
        .doc(FirebaseAuth.instance.currentUser.email)
        .collection('following')
        .get()
        .then((value) {
      for (var i = 1; i <= value.docs.length; i++) {
        articleStream = databaseMethods.getPosts(value.docs[0].id);
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Feed();

    //print(x);
    // for (var i in x) {
    //   FirebaseFirestore.instance
    //       .collection('data')
    //       .doc(i)
    //       .collection('published articles')
    //       .orderBy('time', descending: true);
    // }
    // .then((value) {
    //   articleStream = databaseMethods.getPosts(value);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        titleSpacing: NavigationToolbar.kMiddleSpacing.sign,
        title: Text(
          'Pin on',
          style: TextStyle(
            color: Colors.lightBlueAccent[400],
            //fontWeight: FontWeight.w700,
            fontSize: 30,
            fontFamily: 'Pacifico',
          ),
        ),
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.lightBlueAccent[400],
            ),
            onPressed: () => Navigator.pop(context)),
        actions: [
          IconButton(
            icon: Icon(Icons.search_rounded),
            onPressed: () => Navigator.push(context, PageRouteBuilder(
              pageBuilder: (context, animation, animationTime) {
                return SearchPage();
              },
            )),
          )
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.people_alt_rounded,
                size: 40,
                color: Colors.lightBlueAccent[400],
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.pushReplacement(context, PageRouteBuilder(
                  pageBuilder: (context, animation, animationTime) {
                    return NewsFeed();
                  },
                ));
              },
              icon: Icon(
                Icons.home_outlined,
                size: 34,
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.pushReplacement(context, PageRouteBuilder(
                  pageBuilder: (context, animation, animationTime) {
                    return ProfilePage();
                  },
                ));
              },
              icon: Icon(
                Icons.account_circle_outlined,
                size: 34,
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            children: [
              //Category Title
              Row(
                children: [
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    'Community',
                    style: TextStyle(
                      fontFamily: 'FredokaOne',
                      fontSize: 32,
                    ),
                  ),
                ],
              ),
              //Articles
              Container(
                height: MediaQuery.of(context).size.height * 0.70,
                child: ArticleList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
