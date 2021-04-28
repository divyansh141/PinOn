import 'dart:io';

import 'package:TimesWall/NewsFeed.dart';
import 'package:TimesWall/communityPage.dart';
import 'package:TimesWall/helper/databaseHandle.dart';
import 'package:TimesWall/helper/widgets.dart';
import 'package:TimesWall/loginPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String userName;
  String profilePhotoLink;
  Stream articleStream;
  DatabaseMethods databaseMethods = DatabaseMethods();

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
        .doc(FirebaseAuth.instance.currentUser.email)
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
        .doc(FirebaseAuth.instance.currentUser.email)
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
                      return PublishedArticleTile(
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
            .doc(FirebaseAuth.instance.currentUser.email)
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

    articleStream =
        databaseMethods.getData(FirebaseAuth.instance.currentUser.email);
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
        actions: [
          FlatButton(
            onPressed: () async {
              try {
                SharedPreferences sharedPref =
                    await SharedPreferences.getInstance();
                sharedPref.remove('email');
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              } catch (e) {
                print(e);
              }
            },
            child: Text('Log out'),
          )
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
              onPressed: () {},
              icon: Icon(
                Icons.account_circle_rounded,
                size: 40,
                color: Colors.lightBlueAccent[400],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                //height: MediaQuery.of(context).size.height * 0.29,
                //width: MediaQuery.of(context).size.width,
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
                          border:
                              Border.all(color: Colors.lightBlueAccent[400]),
                          borderRadius: BorderRadius.circular(50)),
                      child: FlatButton(
                        onPressed: () async {
                          await updateProfilePhoto();
                          Navigator.popAndPushNamed(context, 'profilePage');
                        },
                        child: Text(_isLoading
                            ? 'Uploading...'
                            : 'Change Profile Photo'),
                      ),
                    ),
                    Container(
                      color: Colors.black87,
                      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                      width: MediaQuery.of(context).size.width,
                      height: 1,
                    ),
                     Container(
                        height: MediaQuery.of(context).size.height * 0.70,
                        child: ArticleList(),
                    ),
                  ],
                ),
              ),
             
            ],
          ),
        ),
      ),
    );
  }
}
