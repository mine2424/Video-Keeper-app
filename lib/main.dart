import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_new_mytube_app/SetUp/welcome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_new_mytube_app/home/home.dart';
import 'package:flutter_new_mytube_app/setting/setting.dart';
import 'package:flutter_new_mytube_app/tabBarControll/tabBarControll.dart';
import 'package:flutter_new_mytube_app/youtube_alarm/alerm_setting.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:getwidget/getwidget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        //デバックラベル非表示
        debugShowCheckedModeBanner: false,
        title: 'Flutter Mytube app',
        theme: ThemeData(
          // primarySwatch: Color(fx00f9f9f9),Colors.white.withOpacity(0.5),
          backgroundColor: Color(0xFFF2F2F2),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          scaffoldBackgroundColor: Color(0xFFF2F2F2),
        ),
        home: LoginCheck(),
        initialRoute: "/",
        routes: {
          '/0': (context) => HomePage(),
          '/1': (context) => YoutubeAlarm(),
          '/2': (context) => Setting()
        });
  }
}

class LoginCheck extends StatefulWidget {
  LoginCheck({Key key}) : super(key: key);

  @override
  _LoginCheckState createState() => _LoginCheckState();
}

class _LoginCheckState extends State<LoginCheck> {
  //ログイン状態のチェック(非同期で行う)
  void checkUser() async {
    await Firebase.initializeApp();
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final authResult = _firebaseAuth.currentUser;
    if (authResult == null) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => WelcomePage()));
    } else {
      // print(authResult);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => TabBarControll()));
    }
  }

  @override
  void initState() {
    super.initState();
    checkUser();
  }

  //ログイン状態のチェック時はこの画面が表示される
  //チェック終了後にホーム or ログインページに遷移する
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GFLoader(type: GFLoaderType.circle),
        ],
      ),
    );
  }
}
