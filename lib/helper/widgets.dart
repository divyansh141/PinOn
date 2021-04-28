import 'package:TimesWall/article_webview.dart';
import 'package:TimesWall/categoryNews.dart';
import 'package:TimesWall/helper/databaseHandle.dart';
import 'package:TimesWall/models/ArticleModel.dart';
import 'package:TimesWall/models/CategoryModel.dart';
import 'package:TimesWall/userArticleView.dart';
import 'package:flutter/material.dart';

InputDecoration textFieldDecor(String hintText, IconData preIcon) {
  return InputDecoration(
    prefixIcon: Icon(
      preIcon,
      color: Colors.white,
    ),
    hintText: hintText,
    hintStyle: TextStyle(color: Colors.white),
    enabledBorder:
        UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
    ),
  );
}

class CategoryTile extends StatelessWidget {
  String imgPath;
  String categoryName;
  CategoryTile({this.imgPath, this.categoryName});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  CategoryNews(category: categoryName.toLowerCase()),
            ));
      },
      child: Container(
        width: 80,
        margin: EdgeInsets.only(right: 0),
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blueGrey[50],
              radius: 27,
              child: ClipRRect(
                //borderRadius: BorderRadius.circular(50),
                child: Image.asset(
                  imgPath,
                  height: 60,
                  width: 60,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 5),
            Text(
              categoryName,
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                //fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BlogTile extends StatefulWidget {
  String imgUrl;
  String title;
  String desc;
  String url;
  String sourceName;

  Function(Function) callback;
  BlogTile({
    @required this.imgUrl,
    @required this.title,
    @required this.desc,
    @required this.url,
    @required this.sourceName,
    this.callback,
  });

  @override
  _BlogTileState createState() => _BlogTileState();
}

class _BlogTileState extends State<BlogTile> {
  String pinButtonText = 'pin it';
  var pinButtonColor = Colors.blue[600];
  var pinTextColor = Colors.white;

  addPinInData(
      String title, String imgUrl, String desc, String url, String sourceName) {
    Map<String, dynamic> pinMap = {
      "title": title,
      "imgUrl": imgUrl,
      "desc": desc,
      "url": url,
      "sourceName": sourceName,
      "time": DateTime.now().millisecondsSinceEpoch,
    };
    DatabaseMethods().addPin(pinMap);
  }

  changeState() {
    setState(() {
      pinButtonText = 'pinned';
      pinButtonColor = Colors.grey[200];
      pinTextColor = Colors.grey[400];
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ArticleView(
                      articleUrl: widget.url,
                    )));
      },
      child: Card(
        elevation: 5,
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5), topRight: Radius.circular(5)),
              child: Image.network(widget.imgUrl),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    widget.desc,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 8),
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
                                widget.sourceName ?? 'Anonymous',
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
                        color: pinButtonColor,
                        onPressed: () {
                          widget.callback(changeState());

                          addPinInData(widget.title, widget.imgUrl, widget.desc,
                              widget.url, widget.sourceName);
                        },
                        child: Text(
                          pinButtonText,
                          style: TextStyle(
                            color: pinTextColor,
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
    );
  }
}

class PublishedArticleTile extends StatelessWidget {
  String title, desc, imgUrl, shortDesc;
  PublishedArticleTile({
    @required this.title,
    @required this.desc,
    @required this.imgUrl,
    @required this.shortDesc,
  });
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => UserArticleView(
                  title: title,
                  desc: desc,
                  imgUrl: imgUrl,
                  shortDesc: shortDesc,
                ),
              ),
            ),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 5, vertical: 4),
              height: 150,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      imgUrl,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    height: 150,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black45.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      title,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomRight,
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    child: FlatButton(
                      height: 24,
                      minWidth: 30,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      color: Colors.red[600],
                      onPressed: () {
                        DatabaseMethods().deleteArticle(title);
                      },
                      child: Text(
                        'Remove',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UserArticleTile extends StatelessWidget {
  String title, desc, imgUrl, shortDesc;
  UserArticleTile(
      {@required this.title,
      @required this.desc,
      @required this.imgUrl,
      @required this.shortDesc});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => UserArticleView(
                  title: title,
                  desc: desc,
                  imgUrl: imgUrl,
                  shortDesc: shortDesc,
                ),
              ),
            ),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 5, vertical: 4),
              height: 150,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      imgUrl,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    height: 150,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.black45.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PostTile extends StatelessWidget {
  String title, desc, imgUrl, shortDesc, authorEmail, profilePhotoLink;
  PostTile({
    @required this.title,
    @required this.desc,
    @required this.imgUrl,
    @required this.shortDesc,
    @required this.authorEmail,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
          color: Colors.lightBlueAccent[200],
          border: Border.all(
            color: Colors.black..withOpacity(0.3),
          ),
          borderRadius: BorderRadius.circular(8)),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 5,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 5),
                  height: 35,
                  child: Text(
                    authorEmail,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white),
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => UserArticleView(
                    title: title,
                    desc: desc,
                    imgUrl: imgUrl,
                    shortDesc: shortDesc,
                  ),
                ),
              ),
              child: Container(
                // margin: EdgeInsets.only(left: 5, right: 5),
                height: 150,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipRRect(
                      child: Image.network(
                        imgUrl,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      height: 150,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black45.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        title,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
                height: 35,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                        icon: Icon(Icons.thumb_up_alt_outlined),
                        onPressed: () {}),
                    IconButton(
                        icon: Icon(Icons.thumb_down_alt_outlined),
                        onPressed: () {}),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
