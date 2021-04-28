import 'package:TimesWall/helper/databaseHandle.dart';
import 'package:TimesWall/profileView.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  DatabaseMethods databaseMethods = DatabaseMethods();
  var auth = FirebaseAuth.instance;
  QuerySnapshot searchSnapshot;

  Widget searchList() {
    return searchSnapshot != null
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchSnapshot.docs.length,
            itemBuilder: (context, index) {
              return SearchTile(
                userName: searchSnapshot.docs[index].get('username'),
                email: searchSnapshot.docs[index].get('email'),
                profilePhoto: searchSnapshot.docs[index].get('profile photo'),
              );
            },
          )
        : Container();
  }

  String search;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.lightBlueAccent[400],
            ),
            onPressed: () => Navigator.pop(context)),
        actions: [
          Container(
            width: 300,
            margin: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(50),
            ),
            child: TextField(
              onChanged: (value) {
                databaseMethods.searchUser(value).then((val) {
                  setState(() {
                    searchSnapshot = val;
                  });
                });
              },
              decoration: InputDecoration(
                hintText: 'Search by username',
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.search_rounded),
            onPressed: () {
              databaseMethods.searchUser(search).then((val) {
                setState(() {
                  searchSnapshot = val;
                });
              });
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: searchList(),
    );
  }
}

class SearchTile extends StatelessWidget {
  String userName;
  String email;
  String profilePhoto;

  SearchTile({this.userName, this.email, this.profilePhoto});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        if (email != FirebaseAuth.instance.currentUser.email) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ProfileView(searchedUserEmail: email),
            ),
          );
        } else {
          Navigator.pushNamed(context, 'profilePage');
        }
      },
      leading: CircleAvatar(
        backgroundImage: profilePhoto == null
            ? AssetImage('assets/profile.png')
            : NetworkImage(profilePhoto),
      ),
      title: Text(
        userName,
        style: TextStyle(
            color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
      ),
      subtitle: Text(email, style: TextStyle(color: Colors.grey)),
    );
  }
}
