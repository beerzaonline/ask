import 'package:blog/Listview.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'Login.dart';
import 'config.dart';
import 'dart:convert';

class home extends StatefulWidget {
  int _userId;

  home(int userId) {
    this._userId = userId;
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _home(_userId);
  }
}

Future<void> _logout() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setInt('id', null);
}

class _home extends State {
  int _userId;

  _home(int userId) {
    this._userId = userId;
  }

  List lst = new List();
  bool permission = false;

  Future<bool> onClose() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('ต้องการออกจากแอปหรือไม่ ?'),
              actions: <Widget>[
                FlatButton(
                  child: Text('ไม่ใช่'),
                  onPressed: () => Navigator.pop(context, false),
                ),
                FlatButton(
                  child: Text('ใช่'),
                  onPressed: () => Navigator.pop(context, true),
                ),
              ],
            ));
  }

  Future<bool> onLogOut() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('คุณต้องการออกจากระบบ ?'),
              actions: <Widget>[
                FlatButton(
                  child: Text('ไม่ใช่'),
                  onPressed: () => Navigator.pop(context, false),
                ),
                FlatButton(
                  child: Text('ใช่'),
                  onPressed: () => {
                    _logout().then((res) => {
                          Navigator.pop(context),
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext) => Login()))
                        }),
                  },
                ),
              ],
            ));
  }

  TextEditingController _type = TextEditingController();
  bool _check = true;

  Future<void> onSummit(String str) async {
    http.post('${config.API_url}/type/add', body: {"typeName": str}).then(
        (response) {
      Map jsonData = jsonDecode(response.body) as Map;
      if (jsonData['status'] == 0) {
        return;
      } else {
        return;
      }
    });
  }

  // void initState() {
  //   super.initState();
  //   (_userId == 1) ? permission = true : permission = false;
  //   http.post('${config.API_url}/type/list').then((response) {
  //     print(response.body);
  //     Map jsonData = jsonDecode(response.body) as Map;
  //     List temp = jsonData['data'];
  //     for (int i = 0; i < temp.length; i++) {
  //       Map data = temp[i];

  //       Padding card = Padding(
  //         padding: EdgeInsets.all(8.0),
  //         child: RaisedButton(
  //           color: Colors.white,
  //           onPressed: () {
  //             Navigator.push(
  //                 context,
  //                 MaterialPageRoute(
  //                     builder: (BuildContext context) =>
  //                         listview(_userId, data['id'], data['typeName'])));
  //           },
  //           child: Padding(
  //             padding: EdgeInsets.all(20.0),
  //             child: Center(
  //               child: Text('${data['typeName']}',
  //                   style:
  //                       TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
  //             ),
  //           ),
  //         ),
  //       );
  //       lst.add(card);
  //       setState(() {});
  //     }
  //   });
  // }

  _displayDialog() async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('เพิ่มประเภทหัวข้อ'),
            content: TextField(
              controller: _type,
              decoration: InputDecoration(hintText: "กรอกประเภท"),
            ),
            actions: <Widget>[
              new RaisedButton(
                child: Text(
                  'ตกลง',
                  style: TextStyle(color: Colors.white),
                ),
                // onPressed: onSummit,
              ),
              new RaisedButton(
                child: Text(
                  'ยกเลิก',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }

  Widget getItem(BuildContext context, int index) {
    return lst[index];
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      theme: ThemeData(fontFamily: "Mitr"),
      debugShowCheckedModeBanner: false,
      home: WillPopScope(
        onWillPop: onClose,
        child: Scaffold(
            appBar: AppBar(
              title: Text('หน้าหลัก'),
              actions: <Widget>[
                FlatButton(
                  onPressed: onLogOut,
                  child: Text(
                    'Logout',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                )
              ],
            ),
            body: ListView(
              children: <Widget>[
                Card(
                    margin: EdgeInsets.all(8),
                    color: Color(0xff2980b9),
                    child: Container(
                      padding: EdgeInsets.all(30),
                      child: Column(
                        children: <Widget>[
                          Text(
                            'ยินดีตอนรับ',
                            style: TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'กรุณาเลือกประเภท',
                            style: TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    )),
                GridView.count(
                  padding: EdgeInsets.all(8),
                  crossAxisCount: 2,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(right: 8, bottom: 8),
                      child: RaisedButton(
                          color: Colors.white,
                          onPressed: () {
                            onSummit("อาคารสถานที่").then((_) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          listview(
                                              _userId, 1, "อาคารสถานที่")));
                            });
                          },
                          child: Container(
                            child: Icon(
                              Icons.store,
                              size: 100,
                              color: Colors.indigo,
                            ),
                          )),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: RaisedButton(
                          color: Colors.white,
                          onPressed: () {
                            onSummit("อินเทอร์เน็ต").then((_) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          listview(
                                              _userId, 2, "อินเทอร์เน็ต")));
                            });
                          },
                          child: Container(
                            child: Icon(
                              Icons.signal_wifi_off,
                              size: 100,
                              color: Colors.teal,
                            ),
                          )),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 8, bottom: 8),
                      child: RaisedButton(
                          color: Colors.white,
                          onPressed: () {
                            onSummit("ระบบไฟฟ้า").then((_) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          listview(_userId, 3, "ระบบไฟฟ้า")));
                            });
                          },
                          child: Container(
                            child: Icon(
                              Icons.offline_bolt,
                              size: 100,
                              color: Colors.yellowAccent[400],
                            ),
                          )),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: RaisedButton(
                          color: Colors.white,
                          onPressed: () {
                            onSummit("ระบบน้ำ").then((_) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          listview(_userId, 4, "ระบบน้ำ")));
                            });
                          },
                          child: Container(
                            child: Image.asset("images/water_system.png",color: Colors.lightBlue),
                          )),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 8, bottom: 8),
                      child: RaisedButton(
                          color: Colors.white,
                          onPressed: () {
                            onSummit("ถนน").then((_) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          listview(_userId, 5, "ถนน")));
                            });
                          },
                          child: Container(
                            child: Image.asset("images/road.png"),
                          )),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: RaisedButton(
                          color: Colors.white,
                          onPressed: () {
                            onSummit("อื่น ๆ").then((_) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          listview(_userId, 6, "อื่น ๆ")));
                            });
                          },
                          child: Container(
                              child: Image.asset("images/other.png",color: Colors.grey,))),
                    )
                  ],
                ),
              ],
            )),
      ),
    );
  }
}
