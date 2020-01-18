import 'dart:convert';
import 'dart:io';
import 'package:async/async.dart';
import 'package:blog/AddComment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sweetalert/sweetalert.dart';
import 'config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class listview extends StatefulWidget {
  int _userId, _typeId;
  String _name;

  listview(int userId, int typeId, String name) {
    this._userId = userId;
    this._typeId = typeId;
    this._name = name;
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _listview(_userId, _typeId, _name);
  }
}

class _listview extends State {
  int _userId, _typeId;
  String _name;

  _listview(int userId, int typeId, String name) {
    this._userId = userId;
    this._typeId = typeId;
    this._name = name;

    // if (_typeId == 1) {
    //   appBarName = 'Building';
    // } else if (_typeId == 2) {
    //   appBarName = 'Internet';
    // } else if (_typeId == 3) {
    //   appBarName = 'Water System';
    // } else if (_typeId == 4) {
    //   appBarName = 'Electrical System';
    // } else {
    //   appBarName = 'Street';
    // }
  }

  List lstData = List();
  TextEditingController _nameTopic = TextEditingController();
  TextEditingController _description = TextEditingController();

  void initState() {
    super.initState();
    // http.post('${config.API_url}/type/list').then((response) {
    //   print(response.body);
    //   Map jsonData = jsonDecode(response.body) as Map;
    //   List temp = jsonData['data'];
    //   for (int i = 0; i < temp.length; i++) {
    //     Map data = temp[i];
    //     if (_typeId == data['id']) {

    //     }
    //   }
    // });
    _body();
  }

  void _body() {
    http.post('${config.API_url}/topic/list',
        body: {"typeId": _typeId.toString()}).then((response) {          
      Map ret = jsonDecode(response.body) as Map;
      List jsonData = ret["data"];

      if (jsonData.isNotEmpty) {
        for (int i = 0; i < jsonData.length; i++) {
          List topic = jsonData[i];

          Padding card = Padding(
            padding: EdgeInsets.all(8.0),
            child: Card(
              color: Colors.teal,
              child: FlatButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext) =>
                              Comment(_userId, topic[0])));
                },
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              "${topic[1]}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(
                                  top: 8, left: 8, right: 8, bottom: 8),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                              ),
                              child: Text(
                                '${topic[4]}',
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 10,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Text(
                        "Post : ${topic[2]} , ${topic[3].toString().substring(0, 10)}",
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
          lstData.add(card);
          setState(() {});
        }
      } else {
        Alert(
          context: context,
          type: AlertType.warning,
          title: "ยังไม่มีการสร้างหัวข้อ",
          desc: "กรุณากดปุ่ม + เพื่อสร้างหัวข้อ",
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
        // Container alarm = Container(
        //   child: Center(
        //     child: Padding(
        //       padding: EdgeInsets.only(top: 250),
        //       child: Text('ยังไม่มีการสร้างหัวข้อ',style: TextStyle(fontSize: 20,color: Colors.red),),
        //     ),
        //   ),
        // );
        // lstData.add(alarm);
        // setState(() {});
      }
    });
  }

  File _image;

  Future getImageGallery() async {
    var imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = imageFile;
      Navigator.pop(context);
      _displayDialog();
    });
  }

  Future getImageCamera() async {
    var imageFile = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 1024, maxWidth: 768);
    setState(() {
      _image = imageFile;
      Navigator.pop(context);
      _displayDialog();
    });
  }

  void onSave() {
    Map<String, dynamic> repData = Map();
    repData['userId'] = '${_userId}';
    repData['typeId'] = _typeId.toString();
    repData['name'] = _nameTopic.text;
    repData['description'] = _description.text;
    http.post('${config.API_url}/topic/save', body: repData).then((respone) {
      Map res = jsonDecode(respone.body) as Map;
      int status = res['status'];
      int _topicId = res['data'];
      
      if (status == 0) {
        upload(_image, _topicId);
      }
    });
  }

  Future upload(File imageFile, int topicId) async {
    if (imageFile != null) {
      SweetAlert.show(context,
          subtitle: "กำลังสร้างรายการหอพัก...", style: SweetAlertStyle.loading);
      var stream =
          new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
      var length = await imageFile.length();
      var uri = Uri.parse("${config.API_url}/imageTopic/saveImage");

      var request = new http.MultipartRequest("POST", uri);
      var multipartFile = new http.MultipartFile("file", stream, length,
          filename: path.basename(imageFile.path));
      request.fields['topicId'] = topicId.toString();
      request.files.add(multipartFile);

      var response = await request.send();
      if (response.statusCode == 200) {
        print("Image Uploaded");
        SweetAlert.show(context,
            title: "สำเร็จ!",
            style: SweetAlertStyle.success, onPress: (bool isTrue) {
          if (isTrue) {
            lstData.clear();
            _body();
            _image = null;
            _nameTopic.clear();
            _description.clear();
            Navigator.pop(context);
            Navigator.pop(context);
          }
          return false;
        });
      } else {
        print("Upload Failed");
      }

      response.stream.transform(utf8.decoder).listen((value) {
        print(value);
      });
    } else {
      lstData.clear();
      _body();
      _image = null;
      _nameTopic.clear();
      _description.clear();
      Navigator.pop(context);
    }
  }

  _displayDialog() async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('เพิ่มหัวข้อ'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: TextField(
                      controller: _nameTopic,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.black)),
                        hintText: 'กรอกหัวข้อ',
                      ),
                    ),
                  ),
                  TextField(
                    controller: _description,
                    minLines: 1,
                    maxLines: 3,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.black)),
                      hintText: 'กรอกข้อความ',
                    ),
                  ),
                  new Container(
                    padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                    child: _image == null
                        ? Text('ไม่มีรูปที่เลือก')
                        : Image.file(_image),
                  ),
                  new Container(
                    padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                    child: FloatingActionButton(
                      onPressed: getImageCamera,
                      tooltip: 'เลือกรูปหอพัก',
                      child: Icon(Icons.add_a_photo),
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              new RaisedButton(
                child: Text(
                  'ตกลง',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: onSave,
              ),
              new RaisedButton(
                child: Text(
                  'ยกเลิก',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  _image = null;
                  _nameTopic.clear();
                  _description.clear();
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  Widget getItem(BuildContext context, int index) {
    return lstData[index];
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
          title: Text(
        '${_name}',
        style: TextStyle(fontWeight: FontWeight.bold),
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _displayDialog();
          // Navigator.pop(context);
          // Navigator.of(context).push(MaterialPageRoute(
          //     builder: (BuildContext) => Topic(_userId, _typeId, _name)));
        },
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
        itemBuilder: getItem,
        itemCount: lstData.length,
      ),
    );
  }
}
