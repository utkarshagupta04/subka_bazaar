import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:subka_bazaar/screens/cart.dart';
import 'package:subka_bazaar/model/products.dart';
import 'package:path_provider/path_provider.dart'; //add path provider dart plugin on pubspec.yaml file
import 'package:flutter/services.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key, required this.categoryId}) : super(key: key);
  final int categoryId;

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  List<Products> _allProducts = [];
  // Fetch content from the json file

  Future<void> readJson() async {
    var response = await rootBundle.loadString('asset/loadjson/products.json');
    final data = await json.decode(response);
    setState(() {
      _allProducts = (data as List).map((i) => Products.fromJson(i)).toList();
    });
    _runFilter(widget.categoryId);
  }

// receive data from the FirstScreen as a parameter
// This list holds the data for the list view

  List<Products> _filteredProducts = [];
  @override
  initState() {
    // at the beginning, all users are shown
    _filteredProducts = _allProducts;
    super.initState();
  }

// This function is called whenever the text field changes
  void _runFilter(int categoryId) {
    List<Products> results = [];
    if (categoryId.isNaN) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = _allProducts;
    } else {
      results =
          _allProducts.where((product) => product.catId == categoryId).toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      _filteredProducts = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    readJson();
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: FutureBuilder(
                builder: (context, snapshot) {
                  // Decode the JSON
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
                                children: <CustomListItem>[
                                  CustomListItem(
                                    text: _filteredProducts[index].description,
                                    buttonText: _filteredProducts[index]
                                        .price
                                        .toString(),
                                    thumbnail: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                        child: Image.asset(
                                            _filteredProducts[index].filename),
                                      ),
                                    ),
                                    title: _filteredProducts[index].title,
                                    productDetail: _filteredProducts[index],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: _filteredProducts == null
                        ? 0
                        : _filteredProducts.length,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomListItem extends StatelessWidget {
  CustomListItem(
      {Key? key,
      required this.thumbnail,
      required this.title,
      required this.text,
      required this.buttonText,
      required this.productDetail})
      : super(key: key);

  final Widget thumbnail;
  final String title;
  final String text;
  final String buttonText;
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
            flex: 3,
            child: _ProductDescription(
              title: title,
              text: text,
              buttonText: buttonText,
              productDetail: productDetail,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductDescription extends StatelessWidget {
  _ProductDescription(
      {Key? key,
      required this.title,
      required this.text,
      required this.buttonText,
      required this.productDetail})
      : super(key: key);

  final String title;
  final String text;
  final String buttonText;
  Products productDetail;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
          Text(
            text,
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 1.0)),
          ElevatedButton(
            child: Text('Buy now @ MRP Rs.$buttonText'),
            onPressed: () {
              saveProductInCart(productDetail);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartPage(),
                  ));
            },
          ),
        ],
      ),
    );
  }
}

File jsonFile = File("");
String fileName = "CartJSONFile.json";
bool fileExists = false;

Future<void> saveProductInCart(Products content) async {
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
        productList[index].quantity += 1;
      }
      jsonFile.writeAsStringSync(json.encode(productList));
    } else {
      jsonFile.createSync();
      jsonFile.writeAsStringSync(json.encode(content));
    }
  });
}
