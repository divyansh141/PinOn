import 'dart:io';

import 'package:TimesWall/helper/databaseHandle.dart';
import 'package:TimesWall/helper/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileView extends StatefulWidget {
  String searchedUserEmail;
  ProfileView({this.searchedUserEmail});
  @override
  _ProfileViewState createState() => _ProfileViewState(searchedUserEmail);
}

class _ProfileViewState extends State<ProfileView> {
  String searchedUserEmail;
  _ProfileViewState(this.searchedUserEmail);
  String userName;
  String profilePhotoLink;
  Stream articleStream;
  DatabaseMethods databaseMethods = DatabaseMethods();

  String followButtonText = 'Follow';
  bool _isFollowing = false;
  String following;

  var selectedImage;
  bool _isLoading = false;
  bool _isTyping = false;
  String newUsername;

  updateProfilePhoto() async {
    var image = await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      selectedImage = File(image.path);
    });
    if (selectedImage != null) {
      setState(() {
        _isLoading = true;
      });
      // Upload the image to Firebase Storage
      StorageReference storageReference = FirebaseStorage.instance
          .ref()
          .child('Profile Photo')
          .child('ProfilePhoto.jpg');

      StorageUploadTask storageUploadTask =
          storageReference.putFile(selectedImage);

      // Get the download url of that uploaded image so that we can use it to retrive image
      var downloadUrl =
          await (await storageUploadTask.onComplete).ref.getDownloadURL();
      databaseMethods.addProfilePhoto(downloadUrl);
      setState(() {
        _isLoading = false;
      });
    }
  }

  getUsername() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(searchedUserEmail)
        .get()
        .then((value) {
      setState(() {
        userName = value.data()['username'];
      });
    });
  }

  getProfilePhoto() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(searchedUserEmail)
        .get()
        .then((value) {
      setState(() {
        profilePhotoLink = value.data()['profile photo'];
      });
    });
  }

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
                      return UserArticleTile(
                          title:
                              snapshot.data.docs[index].data()['articleTitle'],
                          desc: snapshot.data.docs[index].data()['articleDesc'],
                          imgUrl: snapshot.data.docs[index].data()['imageUrl'],
                          shortDesc:
                              snapshot.data.docs[index].data()['shortDesc']);
                    })
                : Container(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(),
                  );
          }),
    );
  }

  Widget CountFollowing(data) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('data')
            .doc(searchedUserEmail)
            .collection('$data')
            .snapshots(),
        builder: (context, snapshot) {
          return Text(
            snapshot.data.docs.length.toString(),
            style: TextStyle(
              fontSize: 22,
              fontFamily: 'FredokaOne',
            ),
          );
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUsername();
    getProfilePhoto();

    articleStream = databaseMethods.getData(searchedUserEmail);
    FirebaseFirestore.instance
        .collection('data')
        .doc(FirebaseAuth.instance.currentUser.email)
        .collection('following')
        .get()
        .then((value) {
      setState(() {
        following = value.docs.length.toString();
      });
    });

    databaseMethods
        .checkFollowing(searchedUserEmail)
        .then((value) => _isFollowing = value.docs[0].exists)
        .catchError((e) => _isFollowing = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        titleSpacing: NavigationToolbar.kMiddleSpacing.sign,
        title: Text(
          'Profile',
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
      backgroundColor: Colors.white,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.26,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            CountFollowing('following'),
                            Text(
                              'Following',
                              style: TextStyle(
                                fontSize: 22,
                                fontFamily: 'FredokaOne',
                              ),
                            ),
                          ],
                        ),
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: profilePhotoLink == null
                              ? AssetImage('assets/profile.png')
                              : NetworkImage(profilePhotoLink),
                        ),
                        Column(
                          children: [
                            CountFollowing('followers'),
                            Text(
                              'Followers',
                              style: TextStyle(
                                fontSize: 22,
                                fontFamily: 'FredokaOne',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    _isTyping
                        ? Container(
                            padding: EdgeInsets.only(left: 50),
                            width: 200,
                            child: TextField(
                              onChanged: (value) {
                                newUsername = value;
                              },
                              decoration: InputDecoration(
                                hintText: 'Username...',
                                hintStyle: TextStyle(color: Colors.grey),
                                suffixIcon: IconButton(
                                    icon: Icon(
                                      Icons.check,
                                      color: Colors.lightBlueAccent[400],
                                    ),
                                    onPressed: () async {
                                      if (newUsername != null) {
                                        await databaseMethods
                                            .updateUsername(newUsername);
                                        setState(() {
                                          _isTyping = false;
                                        });
                                        Navigator.popAndPushNamed(
                                            context, 'profilePage');
                                      }
                                    }),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.transparent)),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent),
                                ),
                              ),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 52,
                              ),
                              Text(
                                userName ?? ' ',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontFamily: 'Pacifico',
                                  //fontWeight: FontWeight.w600,
                                ),
                              ),
                              IconButton(
                                  icon: Icon(
                                    Icons.edit,
                                    size: 16,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isTyping = true;
                                    });
                                  })
                            ],
                          ),
                    Container(
                      height: 30,
                      decoration: BoxDecoration(
                          color: Colors.lightBlueAccent[400],
                          border:
                              Border.all(color: Colors.lightBlueAccent[400]),
                          borderRadius: BorderRadius.circular(50)),
                      child: FlatButton(
                        onPressed: () async {
                          if (_isFollowing) {
                            databaseMethods.unfollowFunction(searchedUserEmail);
                            setState(() {
                              _isFollowing = false;
                            });
                          } else if (!_isFollowing) {
                            databaseMethods.followFunction(searchedUserEmail);
                            setState(() {
                              _isFollowing = true;
                            });
                          }
                        },
                        child: Text(
                          _isFollowing ? 'Unfollow' : 'Follow' ?? ' ',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.black87,
                      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                      width: MediaQuery.of(context).size.width,
                      height: 1,
                    ),
                  ],
                ),
              ),
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
