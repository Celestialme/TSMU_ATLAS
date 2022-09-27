import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:tsmu_atlas/components/AppBarBuilder.dart';

import '../screens/ContentScreen.dart';
import '../screens/ImageViewerScreen.dart';
import '../screens/VideoPlayerScreen.dart';
import '../utils/Env.dart';
import '../utils/utils.dart';

class FileContainer extends StatefulWidget {
  final String fileName;
  final String urlPath;
  final String fileUrl;
  final String mimeType;
  const FileContainer({
    super.key,
    required this.fileName,
    required this.urlPath,
    required this.fileUrl,
    required this.mimeType,
  });

  @override
  State<FileContainer> createState() => _FileContainerState();
}

class _FileContainerState extends State<FileContainer> {
  var pdfLoading = false;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        if (widget.mimeType.startsWith('application/pdf') == true) {
          setState(() {
            pdfLoading = true;
          });
          loadFromNetwork(widget.fileUrl, widget.fileName).then((value) =>
              setState(() => {pdfLoading = false, OpenFile.open(value)}));
          return;
        }
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => widget.mimeType.startsWith('image')
                    ? ImageViewerScreen(
                        fileUrl: widget.fileUrl,
                        fileName: widget.fileName,
                      )
                    : widget.mimeType.startsWith('video')
                        ? VideoPlayerScreen(videoUrl: widget.fileUrl)
                        : Scaffold(
                            appBar: AppBarBuilder(search: false),
                            body: const Center(
                                child: Text("FileType not supported!",
                                    style: TextStyle(fontSize: 30))),
                          )));
      },
      child: widget.mimeType.startsWith('image')
          ? imageFile(context, size)
          : otherFile(size, loading: pdfLoading),
    );
  }

  Hero imageFile(BuildContext context, Size size) {
    return Hero(
      tag: widget.fileName,
      child: Container(
        width: size.width * 0.5 - 12,
        height: size.width * 0.5,
        constraints: const BoxConstraints(maxWidth: 280, maxHeight: 250),
        decoration: BoxDecoration(
            color: const Color.fromRGBO(114, 111, 251, 1),
            borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.all(2),
        child: FittedBox(
          fit: BoxFit.fill,
          child: Column(
            children: [
              Text(
                widget.fileName,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              ClipRRect(
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                  child: Image.network(
                    widget.fileUrl,
                    fit: BoxFit.fill,
                    width: size.width * 0.5 - 12,
                    height: size.width * 0.5,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  otherFile(Size size, {loading = false}) {
    print(loading);
    return Container(
      constraints: const BoxConstraints(maxWidth: 280, maxHeight: 250),
      width: size.width * 0.5 - 12,
      height: size.width * 0.5,
      margin: const EdgeInsets.all(4),
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          Image.asset(
            widget.mimeType == "application/pdf"
                ? "assets/PdfIcon.png"
                : widget.mimeType.startsWith("video")
                    ? "assets/VideoIcon.png"
                    : "assets/UnknownIcon.png",
            fit: BoxFit.fill,
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  padding: const EdgeInsets.all(10),
                  width: double.maxFinite,
                  color: const Color.fromRGBO(0, 0, 0, 0.9),
                  child: Text(widget.fileName,
                      textAlign: TextAlign.center,
                      style:
                          const TextStyle(color: Colors.white, fontSize: 18)))),
          if (loading)
            Align(
              child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                return Container(
                    width: constraints.maxWidth - 80,
                    height: constraints.maxWidth - 80,
                    child: CircularProgressIndicator(
                      strokeWidth: 10,
                      color: Color.fromRGBO(107, 237, 255, 1),
                    ));
              }),
            )
        ],
      ),
    );
  }
}

class FolderContainer extends StatelessWidget {
  final String folderName;
  final String urlPath;
  final Widget screen;
  final String leadingIcon;
  Function? callback;
  FolderContainer(
      {super.key,
      required this.folderName,
      required this.urlPath,
      required this.screen,
      this.leadingIcon = "",
      this.callback});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        if (callback != null) {
          callback!();
        }

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => screen));
      },
      child: Tooltip(
        onTriggered: () async {
          if (callback != null) return;
          var favorite = {
            "path": "$urlPath/$folderName".replaceAll("//", ""),
            "screen": (screen as dynamic).name,
            "name": folderName
          };
          await addFavorite(favorite);
          print(await getFavorites());
        },
        textStyle:
            TextStyle(fontSize: 40, color: Theme.of(context).primaryColor),
        message: callback == null ? "დამატებულია" : "",
        child: Container(
          width: folderName.contains("სემესტრი") ? size.width * 0.5 - 8 : null,
          margin: const EdgeInsets.all(4),
          padding: const EdgeInsets.symmetric(vertical: 20),
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Row(
            children: [
              if (leadingIcon.isNotEmpty)
                Image.asset(
                  leadingIcon,
                  width: 50,
                ),
              Expanded(
                child: Center(
                  child: Text(folderName,
                      style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context)
                              .colorScheme
                              .onPrimaryContainer)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SubjectContainer extends StatelessWidget {
  final String subjectName;
  final String urlPath;
  final String iconUrl;
  final Widget screen;
  const SubjectContainer(
      {super.key,
      required this.subjectName,
      required this.urlPath,
      required this.screen,
      required this.iconUrl});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => {
        Navigator.push(context, MaterialPageRoute(builder: (context) => screen))
      },
      child: Tooltip(
        onTriggered: () async {
          var favorite = {
            "path": "$urlPath/$subjectName".replaceAll("//", ""),
            "screen": (screen as dynamic).name,
            "name": subjectName
          };
          await addFavorite(favorite);
          print(await getFavorites());
        },
        textStyle:
            TextStyle(fontSize: 40, color: Theme.of(context).primaryColor),
        message: "დამატებულია",
        child: Container(
          constraints: const BoxConstraints(maxWidth: 280),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: Colors.white),
          width: size.width * 0.5 - 8,
          margin: const EdgeInsets.all(4),
          padding: const EdgeInsets.all(2),
          child: Stack(
            fit: StackFit.passthrough,
            alignment: Alignment.center,
            children: [
              if (iconUrl.isNotEmpty)
                Container(
                  height: size.width * 0.35,
                  constraints: const BoxConstraints(maxHeight: 220),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        fit: BoxFit.fill,
                        iconUrl,
                      )),
                ),
              Container(
                padding: const EdgeInsets.all(5),
                color: const Color.fromRGBO(0, 0, 0, 0.73),
                child: Center(
                  child: Text(
                    subjectName,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
