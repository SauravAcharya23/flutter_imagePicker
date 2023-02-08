

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ImagePicker _picker = ImagePicker();
  File? image;
  List<File> multipleImages= [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Picker'),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: ()async{
                requestCameraPermission();
                // XFile? pickedImage = await _picker.pickImage(source: ImageSource.camera);
                // setState(() {
                //   image = File(pickedImage!.path);
                // });
              }, 
              child: const Text('Single Image Picker')
            ),
            ElevatedButton(
              onPressed: ()async{
                List<XFile> picked = await _picker.pickMultiImage();
                setState(() {
                  multipleImages = picked.map((e) => File(e.path)).toList();
                });
              }, 
              child: const Text('Multiple Image Picker')
            ),
            image==null ? const Text('There is no image') : Image.file(image!, height: 200, width: 200,)
            // Expanded(
            //   child: GridView.builder(
            //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            //       crossAxisCount: 2, 
            //       crossAxisSpacing: 10,
            //       mainAxisSpacing: 10
            //     ), 
            //     itemCount: multipleImages.length,
            //     itemBuilder: (context, index) {
            //       return GridTile(
            //         child: Image.file(multipleImages[index])
            //       );
            //     },
            //   )
            // )
          ],
        ),
      )
    );
  }
  
  Future<void> requestCameraPermission() async {
    final status = await Permission.camera.status;
    if(status != PermissionStatus.granted){
      showDialog(
        context: context , 
        builder: (context) => AlertDialog(
          title: const Text('Permission to use camera'),
          content: const Text('This app needs access to camera'),
          actions: <Widget>[
            TextButton(onPressed: (() => Navigator.pop(context)), child: const Text('cancel')),
            TextButton(onPressed: ()async{
              final newStatus = await Permission.camera.request();
              if(newStatus == PermissionStatus.granted){
                XFile? pickedImage = await _picker.pickImage(source: ImageSource.camera);
                setState(() {
                  image = File(pickedImage!.path);
                  Navigator.pop(context);
                });
              }
              else{
                print('Permission not granted');
              }
            }, 
            child: const Text('Allow')
            )
          ],
        ),
      );
    }
    else{
      final newStatus = await Permission.camera.request();
      if(newStatus == PermissionStatus.granted){
        XFile? pickedImage = await _picker.pickImage(source: ImageSource.camera);
        setState(() {
          image = File(pickedImage!.path);
        });
      }
    }
  }
}
