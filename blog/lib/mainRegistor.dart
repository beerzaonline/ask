import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'config.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Register(),
  ));
}

class Register extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _Register();
  }
}

class _Register extends State {
  TextEditingController _userName = TextEditingController();
  TextEditingController _passWord = TextEditingController();
  TextEditingController _passWord2 = TextEditingController();
  TextEditingController _firstName = TextEditingController();
  TextEditingController _lastName = TextEditingController();
  String _massage = "";
  bool _error = false;

  bool _checkPassword() {
    print(_passWord2);
    if (_passWord2.text != _passWord.text &&
        _passWord2.text.isNotEmpty &&
        _passWord.text.isNotEmpty) {
      setState(() {
        _error = true;
      });
    } else {
      setState(() {
        _error = false;
      });
    }
    return _error;
  }

  void onPressRegistor() {
    if (!_error) {
      Map<String, dynamic> param = Map();
      param['userName'] = _userName.text;
      param['passWord'] = _passWord.text;
      param['firstName'] = _firstName.text;
      param['lastName'] = _lastName.text;

      http
          .post('${config.API_url}/user/register', body: param)
          .then((response) {
        Map resMap = jsonDecode(response.body) as Map;
        int status = resMap['status'];
        if (status == 0) {
          Alert(
            context: context,
            type: AlertType.success,
            title: "สำเร็จ!",
            desc: "สมัครสมาชิกเรียบร้อยแล้ว",
            buttons: [
              DialogButton(
                child: Text(
                  "ตกลง",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                width: 120,
              )
            ],
          ).show();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: const Text('สมัครสมาชิก')),
      body: new ListView(
        padding: EdgeInsets.only(left: 15, right: 15, top: 20),
        children: <Widget>[
          new Container(
            padding: EdgeInsets.only(top: 5),
            child: new Row(
              children: <Widget>[
                new Icon(Icons.date_range),
                new Text('ข้อมูลส่วนตัว:'),
              ],
            ),
          ),
          new Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 15),
            child: TextFormField(
              controller: _userName,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  hintText: 'กรุณากรอกรหัสผู้ใช้งาน',
                  labelText: 'รหัสผู้ใช้งาน:',
                  labelStyle: TextStyle(fontSize: 15)),
              keyboardType: TextInputType.text,
            ),
          ),
          new Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 15),
            child: TextFormField(
              controller: _firstName,
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.perm_contact_calendar),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  hintText: 'กรุณากรอกชื่อ',
                  labelText: 'ชื่อ:',
                  labelStyle: TextStyle(fontSize: 15)),
              keyboardType: TextInputType.text,
            ),
          ),
          new Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 15),
            child: TextFormField(
              controller: _lastName,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.perm_contact_calendar),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                hintText: 'กรุณากรอกนามสกุล',
                labelText: 'นามสกุล:',
                labelStyle: TextStyle(fontSize: 15),
              ),
              keyboardType: TextInputType.text,
            ),
          ),
          new Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 15),
            child: TextFormField(
              controller: _passWord,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                hintText: 'กรุณากรอกรหัสผ่าน',
                labelText: 'รหัสผ่าน:',
                labelStyle: TextStyle(fontSize: 15),
              ),
              obscureText: true,
              keyboardType: TextInputType.text,
            ),
          ),
          new Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 15),
            child: TextFormField(
              controller: _passWord2,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                hintText: 'กรุณากรอกรหัสผ่านอีกครั้ง',
                labelText: 'รหัสผ่านอีกครั้ง:',
                labelStyle: TextStyle(fontSize: 15),
                errorText: _checkPassword() ? "รหัสผ่านไม่ตรงกัน" : null,
              ),
              obscureText: true,
              keyboardType: TextInputType.text,
            ),
          ),
          //Text('${_massage}'),
          new Container(
            child: Center(
              child: new RaisedButton(
                color: Colors.blue,
                child: const Text(
                  'ตกลง',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: onPressRegistor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
