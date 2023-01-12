import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyApp> {
  File? imageFile;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(
              title: Text("Image Upload Tester"),
              backgroundColor: Colors.indigoAccent.shade400,
            ),
            body: Container(
                child: imageFile == null
                    ? Container(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () {
                          _getImage(ImageSource.gallery);
                        },
                        child: Text("UPLOAD"),
                      ),
                    ],
                  ),
                ): Container(
                  child: Image.file(
                    imageFile!,
                    fit: BoxFit.cover,
                  ),
                ))
        ));
  }

  Future<void> _getImage(ImageSource source) async {
    final status = await Permission.storage.status;
    if (status == PermissionStatus.denied) {
      final result = await Permission.storage.request();
      if (result == PermissionStatus.granted) {
        _pickImage(source);
      } else {
        print("Permission denied!");
      }
    } else if (status == PermissionStatus.granted) {
      _pickImage(source);
    } else {
      print("Permission denied!");
    }
  }

  _pickImage(ImageSource source) async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: source,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }
}
