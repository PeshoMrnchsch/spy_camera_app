import 'dart:io';
import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen(
      {Key? key,
      required this.cameras,
      required this.enteredTime,
      required this.timeFormat,
      required this.selectedCamera})
      : super(key: key);

  final List<CameraDescription> cameras;
  final int enteredTime;
  final String timeFormat;
  final int selectedCamera;

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _cameraController;
  List<XFile> _photos = List.empty(growable: true);
  Timer? myTimer;
  bool _isShooting = false;
  int? _selectedOption;
  TextEditingController _textFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cameraController = CameraController(
        widget.cameras[widget.selectedCamera], ResolutionPreset.high);
    _cameraController.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  Future<void> _takePhoto() async {
    if (!_cameraController.value.isInitialized) {
      return null;
    }
    if (_cameraController.value.isTakingPicture) {
      return null;
    }

    try {
      XFile picture = await _cameraController.takePicture();
      _photos.add(picture);
      setState(() {});
      //Navigator.push(context, MaterialPageRoute(builder: (context)=>ImagePreview(picture)));
      // print('Photo saved to: ${file.path}');
    } catch (e) {
      print('Error taking picture: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_cameraController.value.isInitialized) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    // if (_photos.isEmpty) {
    //   return Scaffold(
    //     body: Center(
    //         child: Text('Waiting For photos', style: TextStyle(fontSize: 30))),
    //     floatingActionButton: FloatingActionButton(
    //       onPressed:(){
    //         if (_isShooting == false) {
    //           _isShooting = true;
    //          myTimer = Timer.periodic(Duration(seconds: 2), (timer) async{
    //            if(!_isShooting) {
    //              timer.cancel();
    //              return;
    //            }
    //            await _takePhoto();
    //           }) ;
    //
    //         } else{
    //           _isShooting = false;
    //           setState(() {});
    //         }
    //       },
    //       child: Icon(Icons.camera),
    //       backgroundColor: _isShooting?Colors.red:Colors.green,
    //     ),
    //   );
    // }
    return Scaffold(
        appBar: AppBar(title: Text("Camera Screen")),
        body: ListView.builder(
          itemCount: (_photos.length / 2).ceil(),
          itemBuilder: (context, index) {
            final startIndex = index * 2;
            final endIndex = startIndex + 2;
            final endAdjusted =
                endIndex > _photos.length ? _photos.length : endIndex;
            final pairPhotos = _photos.sublist(startIndex, endAdjusted);
            return Row(
              children: pairPhotos
                  .map((photo) => Expanded(
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2,
                          height: 130,
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                image: FileImage(File(photo.path)),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            // Align the icon to the bottom
                            children: [
                              IconButton(
                                  onPressed: () async {
                                    // await _saveLocalImage(photo.path);
                                  },
                                  icon: Icon(
                                    Icons.get_app,
                                    color: Colors.grey,
                                    size: 35,
                                  ))
                            ],
                          ),
                        ),
                      ))
                  .toList(),
            );
          },
          // child: Image.file(File(widget.file.path)),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (!_isShooting) {
              _isShooting = true;
              setState(() {});
              // if (widget.timeFormat == 'seconds') {
              //   myTimer = Timer.periodic(Duration(seconds: widget.enteredTime),
              // } else if (widget.timeFormat == 'minutes') {
              //     myTimer = Timer.periodic(Duration(seconds: widget.enteredTime)
              // } else if (widget.timeFormat == 'hours') {
              //   myTimer = Timer.periodic(Duration(seconds: widget.enteredTime),
              // }
              myTimer = Timer.periodic(
                  widget.timeFormat == 'seconds'
                      ? Duration(seconds: widget.enteredTime)
                      : widget.timeFormat == 'minutes'
                          ? Duration(minutes: widget.enteredTime)
                          : Duration(hours: widget.enteredTime), (timer) async {
                if (!_isShooting) {
                  timer.cancel();
                  return;
                }

                await _takePhoto();
              });
            } else {
              _isShooting = false;
              setState(() {});
            }
          },
          child: Icon(Icons.camera),
          backgroundColor: _isShooting ? Colors.red : Colors.green,
        ));
    //     _isShooting = true;
    //     setState(() {});
    //     myTimer = Timer.periodic(Duration(seconds: 2), (timer) async {
    //       if (!_isShooting) {
    //         timer.cancel();
    //         return;
    //       }
    //
    //       await _takePhoto();
    //     });
    //   } else {
    //     _isShooting = false;
    //     setState(() {});
    //   }
    // },
    // child: Icon(Icons.camera),
    // backgroundColor: _isShooting ? Colors.red : Colors.green,
  }
}
// floatingActionButton: FloatingActionButton(
//   onPressed: _takePhoto,
//   child: Icon(Icons.camera),
// ),
//  myTimer = Timer.periodic(widget.timeFormat == 'seconds'? Duration(seconds: widget.enteredTime): widget.timeFormat== 'minutes' ? Duration(minutes: widget.enteredTime) : Duration(hours: widget.enteredTime),(timer) async {
