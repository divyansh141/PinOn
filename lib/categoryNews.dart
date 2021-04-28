import 'package:TimesWall/helper/news.dart';
import 'package:TimesWall/helper/widgets.dart';
import 'package:TimesWall/models/ArticleModel.dart';
import 'package:flutter/material.dart';

class CategoryNews extends StatefulWidget {
  String category;
  CategoryNews({this.category});

  @override
  _CategoryNewsState createState() => _CategoryNewsState();
}

class _CategoryNewsState extends State<CategoryNews> {
  List<ArticleModel> articles = List<ArticleModel>();
  bool _loading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCategoryNews();
  }

  getCategoryNews() async {
    CategoryNewsClass newsClass = CategoryNewsClass();
    await newsClass.getNews(widget.category);
    articles = newsClass.news;
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        titleSpacing: NavigationToolbar.kMiddleSpacing.sign,
        title: Text(
          'Pin on',
          style: TextStyle(
            color: Colors.lightBlueAccent[400],
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
      ),
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
                    //Category Title
                    Row(
                      children: [
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          widget.category.replaceFirst(widget.category[0],
                              widget.category[0].toUpperCase()),
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
                            //publishedAt: articles[index].publishedAt,
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
