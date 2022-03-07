import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:subka_bazaar/model/products.dart';
import 'package:subka_bazaar/helper/numeric_step_button.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart'; //add path provider dart plugin on pubspec.yaml file

class CartPage extends StatelessWidget {
  static final ValueNotifier<List<Products>> _productsInCart =
      ValueNotifier<List<Products>>([]);
  String fileName = "CartJSONFile.json";

  // Fetch content from the json file
  Future<void> readJson() async {
    getApplicationDocumentsDirectory().then((Directory directory) {
      File jsonFile = File(directory.path + "/" + fileName);
      bool fileExists = jsonFile.existsSync();
      if (fileExists) {
        List<dynamic> jsonFileContent =
            json.decode(jsonFile.readAsStringSync());
        _productsInCart.value =
            jsonFileContent.map((data) => Products.fromJson(data)).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    readJson();
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
      ),
      body: Center(
        child: ValueListenableBuilder(
          valueListenable: _productsInCart,
          builder: (context, snapshot, _pro) {
            if (_productsInCart.value.isEmpty) {
              return const Text(
                'No items in your cart',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              );
            }
            return ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <CartListItem>[
                            CartListItem(
                              thumbnail: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Image.asset(
                                      _productsInCart.value[index].filename),
                                ),
                              ),
                              title: _productsInCart.value[index].title,
                              categoryID: _productsInCart.value[index].catId,
                              price: _productsInCart.value[index].price,
                              quantity: _productsInCart.value[index].quantity,
                              productDetail: _productsInCart.value[index],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
              itemCount:
                  _productsInCart == null ? 0 : _productsInCart.value.length,
            );
          },
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(28.0),
        child: ElevatedButton(
          child: const Text('Proceed to checkout'),
          onPressed: () {},
        ),
      ),
    );
  }
}

class CartListItem extends StatelessWidget {
  CartListItem({
    Key? key,
    required this.thumbnail,
    required this.title,
    required this.price,
    required this.quantity,
    required this.categoryID,
    required this.productDetail,
  }) : super(key: key);

  final Widget thumbnail;
  final String title;
  final double price;
  final int quantity;
  final int categoryID;
  Products productDetail;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: thumbnail,
          ),
          Expanded(
            flex: 4,
            child: _CartDescription(
              title: title,
              price: price,
              quantity: quantity,
              categoryID: categoryID,
              productDetail: productDetail,
            ),
          ),
        ],
      ),
    );
  }
}

class _CartDescription extends StatelessWidget {
  _CartDescription({
    Key? key,
    required this.title,
    required this.price,
    required this.quantity,
    required this.categoryID,
    required this.productDetail,
  }) : super(key: key);

  final String title;
  final double price;
  int quantity = 0;
  final int categoryID;
  Products productDetail;

  @override
  Widget build(BuildContext context) {
    var totalPrice = (price * quantity).toStringAsFixed(1);
    return Padding(
      padding: const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                NumericStepButton(
                  maxValue: 20,
                  counter: quantity,
                  onChanged: (value) {
                    quantity = value;
                    updateProductInCart(productDetail, quantity);
                  },
                ),
                Text(
                  'X Rs.$price',
                ),
                const SizedBox(width: 30),
                Text(
                  'Rs.$totalPrice',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(width: 5),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

File jsonFile = File("");
String fileName = "CartJSONFile.json";
bool fileExists = false;

Future<void> updateProductInCart(Products content, int quantity) async {
  getApplicationDocumentsDirectory().then((Directory directory) {
    jsonFile = File(directory.path + "/" + fileName);
    fileExists = jsonFile.existsSync();
    if (fileExists) {
      //File exists
      List<dynamic> jsonFileContent = json.decode(jsonFile.readAsStringSync());
      List<Products> productList =
          jsonFileContent.map((data) => Products.fromJson(data)).toList();
      int index =
          productList.indexWhere((element) => element.title == content.title);

      if (index < 0) {
        //value not exists
        productList.add(content);
      } else {
        //value exists
        if (quantity == 0) {
          productList.removeAt(index);
        } else {
          productList[index].quantity = quantity;
        }
      }
      jsonFile.writeAsStringSync(json.encode(productList));
      CartPage._productsInCart.value = productList;
    } else {
      jsonFile.createSync();
      jsonFile.writeAsStringSync(json.encode(content));
    }
  });
}
