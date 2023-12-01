import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get_from/camera_screen.dart';
import 'package:get_from/image_preview.dart';

class SelectOptions extends StatefulWidget {
  const SelectOptions({Key? key, required this.cameras}) : super(key: key);
  final List<CameraDescription> cameras;

  @override
  State<SelectOptions> createState() => _SelectOptionsState();
}

class _SelectOptionsState extends State<SelectOptions> {
  int? _selectedCameraOption;
  TextEditingController _textFieldController = TextEditingController();
  List<String> _timeFormats = ['seconds', 'minutes', 'hours'];
  String? _selectedTimeFormat = 'minutes';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Options')),
      body:
          Column(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        ListTile(
          title: Text('Front Camera', style: TextStyle(fontSize: 18)),
          leading: Radio(
            value: 1,
            groupValue: _selectedCameraOption,
            onChanged: (value) {
              setState(() {
                _selectedCameraOption = value as int;
              });
            },
          ),
        ),
        ListTile(
          title: Text('Back Camera', style: TextStyle(fontSize: 18)),
          leading: Radio(
            value: 0,
            groupValue: _selectedCameraOption,
            onChanged: (value) {
              setState(() {
                _selectedCameraOption = value as int;
              });
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 220,
              child: TextField(
                controller: _textFieldController,
                keyboardType: TextInputType.number,
                onChanged: (text) {
                  setState(() {});
                },
                style: TextStyle(fontSize: 18),
                decoration: InputDecoration(
                    labelText: 'Time in $_selectedTimeFormat',
                    labelStyle: TextStyle(fontSize: 22)),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            DropdownButton(
                value: _selectedTimeFormat,
                items: _timeFormats
                    .map((item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          item,
                          style: TextStyle(fontSize: 20),
                        )))
                    .toList(),
                onChanged: (item) =>
                    setState(() => _selectedTimeFormat = item)),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        TextButton(
          onPressed: _selectedCameraOption != null && _textFieldController.text != "" ? () {
            print('Selected Option: $_selectedCameraOption');
            print('Entered Time: ${_textFieldController.text}');
            print('Selected time format :$_selectedTimeFormat');
            Navigator.of(context).pop(); // Close the dialog
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CameraScreen(
                          cameras: widget.cameras,
                          enteredTime: int.parse(_textFieldController.text),
                          timeFormat: _selectedTimeFormat!,
                          selectedCamera: _selectedCameraOption!,
                        )));
          } : null,
          child: Text('Start', style: TextStyle(fontSize: 18)),
        ),
      ]),
    );
  }
}
