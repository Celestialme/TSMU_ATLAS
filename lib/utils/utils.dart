import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'Env.dart';

fetch(path) async {
  var response = await get(Uri.parse(Env.apiUrl + path));
  if (response.statusCode == 200) {
    // If server returns an OK response, parse the JSON.
    return json.decode(utf8.decode(response.bodyBytes));
  } else {
    // If that response was not OK, throw an error.
    return false;
  }
}

AssetImage setBackground() {
  switch (Env.subject) {
    case "მედიცინა":
      return const AssetImage("assets/MedicineBackground.png");
    case "ფარმაცია":
      return const AssetImage("assets/PharmacyBackground.png");
    case "სტომატოლოგია":
      return const AssetImage("assets/StomatologyBackground.png");

    default:
      return const AssetImage("assets/MedicineBackground.png");
  }
}

Future<String> loadFromNetwork(url, name) async {
  var filename = name;
  var response = await http.get(Uri.parse(url));
  var bytes = response.bodyBytes;
  var dir = await getExternalStorageDirectory();
  var file = File("${dir!.path}/$filename");
  await file.writeAsBytes(bytes, flush: true);
  return file.path;
}

addFavorite(Map favorite) async {
  var dir = await getApplicationDocumentsDirectory();
  var file = File("${dir.path}/favorites.json");
  if (Env.favorites.any((entry) {
    return entry["path"] == favorite["path"];
  })) return;
  Env.favorites.add(favorite);
  await file.writeAsString(json.encode(Env.favorites), flush: true);
}

deleteFavorite(Map favorite) async {
  var dir = await getApplicationDocumentsDirectory();
  var file = File("${dir.path}/favorites.json");

  Env.favorites.removeWhere((value) => value["path"] == favorite["path"]);
  await file.writeAsString(json.encode(Env.favorites), flush: true);
}

getFavorites() async {
  var dir = await getApplicationDocumentsDirectory();
  var file = File("${dir.path}/favorites.json");
  if (file.existsSync()) {
    Env.favorites = json.decode(await file.readAsString());
  }
  return Env.favorites;
}

getPdfs() async {
  var dir = Platform.isAndroid
      ? await getExternalStorageDirectory()
      : await getApplicationDocumentsDirectory();
  return dir
          ?.listSync()
          .map((e) => {"path": e.path, "name": e.path.split("/").last})
          .toList() ??
      [];
}

deletePDF(String path) async {
  File(path).deleteSync();
}
