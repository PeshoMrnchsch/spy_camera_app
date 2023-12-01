import 'dart:io';
import 'dart:typed_data';
import 'dart:async';


import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class ImagePreview extends StatefulWidget {
  const ImagePreview(this.photos, {super.key});

  final List<XFile> photos;

  @override
  State<ImagePreview> createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {

  Future<void> _saveLocalImage(String path) async {
    final result = await ImageGallerySaver.saveFile(path);
    if (result['isSuccess']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Image saved to the gallery.'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving the image to the gallery.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Image Preview")),
      body: ListView.builder(
        itemCount: (widget.photos.length / 2).ceil(),
        itemBuilder: (context, index) {
          final startIndex = index * 2;
          final endIndex = startIndex + 2;
          final endAdjusted = endIndex > widget.photos.length
              ? widget.photos.length
              : endIndex;
          final pairPhotos = widget.photos.sublist(startIndex, endAdjusted);
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
                        onPressed: () async{
                          await _saveLocalImage(photo.path);
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
    );
  }
}
