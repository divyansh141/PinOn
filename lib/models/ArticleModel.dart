import 'dart:core';

class ArticleModel {
  String sourceName;
  String title;
  String description;
  String url;
  String urlToImage;
  String content;
  DateTime publishedAt;

  ArticleModel({
    this.sourceName,
    this.title,
    this.description,
    this.url,
    this.urlToImage,
    this.content,
    this.publishedAt,
  });
}
