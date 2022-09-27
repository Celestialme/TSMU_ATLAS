import 'dart:math';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:tsmu_atlas/utils/utils.dart';

import '../screens/ContentScreen.dart';
import '../screens/Home.dart';
import '../screens/SubjectScreen.dart';
import '../utils/Env.dart';

class DrawerBuilder extends StatefulWidget {
  const DrawerBuilder({super.key});

  @override
  State<DrawerBuilder> createState() => _DrawerBuilderState();
}

var expansionItems = [
  [],
  [],
];

class _DrawerBuilderState extends State<DrawerBuilder> {
  @override
  void initState() {
    getPdfs().then((data) {
      setState(() {
        expansionItems[1] = data;
      });
    });
    getFavorites().then((data) {
      setState(() {
        expansionItems[0] = data;
      });
    });

    super.initState();
  }

  var expandedKey1 = 0;
  var expandedKey2 = 1;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Drawer(
      child: Column(children: [
        DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
            ),
            child: SizedBox(
                width: double.maxFinite,
                child: Image.asset("assets/main_logo.png"))),
        Expanded(
          child: LayoutBuilder(builder: (context, constraints) {
            return Column(children: [
              ExpansionTile(
                key: Key(expandedKey1.toString()),
                onExpansionChanged: (val) {
                  setState(() {
                    expandedKey2 = Random().nextInt(1000);
                  });
                },
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                iconColor: Colors.black,
                collapsedIconColor: Colors.black,
                collapsedBackgroundColor:
                    Theme.of(context).colorScheme.primaryContainer,
                title: ListTile(
                    title: Center(
                  child: Text("ფავორიტები",
                      style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onPrimaryContainer)),
                )),
                children: [
                  if (expansionItems[0].isEmpty)
                    const Text(
                        style: TextStyle(color: Colors.black),
                        textAlign: TextAlign.center,
                        "დააჭირეთ დიდხანს სასურველ ფოლდერზე ფავორიტებში დასამატებლად"),
                  ConstrainedBox(
                    constraints:
                        BoxConstraints(maxHeight: constraints.maxHeight - 170),
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: expansionItems[0].length,
                        itemBuilder: ((context, index) {
                          var val = expansionItems[0][index] as Map;
                          return Column(
                            children: [
                              const Divider(),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                                child: GestureDetector(
                                    onTap: () {
                                      Env.subject = val["path"].split("/")[0];
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        switch (val["screen"]) {
                                          case "ContentScreen":
                                            return ContentScreen(
                                                urlPath: val["path"]);
                                          case "SubjectScreen":
                                            return SubjectScreen(
                                                urlPath: val["path"]);
                                          default:
                                            return const Home();
                                        }
                                      }));
                                    },
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            val["path"],
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimaryContainer,
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            await deleteFavorite(val);
                                            setState(() {});
                                          },
                                          child: const Padding(
                                            padding: EdgeInsets.only(right: 5),
                                            child: Icon(
                                              Icons.delete_forever_rounded,
                                              color: Colors.black,
                                              size: 35,
                                            ),
                                          ),
                                        )
                                      ],
                                    )),
                              ),
                            ],
                          );
                        })),
                  ),
                ],
              ),
              //======================================================= PDFs==============================
              ExpansionTile(
                key: Key(expandedKey2.toString()),
                onExpansionChanged: (val) {
                  setState(() {
                    expandedKey1 = Random().nextInt(1000);
                  });
                },
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                iconColor: Colors.black,
                collapsedIconColor: Colors.black,
                collapsedBackgroundColor:
                    Theme.of(context).colorScheme.primaryContainer,
                title: ListTile(
                    title: Center(
                  child: Text("PDF ფაილები",
                      style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onPrimaryContainer)),
                )),
                children: [
                  if (expansionItems[1].isEmpty)
                    const Text(
                        style: TextStyle(color: Colors.black),
                        textAlign: TextAlign.center,
                        "აქ გამოჩნდება აქამდე გახსნილი PDF ფაილები"),
                  ConstrainedBox(
                    constraints:
                        BoxConstraints(maxHeight: constraints.maxHeight - 170),
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: expansionItems[1].length,
                        itemBuilder: ((context, index) {
                          var val = expansionItems[1][index] as Map;
                          return Column(
                            children: [
                              const Divider(),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                                child: GestureDetector(
                                    onTap: () {
                                      OpenFile.open(val["path"]);
                                    },
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            val["name"],
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimaryContainer,
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            await deletePDF(val["path"]);
                                            getPdfs().then((data) {
                                              setState(() {
                                                expansionItems[1] = data;
                                              });
                                            });
                                          },
                                          child: const Padding(
                                            padding: EdgeInsets.only(right: 5),
                                            child: Icon(
                                              Icons.delete_forever_rounded,
                                              color: Colors.black,
                                              size: 35,
                                            ),
                                          ),
                                        )
                                      ],
                                    )),
                              ),
                            ],
                          );
                        })),
                  ),
                ],
              )
            ]);
          }),
        ),
      ]),
    );
  }
}
