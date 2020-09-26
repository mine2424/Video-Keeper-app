import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartSample2 extends StatefulWidget {
  @override
  _LineChartSample2State createState() => _LineChartSample2State();
}

class _LineChartSample2State extends State<LineChartSample2> {
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  bool showAvg = false;

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final authResult = _firebaseAuth.currentUser.uid;

    return Stack(
      children: <Widget>[
        Container(
          child: Container(
            height: 340,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(18),
              ),
            ),
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(authResult)
                    .collection('youtubeWatchList')
                    .orderBy('createAt', descending: true)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData)
                    return new Text("少々お待ち下さい");
                  if (snapshot.data.docs.length == 0)
                    return new ListTile(title: Text('まだ記録がないようです...'));
                  final snapDate = snapshot.data;
                  var dataList = [];
                  var timeList = [];
                  if (snapDate.docs.length < 7) {
                    for (int s = 0; s < snapDate.docs.length; s++) {
                      Timestamp createAt = snapDate.docs[s].get('createAt');
                      DateTime dateAll = createAt.toDate();
                      var chartDay = dateAll.toString().substring(8, 11);
                      dataList.add(chartDay);
                      var sumTime =
                          ((snapDate.docs[s].get('sumTime')) / 3600) * 2;
                      timeList.add(sumTime);
                    }
                    for (int j = 0; j < 7 - snapDate.docs.length; j++) {
                      dataList.add(" ");
                      timeList.add(0.toDouble());
                    }
                  } else {
                    for (int i = 0; i < 7; i++) {
                      Timestamp createAt = snapDate.docs[i].get('createAt');
                      DateTime dateAll = createAt.toDate();
                      var chartDay = dateAll.toString().substring(8, 11);
                      dataList.add(chartDay);

                      var sumTime =
                          ((snapDate.docs[i].get('sumTime')) / 3600) * 2;
                      timeList.add(sumTime);
                    }
                  }

                  return Padding(
                    padding: const EdgeInsets.only(
                        right: 18.0, left: 12.0, top: 24, bottom: 12),
                    child: LineChart(LineChartData(
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: true,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: const Color(0xff37434d),
                            strokeWidth: 1,
                          );
                        },
                        getDrawingVerticalLine: (value) {
                          return FlLine(
                            color: const Color(0xff37434d),
                            strokeWidth: 1,
                          );
                        },
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 22,
                          textStyle: const TextStyle(
                              color: Color(0xff68737d),
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                          // ignore: missing_return
                          getTitles: (value) {
                            // if(value.toInt() == 0) {
                            //   return dataList[6];
                            // } else if(value.toInt() == 2){
                            //   return dataList[5];
                            // } else if(value.toInt() == 4){
                            //   return dataList[4];
                            // } else if(value.toInt() == 6){
                            //   return dataList[3];
                            // }else if(value.toInt() == 8){
                            //   return dataList[2];
                            // }else if(value.toInt() == 10){
                            //   return dataList[1];
                            // }else if(value.toInt() == 12) {
                            //   return '       '+dataList[0] + 'date' ;
                            // }
                          },
                          margin: 12,
                        ),
                        leftTitles: SideTitles(
                          showTitles: true,
                          textStyle: const TextStyle(
                            color: Color(0xff67727d),
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          getTitles: (value) {
                            switch (value.toInt()) {
                              case 0:
                                return '0';
                              case 1:
                                return '0.5';
                              case 2:
                                return '1.0';
                              case 3:
                                return '1.5';
                              case 4:
                                return '2.0';
                              case 5:
                                return '2.5';
                              case 6:
                                return '3.0';
                            }
                            return '';
                          },
                          reservedSize: 28,
                          margin: 12,
                        ),
                      ),
                      borderData: FlBorderData(
                          show: true,
                          border: Border.all(
                              color: const Color(0xff37434d), width: 1)),
                      minX: 0,
                      maxX: 12,
                      minY: 0,
                      maxY: 6,
                      lineBarsData: [
                        LineChartBarData(
                          spots: [
                            FlSpot(0, timeList[0]),
                            FlSpot(2, timeList[1]),
                            FlSpot(4, timeList[2]),
                            FlSpot(6, timeList[3]),
                            FlSpot(8, timeList[4]),
                            FlSpot(10, timeList[5]),
                            FlSpot(12, timeList[6]),
                          ],
                          isCurved: true,
                          colors: gradientColors,
                          barWidth: 5,
                          isStrokeCapRound: true,
                          dotData: FlDotData(
                            show: false,
                          ),
                          belowBarData: BarAreaData(
                            show: true,
                            colors: gradientColors
                                .map((color) => color.withOpacity(0.3))
                                .toList(),
                          ),
                        ),
                      ],
                    )),
                  );
                }),
          ),
        ),
        SizedBox(
          width: 62,
          height: 20,
          child: FlatButton(
            onPressed: () {
              setState(() {
                showAvg = !showAvg;
              });
            },
            child: Column(
              children: [
                Text(
                  'hour',
                  style: TextStyle(
                      fontSize: 12.5,
                      color: showAvg ? Color(0xff68737d) : Color(0xff68737d)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
