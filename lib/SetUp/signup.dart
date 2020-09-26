import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_new_mytube_app/SetUp/signIn.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String _name, _email, _password,_age,_addiction;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
          child: Scaffold(
        appBar: AppBar(
          title: Text('アカウント作成'),
          backgroundColor: Colors.amberAccent,
        ),
        body: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                validator: (input){
                  if (input.isEmpty){
                    return '名前を入力してください';
                  }
                },
                onSaved: (input) => _name = input,
                decoration: InputDecoration(
                  labelText: 'name',
                ),
              ),
              TextFormField(
                validator: (input){
                  if (input.isEmpty){
                    return 'Emailを入力してください';
                  }
                },
                onSaved: (input) => _email = input,
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
              ),
              TextFormField(
                validator: (input){
                  if (input.length < 6){
                    return 'パスワードを入力してください';
                  }
                },
                onSaved: (input) => _password = input,
                decoration: InputDecoration(
                  labelText: 'password',
                ),
                obscureText: true,
              ),
              TextFormField(
                validator: (input){
                  if (input.isEmpty){
                    return '年齢を入力してください';
                  }
                },
                onSaved: (input) => _age = input,
                decoration: InputDecoration(
                  labelText: 'age',
                  hintText: ' 何%? (%は記入しなくても良いです)'
                ),
              ),
              TextFormField(
                validator: (input){
                  if (input.isEmpty){
                    return '依存度を入力してください';
                  }
                },
                onSaved: (input) => _addiction = input,
                decoration: InputDecoration(
                  labelText: '依存度',
                ),
              ),
              RaisedButton(
                child: Text('新規登録！'),
                onPressed: signUp,
              )
            ],
          ),
        ),
      ),
    );
  }


  Future<void> signUp() async{
    if (_formKey.currentState.validate()){
      _formKey.currentState.save();
      //login and describe user details to firebase
      try{
        await Firebase.initializeApp();
        final UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _password);
        // print(userCredential.user);
        FirebaseFirestore.instance.collection('users').doc(userCredential.user.uid).set({
          'email': _email,
          'name': _name,
          'age': _age,
          'addiction': _addiction,
          'createAt': Timestamp.now()
        });
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
      }catch(error){
        print(error);
      }
    }
  }
}
