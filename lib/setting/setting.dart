import 'package:clay_containers/clay_containers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_new_mytube_app/SetUp/welcome.dart';
import 'package:flutter_new_mytube_app/setting/form.dart';
import 'package:flutter_new_mytube_app/setting/policy.dart';

class Setting extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                ClayContainer(
                  height: MediaQuery.of(context).size.width * 0.23,
                  width: MediaQuery.of(context).size.width * 0.65,
                  depth: 12,
                  spread: 12,
                  borderRadius: 16,
                  child: FlatButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => AppPolicy()));
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                            child: Text(
                          '利用規約',
                          style: TextStyle(fontSize: 21),
                        )),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 40),
                ClayContainer(
                  height: MediaQuery.of(context).size.width * 0.2,
                  width: MediaQuery.of(context).size.width * 0.65,
                  depth: 12,
                  spread: 12,
                  borderRadius: 16,
                  child: FlatButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ContactForm()));
                    },
                    child: Text(
                      'お問い合わせフォーム',
                      style: TextStyle(fontSize: 21),
                    ),
                  ),
                ),
                SizedBox(height: 40),
                // ClayContainer(
                //   height: MediaQuery.of(context).size.width * 0.2,
                //   width: MediaQuery.of(context).size.width * 0.65,
                //   depth: 12,
                //   spread: 12,
                //   borderRadius: 16,
                //   child: FlatButton(
                //     onPressed: () {
                //       // Navigator.push(
                //       //     context,
                //       //     MaterialPageRoute(builder: (context) => AppRule())
                //       // );
                //     },
                //     child: Text(
                //       '使い方ガイド',
                //       style: TextStyle(fontSize: 21),
                //     ),
                //   ),
                // ),
                // SizedBox(height: 40),
                ClayContainer(
                  height: MediaQuery.of(context).size.width * 0.2,
                  width: MediaQuery.of(context).size.width * 0.65,
                  depth: 12,
                  spread: 12,
                  borderRadius: 16,
                  child: FlatButton(
                    onPressed: signOut,
                    child: Text(
                      'ログアウト',
                      style: TextStyle(fontSize: 21),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      return Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => WelcomePage()));
    } catch (e) {
      print(e);
    }
  }
}
