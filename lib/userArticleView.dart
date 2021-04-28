import 'package:flutter/material.dart';

class UserArticleView extends StatefulWidget {
  String title, desc, shortDesc;
  var imgUrl;
  UserArticleView({this.title, this.desc, this.imgUrl, this.shortDesc});
  @override
  _UserArticleViewState createState() =>
      _UserArticleViewState(this.title, this.desc, this.imgUrl, this.shortDesc);
}

class _UserArticleViewState extends State<UserArticleView> {
  String title, desc, shortDesc;
  var imgUrl;
  _UserArticleViewState(this.title, this.desc, this.imgUrl, this.shortDesc);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        titleSpacing: NavigationToolbar.kMiddleSpacing.sign,
        title: Text(
          'Article',
          style: TextStyle(
            color: Colors.lightBlueAccent[400],
            fontFamily: 'FredokaOne',
            fontSize: 24,
          ),
        ),
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.lightBlueAccent[400],
            ),
            onPressed: () => Navigator.pop(context)),
      ),
      body: Container(
        //margin: EdgeInsets.symmetric(horizontal: 8),
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.25,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  // borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  // borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    imgUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Column(
                children: [
                  Container(
                    margin:
                        EdgeInsets.only(top: 150, bottom: 8, left: 8, right: 8),
                    // height: MediaQuery.of(context).size.height,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[700],
                          offset: Offset(0, -3.0),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            shortDesc,
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          Container(
                            color: Colors.black,
                            height: 0.5,
                            margin: EdgeInsets.symmetric(vertical: 8),
                          ),
                          Text(
                            desc,
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text('You have reached end of this article'),
                  SizedBox(
                    height: 8,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
