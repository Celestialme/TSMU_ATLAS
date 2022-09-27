import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tsmu_atlas/utils/utils.dart';

import '../screens/ContentScreen.dart';
import '../screens/Home.dart';
import '../screens/SubjectScreen.dart';
import '../screens/YearScreen.dart';
import '../utils/Env.dart';

class DrawerBuilder extends StatefulWidget {
  const DrawerBuilder({super.key});

  @override
  State<DrawerBuilder> createState() => _DrawerBuilderState();
}

var expansionItems = [
  {"headerValue": "ფავორიტები", "expandedValue": [], "isExpanded": false},
  {
    "headerValue": "გადმოწერილები",
    "expandedValue": [
      {
        "name": "გადმოწერილი ფოლდერები LIST",
        "path": "მედიცინა",
        "screen": "YearScreen"
      },
      {
        "name": "გადმოწერილი ფოლდერები LIST2",
        "path": "მედიცინა",
        "screen": "YearScreen"
      },
    ],
    "isExpanded": false
  }
];

class _DrawerBuilderState extends State<DrawerBuilder> {
  @override
  void initState() {
    getFavorites().then((data) {
      print(data);
      setState(() {
        expansionItems[0]["expandedValue"] = data;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(children: [
        DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
            ),
            child: SizedBox(
                width: double.maxFinite,
                child: Image.asset("assets/main_logo.png"))),
        ExpansionPanelList(
            expansionCallback: (int index, bool isExpanded) {
              setState(() {
                expansionItems[index]["isExpanded"] = !isExpanded;
              });
            },
            children: [
              ExpansionPanel(
                  canTapOnHeader: true,
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return ListTile(
                        subtitle: (expansionItems[0]["expandedValue"]
                                    as List<dynamic>)
                                .isEmpty
                            ? Text(
                                textAlign: TextAlign.center,
                                "დააჭირეთ დიდხანს ფოლდერზე ფავორიტებში დასამატებლად")
                            : null,
                        title: Center(
                          child: Text(
                              (expansionItems[0]["headerValue"] as String),
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer)),
                        ));
                  },
                  body: Center(
                      child: Container(
                          padding:
                              EdgeInsets.only(bottom: 30, left: 10, right: 10),
                          child: Column(
                              children:
                                  (expansionItems[0]["expandedValue"] as List)
                                      .map((val) {
                            return GestureDetector(
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
                                        return Home();
                                    }
                                  }));
                                },
                                child: Column(
                                  children: [
                                    Text(
                                      val["path"],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimaryContainer,
                                      ),
                                    ),
                                    Divider(
                                      height: 50,
                                    )
                                  ],
                                ));
                          }).toList()))),
                  isExpanded: expansionItems[0]["isExpanded"] as bool)
            ])
      ]),
    );
  }
}
