import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_new_mytube_app/SetUp/signIn.dart';
import 'package:flutter_new_mytube_app/SetUp/signup.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'Welcome to Mytube !',
                    style: TextStyle(fontSize: 30.0),
                  ),
                )
              ],
            ),
            new Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(23.0),
                    child: Container(
                      child: ButtonTheme(
                        height: 60.0,
                        padding: EdgeInsets.all(12.0),
                        child: RaisedButton(
                          child: Text(
                            "ログイン",
                            style:
                                TextStyle(fontSize: 20.0, color: Colors.white),
                          ),
                          color: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          onPressed: NavigateToSignIn,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            new Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(23.0),
                    child: Container(
                      child: ButtonTheme(
                        height: 60.0,
                        padding: EdgeInsets.all(12.0),
                        child: RaisedButton(
                          child: Text(
                            "新規登録",
                            style:
                                TextStyle(fontSize: 20.0, color: Colors.white),
                          ),
                          color: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          onPressed: NavigateToSignUp,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void NavigateToSignIn() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => LoginPage(), fullscreenDialog: true));
  }

  void NavigateToSignUp() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SignUpPage(), fullscreenDialog: true));
  }
}
