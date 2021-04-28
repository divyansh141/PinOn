import 'package:TimesWall/article_webview.dart';
import 'package:TimesWall/helper/databaseHandle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

var auth = FirebaseAuth.instance;
var fs = FirebaseFirestore.instance;

class Pins extends StatefulWidget {
  @override
  _PinsState createState() => _PinsState();
}

class _PinsState extends State<Pins> {
  var textColor = Colors.white;
  List<Widget> history = [];

  Widget pinnedList() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('data')
            .doc(FirebaseAuth.instance.currentUser.email)
            .collection('pins')
            .orderBy("time", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return BlogTile(
                      imgUrl: snapshot.data.docs[index].data()['imgUrl'],
                      title: snapshot.data.docs[index].data()['title'],
                      desc: snapshot.data.docs[index].data()['desc'],
                      url: snapshot.data.docs[index].data()['url'],
                      sourceName:
                          snapshot.data.docs[index].data()['sourceName'],
                    );
                  })
              : Container();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        titleSpacing: NavigationToolbar.kMiddleSpacing.sign,
        title: Text(
          'Pins',
          style: TextStyle(
            color: Colors.lightBlueAccent[400],
            fontFamily: 'FredokaOne',
            fontSize: 32,
          ),
        ),
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.lightBlueAccent[400],
            ),
            onPressed: () => Navigator.pop(context)),
      ),
      backgroundColor: textColor,
      body: pinnedList(),
    );
  }
}

class BlogTile extends StatelessWidget {
  String imgUrl;
  String title;
  String desc;
  String url;
  String sourceName;

  BlogTile({
    @required this.imgUrl,
    @required this.title,
    @required this.desc,
    @required this.url,
    @required this.sourceName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ArticleView(
                        articleUrl: url,
                      )));
        },
        child: Card(
          elevation: 5,
          child: Container(
            // margin: EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width * 0.2,
                        child: Image.network(
                          imgUrl,
                          scale: 10,
                          fit: BoxFit.fill,
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: Text(
                              title,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  Image.asset(
                                    'assets/sort-line.png',
                                    scale: 15,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    sourceName ?? 'Anonymous',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.blue[900],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          FlatButton(
                            height: 32,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            color: Colors.red[600],
                            onPressed: () {
                              DatabaseMethods().deletePin(title);
                              print(sourceName);
                            },
                            child: Text(
                              'Remove',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
