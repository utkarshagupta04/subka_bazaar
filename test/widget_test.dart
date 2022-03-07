// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider/path_provider.dart';
import 'package:subka_bazaar/model/products.dart';

void main() {
  test('Validate category json data', () async {
    String fileName = "categories.json";
    getApplicationDocumentsDirectory().then((Directory directory) {
      File jsonFile = File(directory.path + "/" + fileName);
      bool fileExists = jsonFile.existsSync();
      if (fileExists) {
        //File exists
        List<dynamic> jsonFileContent =
            json.decode(jsonFile.readAsStringSync());
        expect(jsonFileContent[0]['catId'], 1);
        expect(jsonFileContent[0]['title'], 'Fruits & Vegetables');
      }
    });
  });
  test('Validate product json data', () {
    String fileName = "products.json";
    getApplicationDocumentsDirectory().then((Directory directory) {
      File jsonFile = File(directory.path + "/" + fileName);
      bool fileExists = jsonFile.existsSync();
      if (fileExists) {
        //File exists
        List<dynamic> jsonFileContent =
            json.decode(jsonFile.readAsStringSync());
        List<Products> productList =
            jsonFileContent.map((data) => Products.fromJson(data)).toList();
        expect(productList[0].price, 28.1);
        expect(productList[0].title, 'Brown eggs');
      }
    });
  });
}
