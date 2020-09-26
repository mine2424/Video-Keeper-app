import 'dart:async';
import 'package:clay_containers/clay_containers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_new_mytube_app/tabBarControll/tabBarControll.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class YoutubeAlarm extends StatefulWidget {
  @override
  _YoutubeAlarmState createState() => _YoutubeAlarmState();
}

class _YoutubeAlarmState extends State<YoutubeAlarm> {
  String _review, _purpose;
  double _currentSliderValue = 1;
  int hour = 0;
  int min = 0;
  int sec = 0;
  int timeForTimer = 0;
  int sw = 0;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Color fontColor = Color(0xFF3c3c3c);

  var _selectedIndex = 1;

  bool started = true;
  bool stopped = true;
  bool checkTimer = true;

  String timeToDisplay = '';

  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
  NotificationDetails platformChannelSpecifics;

  void start() {
    setState(() {
      started = false;
      stopped = false;
    });
    timeForTimer = ((hour * 60 * 60) + (min * 60) + sec);
    Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        // if (hour < 1 && min < 1 && sec < 1) {
        //   _updateNotification();
        // }
        if (timeForTimer < 1 || checkTimer == false) {
          _updateNotification();
          t.cancel();

          checkTimer = true;
          timeToDisplay = '';
          started = true;
          stopped = true;
          // Navigator.pushReplacement(context, newRoute);
        } else if (timeForTimer < 60) {
          timeToDisplay = timeForTimer.toString();
          timeForTimer = timeForTimer - 1;
        } else if (timeForTimer < 3600) {
          int m = timeForTimer ~/ 60;
          int s = timeForTimer - (60 * m);
          timeToDisplay = m.toString() + '分' + s.toString() + '秒';
          timeForTimer = timeForTimer - 1;
        } else {
          int h = timeForTimer ~/ 3600;
          int t = timeForTimer - (3600 * h);
          int m = t ~/ 60;
          int s = t - (60 * m);
          timeToDisplay =
              h.toString() + '時間' + m.toString() + '分' + s.toString() + '秒';

          timeForTimer = timeForTimer - 1;
        }
      });
    });
    Timer(Duration(seconds: 1), () => sw = timeForTimer + 1);
    if (timeForTimer == 1) {
      _updateNotification();
    }
  }

  void stop() {
    setState(() {
      started = true;
      stopped = true;
      checkTimer = false;
    });
  }

  @override
  void initState() {
    super.initState();

    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    _flutterLocalNotificationsPlugin.initialize(initializationSettings);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  }

  _updateNotification() async {
    debugPrint('Notification : start');
    //await _flutterLocalNotificationsPlugin.cancelAll();

    // final Time time = Time(hour, min, 0);
    var androidPlatformChannelSpecifics =
        AndroidNotificationDetails('MyTube', 'MyTube', 'Time\'s up');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await _flutterLocalNotificationsPlugin.show(0, 'MyTube アラーム',
        "設定時間を経過しました、アプリに戻って集計しましょう！", platformChannelSpecifics);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Center(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 50),
                    Center(
                      child: ClayContainer(
                        height: MediaQuery.of(context).size.width * 0.4,
                        width: MediaQuery.of(context).size.width * 0.8,
                        depth: 12,
                        spread: 12,
                        borderRadius: 16,
                        color: Color(0xFFF2F2F2),
                        child: Padding(
                            padding: const EdgeInsets.only(
                                left: 16, right: 16, top: 16),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('見る時間(分)',
                                      style: TextStyle(
                                          fontSize: 21,
                                          letterSpacing: 0.8,
                                          fontWeight: FontWeight.w800,
                                          color: fontColor,
                                          fontFamily: 'Raleway')),
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      RaisedButton(
                                        child: Text('時間設定'),
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return StatefulBuilder(
                                                  builder: (context, setState) {
                                                    return AlertDialog(
                                                      title:
                                                          Text('時間を設定してください'),
                                                      content: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        bottom:
                                                                            10),
                                                                child:
                                                                    Text("HH"),
                                                              ),
                                                              NumberPicker
                                                                  .integer(
                                                                initialValue:
                                                                    hour,
                                                                minValue: 0,
                                                                maxValue: 2,
                                                                listViewWidth:
                                                                    60.0,
                                                                onChanged:
                                                                    (value) {
                                                                  setState(() {
                                                                    hour =
                                                                        value;
                                                                  });
                                                                },
                                                              )
                                                            ],
                                                          ),
                                                          Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        bottom:
                                                                            10),
                                                                child:
                                                                    Text("MM"),
                                                              ),
                                                              NumberPicker
                                                                  .integer(
                                                                initialValue:
                                                                    min,
                                                                minValue: 0,
                                                                maxValue: 59,
                                                                listViewWidth:
                                                                    60.0,
                                                                onChanged:
                                                                    (value) {
                                                                  setState(() {
                                                                    min = value;
                                                                  });
                                                                },
                                                              )
                                                            ],
                                                          ),
                                                          Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        bottom:
                                                                            10),
                                                                child:
                                                                    Text("SS"),
                                                              ),
                                                              NumberPicker
                                                                  .integer(
                                                                initialValue:
                                                                    sec,
                                                                minValue: 0,
                                                                maxValue: 59,
                                                                listViewWidth:
                                                                    60.0,
                                                                onChanged:
                                                                    (value) {
                                                                  setState(() {
                                                                    sec = value;
                                                                  });
                                                                },
                                                              )
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      actions: [
                                                        FlatButton(
                                                          child: Text("OK"),
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  context),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              });
                                        },
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Text(
                                        '$hour時間$min分$sec秒',
                                        style: TextStyle(fontSize: 22),
                                      ),
                                    ],
                                  ),
                                ])),
                      ),
                    ),
                    SizedBox(height: 30),
                    Center(
                      child: ClayContainer(
                        height: MediaQuery.of(context).size.width * 0.4,
                        width: MediaQuery.of(context).size.width * 0.8,
                        depth: 12,
                        spread: 12,
                        borderRadius: 16,
                        color: Color(0xFFF2F2F2),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 16, right: 16, top: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('目的',
                                  style: TextStyle(
                                      fontSize: 21,
                                      letterSpacing: 0.8,
                                      fontWeight: FontWeight.w800,
                                      color: fontColor,
                                      fontFamily: 'Raleway')),
                              TextFormField(
                                maxLength: 50,
                                maxLines: 1,
                                onSaved: (input) => _purpose = input,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // 時間設定form
                    SizedBox(height: 30),
                    Center(
                      child: ClayContainer(
                          height: MediaQuery.of(context).size.width * 0.4,
                          width: MediaQuery.of(context).size.width * 0.8,
                          depth: 12,
                          spread: 12,
                          borderRadius: 16,
                          color: Color(0xFFF2F2F2),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 16, right: 16, top: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('見終わった後の気持ち',
                                    style: TextStyle(
                                        fontSize: 20,
                                        letterSpacing: 0.8,
                                        fontWeight: FontWeight.w800,
                                        color: fontColor,
                                        fontFamily: '')),
                                Slider(
                                  value: _currentSliderValue,
                                  min: 0,
                                  max: 100,
                                  divisions: 10,
                                  label: _currentSliderValue.round().toString(),
                                  onChanged: (double value) {
                                    setState(() {
                                      _currentSliderValue = value;
                                    });
                                  },
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('←bad',
                                        style: TextStyle(
                                            fontSize: 16,
                                            letterSpacing: 0.8,
                                            color: fontColor)),
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.38),
                                    Text('happy→',
                                        style: TextStyle(
                                            fontSize: 16,
                                            letterSpacing: 0.8,
                                            color: fontColor)),
                                  ],
                                )
                              ],
                            ),
                          )),
                    ),
                    SizedBox(height: 30),
                    Center(
                      child: ClayContainer(
                        height: MediaQuery.of(context).size.width * 0.4,
                        width: MediaQuery.of(context).size.width * 0.8,
                        depth: 12,
                        spread: 12,
                        borderRadius: 16,
                        color: Color(0xFFF2F2F2),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 16, right: 16, top: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('一言メモ',
                                  style: TextStyle(
                                      fontSize: 21,
                                      letterSpacing: 0.8,
                                      fontWeight: FontWeight.w800,
                                      color: fontColor,
                                      fontFamily: '')),
                              TextFormField(
                                maxLength: 50,
                                maxLines: 1,
                                onSaved: (input) => _review = input,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                    //動画スタートボタン
                    Center(
                      child: SizedBox(
                        width: 260,
                        height: 46,
                        child: RaisedButton(
                          child: Text("動画スタート！",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20)),
                          color: Color(0xFF2D89AD),
                          shape: StadiumBorder(),
                          onPressed: started ? start : null,
                        ),
                      ),
                    ),
                    Center(
                      child: Column(
                        children: [
                          if (timeForTimer < 10)
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text('終了後は集計ボタンを必ず押してください！',
                                  style: TextStyle(fontSize: 15.6)),
                            ),
                          SizedBox(
                            height: 10,
                          ),
                          ClayContainer(
                              height: MediaQuery.of(context).size.width * 0.3,
                              width: MediaQuery.of(context).size.width * 0.6,
                              depth: 12,
                              spread: 12,
                              borderRadius: 16,
                              color: Color(0xFFF2F2F2),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                      child: Text(timeToDisplay,
                                          style: TextStyle(fontSize: 26.5))),
                                ],
                              )),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: SizedBox(
                            width: 160,
                            height: 46,
                            child: RaisedButton(
                              child: Text("キャンセル",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20)),
                              color: Colors.red,
                              shape: StadiumBorder(),
                              onPressed: stopped ? null : stop,
                            ),
                          ),
                        ),
                        SizedBox(width: 30),
                        Center(
                          child: SizedBox(
                            width: 160,
                            height: 46,
                            child: RaisedButton(
                              child: Text("集計",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20)),
                              color: Colors.black,
                              shape: StadiumBorder(),
                              onPressed: sw == 0 ? null : addWatchList,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 50,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> addWatchList() async {
    FirebaseAuth _firebaseAuth = await FirebaseAuth.instance;
    final authResult = await _firebaseAuth.currentUser.uid;
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      //login and describe user details to firebase
      try {
        await Firebase.initializeApp();
        FirebaseFirestore.instance
            .collection('users')
            .doc(authResult)
            .collection('youtubeWatchList')
            .add({
          'purpose': _purpose,
          'sumTime': sw,
          'afterFeeling': _currentSliderValue,
          'review': _review,
          'createAt': Timestamp.now()
        });
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => TabBarControll()));
      } catch (error) {
        print(error);
      }
    }
  }
}
