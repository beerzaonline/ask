import 'dart:convert';
import 'dart:io';
import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sweetalert/sweetalert.dart';
import 'config.dart';

class Comment extends StatefulWidget {
  int _userId, _topicId;

  Comment(int userId, int topicId) {
    this._userId = userId;
    this._topicId = topicId;
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _Comment(_userId, _topicId);
  }
}

class _Comment extends State {
  int _userId, _topicId;
  List lstData = List();

  _Comment(int userId, int topicId) {
    this._userId = userId;
    this._topicId = topicId;
  }

  final TextEditingController _multiLineTextFieldcontroller =
      TextEditingController();
  final TextEditingController _comment = TextEditingController();
  File _image;

  void initState() {
    super.initState();
    _topic();
  }

  void _topic() async {
    http.post('${config.API_url}/topic/findTopic', body: {
      "topicId": _topicId.toString(),
      "userId": _userId.toString()
    }).then((respone) {
      print(respone.body);
      Map res = jsonDecode(respone.body) as Map;
      List temp = res["data"];

      if (res["status"] == 0) {
        List data = temp[0];
        String _imageName = "";

        http.post('${config.API_url}/imageTopic/getNameImages', body: {
          "topicId": _topicId.toString(),
        }).then((respone) {
          Map jsonData = jsonDecode(respone.body) as Map;

          if (jsonData['status'] == 0) {
            Map imageName = jsonData['data'];
            _imageName = imageName['imageName'];
          } else {
            _imageName = "";
          }

          Padding topic = Padding(
            padding: EdgeInsets.all(8.0),
            child: Container(
              padding: EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 8),
              decoration: BoxDecoration(
                color: Colors.lightGreen,
                border: Border.all(color: Colors.black54),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text('${data[0]}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18)),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Container(
                      padding: const EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              '${data[1]}',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  _imageName == "" || _imageName == null
                      ? Padding(
                          padding: EdgeInsets.all(0.0),
                        )
                      : Container(
                          child: Image.network(
                            '${config.API_url}/imageTopic/image?nameImage=' +
                                _imageName,
                            scale: 1,
                          ),
                        ),
                ],
              ),
            ),
          );
          setState(() {
            lstData.add(topic);
          });
          _showComment();
        });
      }
    });
  }

  void _showComment() {
    ///////////////////////////////////////////////////////////////POST/////////////////////////////////////////////
    http.post('${config.API_url}/comment/findAllComment',
        body: {"topicId": _topicId.toString()}).then((response) {
          print(response.body);
      Map res = jsonDecode(response.body);

      if (res["status"] == 0) {
        List temp = res["data"];

        for (int i = 0; i < temp.length; i++) {
          List data = temp[i];
          String _nameImage = "";

          http.post('${config.API_url}/imageComment/getNameImages',
              body: {"commentId": data[0].toString()}).then((response) {
            Map jsonData = jsonDecode(response.body) as Map;

            if (jsonData['status'] == 0) {
              Map imageName = jsonData['data'];
              _nameImage = imageName['imageName'];
            } else {
              _nameImage = "";
            }

            Padding _card = Padding(
              padding: EdgeInsets.all(8.0),
              child: Container(
                padding: EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black54),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Text('ความเห็น : ${data[2]}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18)),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8, left: 8, right: 8),
                      child: Container(
                        padding: const EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          border: Border.all(color: Colors.black54),
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                '${data[1]}',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    _nameImage == "" || _nameImage == null
                        ? Padding(
                            padding: EdgeInsets.all(0.0),
                          )
                        : Container(
                            child: RaisedButton(
                            color: Colors.blue,
                            onPressed: () {
                              Alert(
                                context: context,
                                title: " ",
                                buttons: [
                                  DialogButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text("ตกลง",
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                ],
                                content: Image.network(
                                  '${config.API_url}/imageComment/image?nameImage=' +
                                      _nameImage,
                                  scale: 1,
                                ),
                              ).show();
                            },
                            child: Icon(
                              Icons.image,
                              color: Colors.white,
                            ),
                          )),
                  ],
                ),
              ),
            );
            setState(() {
              lstData.add(_card);
            });
          });
        }
      }
    });
  }

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

  void onSummit() {
    http.post('${config.API_url}/comment/save', body: {
      "userId": _userId.toString(),
      "topicId": _topicId.toString(),
      "message": _comment.text
    }).then((respone) {
      Map ret = jsonDecode(respone.body) as Map;
      int _commentId = ret['data'];
      if (ret['status'] == 0) {
        upload(_image, _commentId);
      }
    });
  }

  Future upload(File imageFile, int commentId) async {
    if (imageFile != null) {
      SweetAlert.show(context,
          subtitle: "กำลังสร้างรายการหอพัก...", style: SweetAlertStyle.loading);
      var stream =
          new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
      var length = await imageFile.length();
      var uri = Uri.parse("${config.API_url}/imageComment/saveImage");

      var request = new http.MultipartRequest("POST", uri);
      var multipartFile = new http.MultipartFile("file", stream, length,
          filename: path.basename(imageFile.path));
      request.fields['commentId'] = commentId.toString();
      request.files.add(multipartFile);

      var response = await request.send();
      if (response.statusCode == 200) {
        print("Image Uploaded");
        SweetAlert.show(context,
            title: "สำเร็จ!",
            style: SweetAlertStyle.success, onPress: (bool isTrue) {
          if (isTrue) {
            _image = null;
            _comment.clear();
            lstData.removeRange(1, lstData.length);
            _showComment();            
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
      _image = null;
      _comment.clear();
      lstData.removeRange(1, lstData.length);
      _showComment();      
      Navigator.pop(context);
    }
  }

  _displayDialog() async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('เพิ่มความเห็น'),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _comment,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        labelText: "ข้อความ",
                        hintText: "กรอกข้อความ"),
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
                color: Colors.blueAccent,
                onPressed: onSummit,
                child: Text(
                  'ตกลง',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              new RaisedButton(
                color: Colors.redAccent,
                child: Text(
                  'ยกเลิก',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  _image = null;
                  _comment.clear();
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
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("แสดงความคิดเห็น"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _displayDialog();
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
