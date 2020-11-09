import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WatchedVideo {
  String message;
  Timestamp createAt;
  var sumTime;
  List videoList;
  WatchedVideo({this.createAt, this.message, this.sumTime, this.videoList});
}

class MainModel extends ChangeNotifier {
  List<WatchedVideo> watchedVideoList = [];
  final _firebaseUser = FirebaseAuth.instance.currentUser.uid;

  Future fetchWatchedVideo() async {
    final watchedList = await FirebaseFirestore.instance
        .collection('users')
        .doc(_firebaseUser)
        .collection('youtubeReservationList')
        .get();
    this.watchedVideoList = watchedList.docs
        .map((doc) => WatchedVideo(
            message: doc.data()['message'],
            createAt: doc.data()['createAt'],
            sumTime: doc.data()['sumTime'],
            videoList: doc.data()['videoList']))
        .toList();
    this.watchedVideoList = watchedVideoList;
    print(watchedVideoList.length);
  }

  notifyListeners();
}
