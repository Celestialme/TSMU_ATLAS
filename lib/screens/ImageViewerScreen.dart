import 'package:flutter/material.dart';

class ImageViewerScreen extends StatelessWidget {
  final String fileUrl;
  final String fileName;
  const ImageViewerScreen(
      {super.key, required this.fileUrl, required this.fileName});

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      panEnabled: false,
      minScale: 1,
      maxScale: 5,
      child: SafeArea(
        child: Hero(
          tag: fileName,
          child: Container(
            color: Colors.black,
            child: Image.network(
              fileUrl,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
