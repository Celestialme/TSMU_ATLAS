import 'dart:math';
import 'package:flutter/material.dart';
import 'package:tsmu_atlas/components/AppBarBuilder.dart';
import 'package:tsmu_atlas/screens/YearScreen.dart';

import '../components/Containers.dart';
import '../components/DrawerBuilder.dart';
import '../utils/Env.dart';
import '../utils/utils.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List folders = [];
  List files = [];
  bool loading = true;
  final urlPath = "/";
  @override
  void initState() {
    fetch(urlPath).then((data) {
      setState(() {
        folders = data["folders"];
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
        drawer: const DrawerBuilder(),
        appBar: AppBarBuilder(
          padding: false,
          search: false,
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
            : Column(children: [
                SizedBox(
                  height: size.height * 0.2,
                ),
                ...folders.map<Widget>(
                  ((folder) {
                    return FolderContainer(
                        folderName: folder["name"],
                        leadingIcon: getLeadingIcon(folder["name"]),
                        urlPath: urlPath,
                        callback: () => Env.subject = folder["name"],
                        screen: YearScreen(
                          urlPath: "$urlPath/${folder["name"]}",
                        ));
                  }),
                ).toList()
              ]));
  }
}

getLeadingIcon(folderName) {
  switch (folderName) {
    case "მედიცინა":
      return "assets/leading_icons/medicine.png";
    case "სტომატოლოგია":
      return "assets/leading_icons/stomatology.png";
    case "ფარმაცია":
      return "assets/leading_icons/pharmacy.png";
    case "საზოგადოებრივი ჯანდაცვა":
      return "assets/leading_icons/healthcare.png";
    default:
      return "";
  }
}
