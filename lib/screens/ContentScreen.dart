import 'dart:math';

import 'package:flutter/material.dart';

import '../components/AppBarBuilder.dart';
import '../components/Containers.dart';
import '../utils/Env.dart';
import '../utils/utils.dart';

class ContentScreen extends StatefulWidget {
  final String name = "ContentScreen";
  final String urlPath;
  const ContentScreen({super.key, required this.urlPath});
  @override
  State<ContentScreen> createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {
  List folders = [];
  List files = [];
  bool loading = true;
  Map<String, List>? saved;
  @override
  void initState() {
    fetch(widget.urlPath).then((data) {
      setState(() {
        folders = data["folders"];
        files = data["files"];
        loading = false;
      });
    });
    super.initState();
  }

  filter(value) {
    saved ??= {
      "folders": [...folders],
      "files": [...files]
    };
    setState(() {
      folders = [...?saved?["folders"]];
      files = [...?saved?["files"]];
      folders.removeWhere((folder) => !folder["name"].contains(value));
      files.removeWhere((file) => !file["name"].contains(value));
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBarBuilder(
          filter: filter,
        ),
        body: loading
            ? Center(
                child: SizedBox(
                    width: min(size.width, size.height) * 0.5,
                    height: min(size.width, size.height) * 0.5,
                    child: const CircularProgressIndicator(
                      strokeWidth: 7,
                    )),
              )
            : Container(
                padding: const EdgeInsets.only(top: 40),
                height: double.maxFinite,
                width: double.maxFinite,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: setBackground(),
                    fit: BoxFit.fill,
                  ),
                ),
                child: SingleChildScrollView(
                  child: Wrap(alignment: WrapAlignment.spaceAround, children: [
                    ...folders.map<Widget>(
                      ((folder) {
                        return Center(
                          child: FolderContainer(
                              folderName: folder["name"],
                              urlPath: widget.urlPath,
                              screen: ContentScreen(
                                urlPath: "${widget.urlPath}/${folder["name"]}",
                              )),
                        );
                      }),
                    ).toList(),
                    ...files.map<Widget>(
                      ((file) {
                        return FileContainer(
                          fileName: file["name"],
                          urlPath: widget.urlPath,
                          fileUrl: '${Env.baseUrl}/${file["url"]}',
                          mimeType: file["mimeType"],
                        );
                      }),
                    ).toList(),
                  ]),
                ),
              ));
  }
}
