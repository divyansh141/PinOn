import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

var fsPath = FirebaseFirestore.instance.collection('data');

class DatabaseMethods {
  addPin(Map<String, dynamic> pinMap) {
    fsPath
        .doc(FirebaseAuth.instance.currentUser.email)
        .collection('pins')
        .add(pinMap)
        .catchError((e) {
      print(e);
    });
  }

  deletePin(String title) {
    fsPath
        .doc(FirebaseAuth.instance.currentUser.email)
        .collection('pins')
        .where('title', isEqualTo: title)
        .get()
        .then((value) => fsPath
            .doc(FirebaseAuth.instance.currentUser.email)
            .collection('pins')
            .doc(value.docs[0].id)
            .delete());
  }

  addData(articleData, context) {
    fsPath
        .doc(FirebaseAuth.instance.currentUser.email)
        .collection('published articles')
        .add(articleData)
        .catchError((e) {
      print(e);
    }).then((result) => Navigator.pop(context));
  }

  getData(email) {
    return fsPath
        .doc(email)
        .collection('published articles')
        .orderBy('time', descending: true)
        .snapshots();
  }

  addProfilePhoto(profileLink) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.email)
        .update({
      'profile photo': profileLink,
    });
  }

  updateUsername(String username) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.email)
        .update({
      'username': username,
    });
  }

  deleteArticle(String title) {
    fsPath
        .doc(FirebaseAuth.instance.currentUser.email)
        .collection('published articles')
        .where('articleTitle', isEqualTo: title)
        .get()
        .then((value) => fsPath
            .doc(FirebaseAuth.instance.currentUser.email)
            .collection('published articles')
            .doc(value.docs[0].id)
            .delete());
  }

  searchUser(String username) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .get();
  }

  checkFollowing(email) async {
    return await FirebaseFirestore.instance
        .collection('data')
        .doc(FirebaseAuth.instance.currentUser.email)
        .collection('following')
        .where('email', isEqualTo: email)
        .get();
  }

  followFunction(searchedUserEmail) {
    FirebaseFirestore.instance
        .collection('data')
        .doc(FirebaseAuth.instance.currentUser.email)
        .collection('following')
        .doc(searchedUserEmail)
        .set({'email': searchedUserEmail});
    FirebaseFirestore.instance
        .collection('data')
        .doc(searchedUserEmail)
        .collection('followers')
        .doc(searchedUserEmail)
        .set({'email': searchedUserEmail});
  }

  unfollowFunction(searchedUserEmail) async {
    await FirebaseFirestore.instance
        .collection('data')
        .doc(FirebaseAuth.instance.currentUser.email)
        .collection('following')
        .doc(searchedUserEmail)
        .delete();
    FirebaseFirestore.instance
        .collection('data')
        .doc(searchedUserEmail)
        .collection('followers')
        .doc(searchedUserEmail)
        .delete();
  }

  getPosts(email) {
    return fsPath
        .doc(email)
        .collection('published articles')
        .orderBy('time', descending: true)
        .snapshots();
  }

  getFollowing() {
    return fsPath
        .doc(FirebaseAuth.instance.currentUser.email)
        .collection('following')
        .snapshots();
  }
}
