import 'dart:io';

import 'package:TimesWall/helper/databaseHandle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';

class WriteAnArticle extends StatefulWidget {
  @override
  _WriteAnArticleState createState() => _WriteAnArticleState();
}

class _WriteAnArticleState extends State<WriteAnArticle> {
  DatabaseMethods databaseMethods = DatabaseMethods();

  String articleTitle, articleDesc, shortDesc;
  var selectedImage;
  bool _isLoading = false;

  Future getImage() async {
    var image = await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      selectedImage = File(image.path);
    });
  }

  publishArticle() async {
    if (selectedImage != null) {
      setState(() {
        _isLoading = true;
      });
      // Upload the image to Firebase Storage
      StorageReference storageReference = FirebaseStorage.instance
          .ref()
          .child('Article Images')
          .child('${randomAlphaNumeric(9)}.jpg');

      StorageUploadTask storageUploadTask =
          storageReference.putFile(selectedImage);

      // Get the download url of that uploaded image so that we can use it to retrive image
      var downloadUrl =
          await (await storageUploadTask.onComplete).ref.getDownloadURL();

      // Now add all data in Firestore
      Map<String, dynamic> articleInfoMap = {
        'authorEmail': FirebaseAuth.instance.currentUser.email,
        'imageUrl': downloadUrl,
        'articleTitle': articleTitle,
        'shortDesc': shortDesc,
        'articleDesc': articleDesc,
        'time': DateTime.now().millisecondsSinceEpoch,
      };
      databaseMethods.addData(articleInfoMap, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        titleSpacing: NavigationToolbar.kMiddleSpacing.sign,
        title: Text(
          'Write an article',
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
        actions: [
          FlatButton(
            onPressed: () {
              publishArticle();
            },
            child: Text(
              'Publish',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            )
          : Container(
              margin: EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: selectedImage == null
                        ? IconButton(
                            icon: Icon(Icons.add_a_photo),
                            onPressed: () {
                              getImage();
                            })
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              selectedImage,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                  TextField(
                    onChanged: (value) => articleTitle = value,
                    maxLength: 100,
                    decoration: InputDecoration(
                      hintText: 'Your News Title',
                      hintStyle: TextStyle(fontSize: 20),
                      enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.lightBlueAccent[200])),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue[600]),
                      ),
                    ),
                  ),
                  TextField(
                    onChanged: (value) => shortDesc = value,
                    maxLength: 300,
                    decoration: InputDecoration(
                      hintText: 'Short Description',
                      hintStyle: TextStyle(fontSize: 18),
                      enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.lightBlueAccent[200])),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue[600]),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      onChanged: (value) => articleDesc = value,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: 'Write your article here...',
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent)),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
