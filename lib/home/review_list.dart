import 'package:clay_containers/clay_containers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class ReviewList extends StatefulWidget {
  @override
  _ReviewListState createState() => _ReviewListState();
}

class _ReviewListState extends State<ReviewList> {
  int hour = 0;
  int min = 0;
  int sec = 0;
  int timeForTimer = 0;
  int sw = 0;
  String timeToDisplay = '';
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final authResult = _firebaseAuth.currentUser.uid;

    Color fontColor = Color(0xFF3c3c3c);

    return Scaffold(
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(authResult)
                .collection('youtubeReservationList')
                .orderBy('createAt', descending: true)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: GFLoader(type: GFLoaderType.circle),
                );
              } else {
                return SingleChildScrollView(
                  child: Container(
                      child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      padding:
                                          EdgeInsets.only(top: 80, left: 20),
                                      child: FloatingActionButton(
                                        tooltip: '戻る',
                                        child: Icon(Icons.arrow_back,
                                            color: Colors.white),
                                        backgroundColor: Color(0xFF2D89AD),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 200),
                                  child: Text('Review List',
                                      style: TextStyle(
                                        fontSize: 26,
                                        letterSpacing: 0.8,
                                        fontWeight: FontWeight.w800,
                                        color: fontColor,
                                        fontFamily: 'Raleway',
                                      )),
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16, right: 16, top: 1),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 10),
                                          ListView.separated(
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemCount:
                                                  snapshot.data.docs.length,
                                              separatorBuilder:
                                                  (BuildContext context,
                                                          int index) =>
                                                      Divider(),
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                final _watchList =
                                                    snapshot.data.docs[index];
                                                final _watchCount = snapshot
                                                    .data.docs[index]
                                                    .data()['videoList']
                                                    .length;
                                                Timestamp createAt =
                                                    _watchList.get('createAt');
                                                DateTime eachDate =
                                                    createAt.toDate();
                                                final watchedMessage =
                                                    _watchList.get('message');
                                                return Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    ListTile(
                                                        title: (watchedMessage !=
                                                                null)
                                                            ? Text(
                                                                _watchList
                                                                    .get(
                                                                        'message')
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        22))
                                                            : Text('no message',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        22)),
                                                        subtitle: Text(
                                                            eachDate
                                                                .toString()
                                                                .substring(
                                                                    0, 19),
                                                            style: TextStyle(
                                                                fontSize: 16))),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 6, left: 26),
                                                      child: SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.6,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          // mainAxisAlignment: MainAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                                '本数 ： ${_watchCount.toString()}本',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20)),
                                                            ListView.builder(
                                                                shrinkWrap:
                                                                    true,
                                                                physics:
                                                                    const NeverScrollableScrollPhysics(),
                                                                itemCount:
                                                                    _watchCount,
                                                                itemBuilder:
                                                                    (context,
                                                                        index) {
                                                                  return (!snapshot
                                                                          .hasData)
                                                                      ? Center(
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              CircularProgressIndicator()
                                                                            ],
                                                                          ),
                                                                        )
                                                                      : ListTile(
                                                                          title:
                                                                              Image.network(
                                                                            'https://img.youtube.com/vi/' +
                                                                                _watchList.data()['videoList'][index] +
                                                                                '/0.jpg',
                                                                            fit:
                                                                                BoxFit.contain,
                                                                          ),
                                                                          subtitle:
                                                                              Text(_watchList.get('videoTitle')[index]),
                                                                        );
                                                                })
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                );
                                              }),
                                          SizedBox(height: 40),
                                        ]))
                              ],
                            ),
                          ))),
                );
              }
            }));
  }
}

//var timeForTimer = snapshot
//                                                     .data.docs[index]
//                                                     .get('sumTime');
//                                                 if (timeForTimer < 60) {
//                                                   timeToDisplay =
//                                                       timeForTimer.toString() +
//                                                           '秒';
//                                                   timeForTimer =
//                                                       timeForTimer - 1;
//                                                 } else if (timeForTimer <
//                                                     3600) {
//                                                   int m = timeForTimer ~/ 60;
//                                                   int s =
//                                                       timeForTimer - (60 * m);
//                                                   timeToDisplay = m.toString() +
//                                                       '分' +
//                                                       s.toString() +
//                                                       '秒';
//                                                   timeForTimer =
//                                                       timeForTimer - 1;
//                                                 } else {
//                                                   int h = timeForTimer ~/ 3600;
//                                                   int t =
//                                                       timeForTimer - (3600 * h);
//                                                   int m = t ~/ 60;
//                                                   int s = t - (60 * m);
//                                                   timeToDisplay = h.toString() +
//                                                       '時間' +
//                                                       m.toString() +
//                                                       '分' +
//                                                       s.toString() +
//                                                       '秒';
//                                                   timeForTimer =
//                                                       timeForTimer - 1;
//                                                 }
