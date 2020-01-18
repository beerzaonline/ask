import 'package:blog/Home.dart';
import 'package:blog/mainRegistor.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// void main() {
//   runApp(MaterialApp(
//     theme: ThemeData(fontFamily: 'Mitr'),
//     debugShowCheckedModeBanner: false,
//     home: Login(),
//   ));
// }

Future<void> _saveUserName(String username) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('username', username);
}

Future<void> _login(int id) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setInt('id', id);
}

Future<void> _logout() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setInt('id', null);
}

Future<bool> _checkLogin() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int temp = await prefs.getInt('id');
  if (temp == null) {
    return false;
  } else {
    return true;
  }
}

Future<int> _getId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return await prefs.getInt('id');
}

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _Login();
  }
}

class _Login extends State {
  TextEditingController userName = TextEditingController();
  TextEditingController passWord = TextEditingController();

  // void initState() {
  //   super.initState();
  //   _checkLogin().then((bool res) => {
  //         if (res)
  //           {
  //             _getId().then((int id) => Navigator.pushReplacement(context,
  //                 MaterialPageRoute(builder: (BuildContext) => home(id))))
  //           }
  //       });
  // }

  void onLogin() {
    Map reqData = Map();
    reqData["userName"] = userName.text;
    reqData["passWord"] = passWord.text;
    http.post('${config.API_url}/user/login', body: reqData).then((response) {
      print(response.body);
      Map jsonMap = jsonDecode(response.body) as Map;
      int status = jsonMap["status"];
      int data = jsonMap["data"];

      if (status == 0) {
        _login(data);
        _saveUserName(userName.text);
        Navigator.pop(context);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => home(data)));
      } else {
        Alert(
          context: context,
          type: AlertType.error,
          title: "Username หรือ Password ไม่ถูกต้อง",
          buttons: [
            DialogButton(
              child: Text(
                "ตกลง",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context),
              width: 120,
            )
          ],
        ).show();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: ListView(
        padding: EdgeInsets.only(left: 50.0, right: 50.0, top: 60.0),
        children: <Widget>[
          new Icon(
            Icons.lock_open,
            color: Colors.green,
            size: 100,
          ),
          new Container(
            margin: new EdgeInsets.only(left: 0.05, right: 0.05, top: 20.0),
            decoration: new BoxDecoration(
              color: Color.fromARGB(255, 240, 240, 240),
              border: new Border.all(width: 1.2, color: Colors.black12),
              borderRadius: const BorderRadius.all(const Radius.circular(25.0)),
            ),
            child: TextField(
              controller: userName,
              decoration: InputDecoration(
                  contentPadding: new EdgeInsets.all(10.0),
                  border: InputBorder.none,
                  hintText: ': Username'),
            ),
          ),
          new Container(
            margin: new EdgeInsets.only(left: 1.0, right: 1.0, top: 20),
            decoration: new BoxDecoration(
              color: Color.fromARGB(255, 240, 240, 240),
              border: new Border.all(width: 1.2, color: Colors.black12),
              borderRadius: new BorderRadius.all(const Radius.circular(25.0)),
            ),
            child: TextField(
              controller: passWord,
              decoration: InputDecoration(
                  contentPadding: new EdgeInsets.all(10.0),
                  border: InputBorder.none,
                  hintText: ': Password'),
              obscureText: true,
            ),
          ),
          new Container(
            margin: new EdgeInsets.only(top: 50),
            child: RaisedButton(
              onPressed: onLogin,
              child: Text('Login'),
              textColor: Colors.white,
              color: Colors.blue,
            ),
          ),
          FlatButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext) => Register()));
            },
            child: Text("Register"),
          ),
          /*
          FlatButton(
            onPressed: (){},
            child: Text("Forget Password"),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: 110.0, right: 80.0, top: 30.0, bottom: 30.0),
            child: Text("register"),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: 80.0, right: 50.0, top: 5.0, bottom: 30.0),
            child: Text("forget password?"),
          ),
          */
        ],
      ),
    );
  }
}
