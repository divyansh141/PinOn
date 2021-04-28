import 'dart:convert';

import 'package:TimesWall/models/ArticleModel.dart';
import 'package:http/http.dart' as http;

class News {
  List<ArticleModel> news = [];
  Future<void> getNews() async {
    String url =
        'http://newsapi.org/v2/top-headlines?country=in&category=business&apiKey=82f26870611e408799998d00a731566d';

    var response = await http.get(url);
    var jsonData = jsonDecode(response.body);

    if (jsonData['status'] == 'ok') {
      jsonData['articles'].forEach((element) {
        if (element["urlToImage"] != null && element["description"] != null) {
          ArticleModel articleModel = ArticleModel(
            title: element['title'],
            sourceName: element['source']['name'],
            description: element['description'],
            url: element['url'],
            urlToImage: element['urlToImage'],
            //publishedAt: element['publishedAt'],
            content: element['content'],
          );
          news.add(articleModel);
        }
      });
    }
  }
}

class CategoryNewsClass {
  List<ArticleModel> news = [];
  Future<void> getNews(String category) async {
    String url =
        'http://newsapi.org/v2/top-headlines?country=in&category=$category&apiKey=82f26870611e408799998d00a731566d';

    var response = await http.get(url);
    var jsonData = jsonDecode(response.body);

    if (jsonData['status'] == 'ok') {
      jsonData['articles'].forEach((element) {
        if (element["urlToImage"] != null && element["description"] != null) {
          ArticleModel articleModel = ArticleModel(
            title: element['title'],
            sourceName: element['source']['name'],
            description: element['description'],
            url: element['url'],
            urlToImage: element['urlToImage'],
            //publishedAt: element['publishedAt'],
            content: element['content'],
          );
          news.add(articleModel);
        }
      });
    }
  }
}
