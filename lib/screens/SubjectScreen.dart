import 'dart:math';

import 'package:flutter/material.dart';
import '../screens/ContentScreen.dart';
import '../components/AppBarBuilder.dart';
import '../components/Containers.dart';
import '../utils/Env.dart';
import '../utils/utils.dart';

class SubjectScreen extends StatefulWidget {
  final String urlPath;
  final String name = "SubjectScreen";
  const SubjectScreen({super.key, required this.urlPath});
  @override
  State<SubjectScreen> createState() => _SubjectScreenState();
}

class _SubjectScreenState extends State<SubjectScreen> {
  List folders = [];
  List files = [];
  Map<String, List>? saved;
  bool loading = true;
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
                padding: const EdgeInsets.only(top: 50),
                height: double.maxFinite,
                width: double.maxFinite,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: setBackground(),
                    fit: BoxFit.fill,
                  ),
                ),
                child: SingleChildScrollView(
                  child: Wrap(
                    children: folders.map<Widget>(
                      ((folder) {
                        return SubjectContainer(
                            subjectName: folder["name"],
                            urlPath: widget.urlPath,
                            iconUrl: folder["icon"] != null
                                ? '${Env.baseUrl}/${folder["icon"]}'
                                : "",
                            screen: ContentScreen(
                              urlPath: "${widget.urlPath}/${folder["name"]}",
                            ));
                      }),
                    ).toList(),
                  ),
                ),
              ));
  }
}
