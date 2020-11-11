import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_new_mytube_app/home/home.dart';
import 'package:flutter_new_mytube_app/tabBarControll/tabBarControll.dart';

class ContactForm extends StatefulWidget {
  String idea;
  ContactForm({Key key, this.idea}) : super(key: key);
  @override
  _ContactFormState createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  String _callName, _callMail, _callContext;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            (widget.idea != '意見箱') ? Text('お問い合わせフォーム') : Text('アプリのご意見を下さい！'),
        backgroundColor: Color(0xFF2D89AD),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Text('お名前', style: TextStyle(fontSize: 20)),
                      TextFormField(
                        maxLength: 50,
                        maxLines: 1,
                        onSaved: (input) => _callName = input,
                      ),
                      SizedBox(height: 20),
                      Text('メールアドレス', style: TextStyle(fontSize: 20)),
                      TextFormField(
                        maxLength: 50,
                        maxLines: 1,
                        onSaved: (input) => _callMail = input,
                      ),
                      SizedBox(height: 20),
                      (widget.idea != '意見箱')
                          ? Text('ご用件', style: TextStyle(fontSize: 20))
                          : Text('ご意見', style: TextStyle(fontSize: 20)),
                      TextFormField(
                        maxLength: 100,
                        maxLines: 1,
                        onSaved: (input) => _callContext = input,
                      ),
                      SizedBox(height: 60),
                      SizedBox(
                        width: 200,
                        height: 46,
                        child: RaisedButton(
                          child: Text("送信",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20)),
                          color: Color(0xFF2D89AD),
                          shape: StadiumBorder(),
                          onPressed: () {
                            if (_callName == "" ||
                                _callMail == "" ||
                                _callContext == "") {
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) {
                                    return AlertDialog(
                                        title: Text('確認'),
                                        content: Text('記入漏れがあります'),
                                        actions: <Widget>[
                                          FlatButton(
                                            child: Text('OK'),
                                            onPressed: () =>
                                                Navigator.of(context).pop(0),
                                          ),
                                        ]);
                                  });
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => FormFinish()));
                              addFormList();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> addFormList() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      //login and describe user details to firebase
      try {
        await Firebase.initializeApp();
        FirebaseFirestore.instance.collection('usersContactForm').add({
          'createAt': Timestamp.now(),
          'context': _callContext,
          'email': _callMail,
          'name': _callName
        });
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
      } catch (error) {
        print(error);
      }
    }
  }
}

class FormFinish extends StatefulWidget {
  @override
  _FormFinishState createState() => _FormFinishState();
}

class _FormFinishState extends State<FormFinish> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => TabBarControll()));
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '送信が完了しました！',
            style: TextStyle(fontSize: 20),
          ),
          Text(
            '3秒ほどでホームに戻ります',
            style: TextStyle(fontSize: 16),
          )
        ],
      ),
    );
  }
}
