import 'dart:core';

import 'package:TimesWall/communityPage.dart';
import 'package:TimesWall/helper/data.dart';
import 'package:TimesWall/helper/databaseHandle.dart';
import 'package:TimesWall/helper/news.dart';
import 'package:TimesWall/helper/widgets.dart';
import 'package:TimesWall/models/ArticleModel.dart';
import 'package:TimesWall/models/CategoryModel.dart';
import 'package:TimesWall/profilePage.dart';
import 'package:flutter/material.dart';

class NewsFeed extends StatefulWidget {
  @override
  _NewsFeedState createState() => _NewsFeedState();
}

class _NewsFeedState extends State<NewsFeed> {
  List<CategoryModel> categories = List<CategoryModel>();
  List<ArticleModel> articles = List<ArticleModel>();

  DatabaseMethods databaseMethods = DatabaseMethods();

  bool _loading = true;
  var dropdownValue;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    categories = getCategory();
    getNews();
  }

  getNews() async {
    News newsClass = News();
    await newsClass.getNews();
    articles = newsClass.news;
    setState(() {
      _loading = false;
    });
  }

  String pinButtonText = 'pinned';
  var pinButtonColor = Colors.blue[600];
  var pinTextColor = Colors.white;
  callback(value) {
    setState(() {
      pinButtonText = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Pin on',
          style: TextStyle(
            color: Colors.lightBlueAccent[400],
            //fontWeight: FontWeight.w700,
            fontSize: 30,
            fontFamily: 'Pacifico',
          ),
        ),
        actions: [
          FlatButton(
            onPressed: () {
              Navigator.pushNamed(context, 'pins');
            },
            child: Text('Pins'),
          ),
        ],
      ),

      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            IconButton(
              onPressed: () {
                Navigator.pushReplacement(context, PageRouteBuilder(
                  pageBuilder: (context, animation, animationTime) {
                    return CommunityPage();
                  },
                ));
              },
              icon: Icon(
                Icons.people_alt_outlined,
                size: 34,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.home_rounded,
                size: 40,
                color: Colors.lightBlueAccent[400],
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.pushReplacement(context, PageRouteBuilder(
                  // transitionDuration: Duration(seconds: 0),
                  // transitionsBuilder:
                  //     (context, animation, animationTime, child) {
                  //   animation = CurvedAnimation(
                  //       parent: animation, curve: Curves.easeIn);
                  //   return FadeTransition(opacity: animation, child: child);
                  // },
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
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(18),
        ),
        backgroundColor: Colors.lightBlueAccent[400],
        child: Icon(Icons.add),
        // shape: new BeveledRectangleBorder(
        //     borderRadius: new BorderRadius.circular(50.0)),
        onPressed: () {
          Navigator.pushNamed(context, 'writeArticle');
        },
      ),
      //floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: _loading
          ? Center(
              child: Container(
                child: CircularProgressIndicator(),
              ),
            )
          : SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Column(
                  children: [
                    //Categories
                    Container(
                      height: 90,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          return CategoryTile(
                            categoryName: categories[index].categoryName,
                            imgPath: categories[index].imgPath,
                          );
                        },
                      ),
                    ),
                    //Category Title
                    Row(
                      children: [
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          'Top Headlines',
                          style: TextStyle(
                            fontFamily: 'FredokaOne',
                            fontSize: 32,
                          ),
                        ),
                      ],
                    ),

                    //Articles

                    Container(
                      margin: EdgeInsets.only(top: 8),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemCount: articles.length,
                        itemBuilder: (context, index) {
                          return BlogTile(
                            imgUrl: articles[index].urlToImage,
                            title: articles[index].title,
                            desc: articles[index].description,
                            url: articles[index].url,
                            sourceName: articles[index].sourceName,
                            callback: callback,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
