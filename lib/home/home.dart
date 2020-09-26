import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_new_mytube_app/SetUp/welcome.dart';
import 'package:flutter_new_mytube_app/charts/new_chart.dart';
import 'package:flutter_new_mytube_app/home/review_list.dart';
import 'package:getwidget/getwidget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    //firebaseのimportしてきたclassのinstanceなので気にせず、currentUser.uidからuserのidを取得しましょう。
    // TODO 非同期処理でuserのuidを取得すること。
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final authResult = _firebaseAuth.currentUser.uid;

    //color setting
    Color fontColor = Color(0xFF3c3c3c);

    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(authResult)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: GFLoader(type: GFLoaderType.circle),
              );
            } else {
              return SingleChildScrollView(
                child: Container(
                  color: Color(0xFFF2F2F2),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    // padding: const EdgeInsets.only(left: 20),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 45),
                          Text('Yap!',
                              style: TextStyle(
                                fontSize: 24,
                                letterSpacing: 0.8,
                                fontWeight: FontWeight.w800,
                                color: fontColor,
                                fontFamily: 'Raleway',
                              )),
                          Container(
                              child: Text(" " + snapshot.data.get('name'),
                                  style: TextStyle(
                                      fontSize: 33,
                                      letterSpacing: 0.8,
                                      fontWeight: FontWeight.w800,
                                      color: fontColor,
                                      fontFamily: 'Raleway'))),
                          SizedBox(height: 40),
                          // TODO conditionf分析作成
                          // ClayContainer(
                          //   height: 180,
                          //   width: MediaQuery
                          //       .of(context)
                          //       .size
                          //       .width * 0.8,
                          //   depth: 12,
                          //   spread: 12,
                          //   borderRadius: 16,
                          //   child: Padding(
                          //     padding: const EdgeInsets.only(
                          //         left: 16, right: 16, top: 16),
                          //     child: Column(
                          //       children: [
                          //         Container(
                          //           child: Text(
                          //               'Your condition for this week !',
                          //               style: TextStyle(
                          //                 fontSize: 21,
                          //                 letterSpacing: 0.8,
                          //                 fontWeight: FontWeight.w800,
                          //                 color: fontColor,
                          //                 fontFamily: 'Raleway',
                          //               )
                          //           ),
                          //         ),
                          //         SizedBox(height: 12),
                          //         Padding(
                          //           padding: const EdgeInsets.all(16.0),
                          //           child: Row(
                          //             children: [
                          //               Image.asset('images/test.png',height: 75),
                          //               Padding(
                          //                 padding: const EdgeInsets.only(left: 50),
                          //                 child: Column(
                          //                   crossAxisAlignment: CrossAxisAlignment.start,
                          //                   children: [
                          //                     Text(
                          //                         '依存度 : ${snapshot.data.get('addiction')}',
                          //                         style: TextStyle(
                          //                           fontSize: 22,
                          //                           fontWeight: FontWeight.w300,
                          //                           color: fontColor,
                          //
                          //                         )
                          //                     ),
                          //                     SizedBox(height: 10),
                          //                     Text(
                          //                         '改善度 :  -40',
                          //                         style: TextStyle(
                          //                           fontSize: 22,
                          //                           fontWeight: FontWeight.w300,
                          //                           color: fontColor,
                          //                         )
                          //                     ),
                          //                   ],
                          //                 ),
                          //               ),
                          //             ],
                          //           ),
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                          // SizedBox(height: 40),
                          Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ClayContainer(
                                  height: 480,
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  depth: 12,
                                  spread: 12,
                                  borderRadius: 16,
                                  color: Color(0xFFF2F2F2),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16, right: 16, top: 16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('avarage time (once)',
                                            style: TextStyle(
                                              fontSize: 22.8,
                                              letterSpacing: 0.8,
                                              fontWeight: FontWeight.w800,
                                              color: fontColor,
                                              fontFamily: 'Raleway',
                                            )),
                                        SizedBox(height: 10),
                                        StreamBuilder<QuerySnapshot>(
                                          stream: FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(authResult)
                                              .collection('youtubeWatchList')
                                              .orderBy('createAt',
                                                  descending: true)
                                              .limit(7)
                                              .snapshots(),
                                          builder: (BuildContext context,
                                              AsyncSnapshot<QuerySnapshot>
                                                  snapshot) {
                                            if (!snapshot.hasData)
                                              return new Text("少々お待ちください");
                                            if (snapshot.data.docs.length == 0)
                                              return new ListTile(
                                                  title: Text(
                                                'まだ記録がないようです...',
                                                style:
                                                    TextStyle(fontSize: 12.5),
                                              ));

                                            final snapDate = snapshot.data;
                                            int sevenTimes = 0;
                                            for (int i = 0;
                                                i < snapDate.docs.length;
                                                i++) {
                                              sevenTimes = sevenTimes +
                                                  snapDate.docs[i]
                                                      .get('sumTime');
                                            }
                                            final finalSevenTimes =
                                                ((sevenTimes / 3600) / 7)
                                                    .round();
                                            return Text(
                                                '$finalSevenTimes hours',
                                                style: TextStyle(
                                                  fontSize: 25,
                                                  letterSpacing: 0.8,
                                                  fontWeight: FontWeight.w800,
                                                  color: fontColor,
                                                  fontFamily: 'Raleway',
                                                ));
                                          },
                                        ),
                                        SizedBox(height: 25),
                                        // chart by plugin
                                        LineChartSample2(),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 40),
                          Center(
                            child: Column(
                              children: [
                                ClayContainer(
                                    height:
                                        MediaQuery.of(context).size.width * 1.2,
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    depth: 12,
                                    spread: 12,
                                    borderRadius: 16,
                                    child: FlatButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ReviewList()));
                                      },
                                      child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 16, right: 16, top: 16),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text('Review',
                                                  style: TextStyle(
                                                    fontSize: 22.8,
                                                    letterSpacing: 0.8,
                                                    fontWeight: FontWeight.w800,
                                                    color: fontColor,
                                                    fontFamily: 'Raleway',
                                                  )),
                                              Container(
                                                child: StreamBuilder<
                                                    QuerySnapshot>(
                                                  stream: FirebaseFirestore
                                                      .instance
                                                      .collection('users')
                                                      .doc(authResult)
                                                      .collection(
                                                          'youtubeWatchList')
                                                      .orderBy('createAt',
                                                          descending: true)
                                                      .snapshots(),
                                                  builder:
                                                      (BuildContext context,
                                                          AsyncSnapshot<
                                                                  QuerySnapshot>
                                                              snapshot) {
                                                    if (!snapshot.hasData)
                                                      return new Text(
                                                          "There is no expense");
                                                    if (snapshot
                                                            .data.docs.length ==
                                                        0)
                                                      return new ListTile(
                                                          title: Text(
                                                              'まだ記録がないようです...',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      12)));
                                                    return ListView.separated(
                                                        shrinkWrap: true,
                                                        physics:
                                                            const NeverScrollableScrollPhysics(),
                                                        itemCount: snapshot
                                                            .data.docs.length,
                                                        separatorBuilder:
                                                            (BuildContext
                                                                        context,
                                                                    int
                                                                        index) =>
                                                                Divider(),
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context,
                                                                int index) {
                                                          final _watchList =
                                                              snapshot.data
                                                                  .docs[index];
                                                          Timestamp createAt =
                                                              _watchList.get(
                                                                  'createAt');
                                                          DateTime eachDate =
                                                              createAt.toDate();
                                                          if (_watchList
                                                                  .data()
                                                                  .length <=
                                                              index) {
                                                            return Text(
                                                                'this is error');
                                                          }
                                                          if (index < 4) {
                                                            return ListTile(
                                                                title: Text(
                                                                    _watchList.get(
                                                                        'purpose')),
                                                                subtitle: Text(eachDate
                                                                    .toString()
                                                                    .substring(
                                                                        0,
                                                                        19)));
                                                          } else {
                                                            return null;
                                                          }
                                                        });
                                                  },
                                                ),
                                              ),
                                            ],
                                          )),
                                    )),
                              ],
                            ),
                          ),
                          SizedBox(height: 50),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
          }),
    );
  }
}

// Container(
// child: StreamBuilder<DocumentSnapshot>(
// stream: FirebaseFirestore.instance.collection('users')
// .doc(authResult)
// .snapshots(),
// builder: (BuildContext context,
//     AsyncSnapshot<DocumentSnapshot> snapshot) {
// return Text(
// snapshot.data.get('name'),
// style: TextStyle(fontSize: 30.0)
// );
// },
// ),
// ),
