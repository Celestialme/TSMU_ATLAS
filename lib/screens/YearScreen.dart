import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tsmu_atlas/screens/SubjectScreen.dart';

import '../components/AppBarBuilder.dart';
import '../components/Containers.dart';
import '../utils/utils.dart';

class YearScreen extends StatefulWidget {
  final String urlPath;
  const YearScreen({super.key, required this.urlPath});
  @override
  State<YearScreen> createState() => _YearScreenState();
}

class _YearScreenState extends State<YearScreen> {
  List folders = [];
  List files = [];
  bool loading = true;
  @override
  void initState() {
    fetch(widget.urlPath).then((data) {
      setState(() {
        folders = data["folders"];
        folders.sort((a, b) {
          var _a = (a["name"] as String).trim().startsWith("ს");
          var _b = (b["name"] as String).trim().startsWith("ს");
          if (_a && _b) {
            return (a["name"] as String).compareTo(b["name"] as String);
          } else if (_a || _b) {
            return 1;
          } else {
            return 0;
          }
        });
        files = data["files"];
        loading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBarBuilder(search: false),
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
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: setBackground(),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Center(
                  heightFactor: 1,
                  child: Column(
                    children: [
                      SizedBox(height: size.height * 0.2),
                      Wrap(
                        children: folders.map<Widget>(
                          ((folder) {
                            return FolderContainer(
                                folderName: folder["name"],
                                urlPath: widget.urlPath,
                                screen: SubjectScreen(
                                  urlPath:
                                      "${widget.urlPath}/${folder["name"]}",
                                ));
                          }),
                        ).toList(),
                      ),
                    ],
                  ),
                ),
              ));
  }
}
