import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:subka_bazaar/screens/cart.dart';
import 'package:subka_bazaar/screens/product.dart';
import 'dart:convert';
import 'package:subka_bazaar/model/products.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String fileName = "CartJSONFile.json";
  int cartProductCount = 0;
  @override
  void initState() {
    super.initState();
    readJson();
  }

// Fetch content from the json file
  Future<void> readJson() async {
    getApplicationDocumentsDirectory().then((Directory directory) {
      File jsonFile = File(directory.path + "/" + fileName);
      bool fileExists = jsonFile.existsSync();
      if (fileExists) {
        List<dynamic> jsonFileContent =
            json.decode(jsonFile.readAsStringSync());
        setState(() {
          cartProductCount = jsonFileContent
              .map((data) => Products.fromJson(data))
              .toList()
              .length;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.logout // add custom icons also
              ),
        ),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          ElevatedButton(
              child: Row(
                children: <Widget>[
                  Text('$cartProductCount Item(s)'),
                  const Icon(
                    Icons.shopping_cart,
                  ),
                ],
              ),
              onPressed: () {
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    fullscreenDialog: true,
                    builder: (context) => CartPage(),
                  ),
                );
              }),
        ],
      ),
      body: Center(
        child: FutureBuilder(
          future: DefaultAssetBundle.of(context)
              .loadString('asset/loadjson/categories.json'),
          builder: (context, snapshot) {
            // Decode the JSON
            var newData = json.decode(snapshot.data.toString());

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
                              text: newData[index]['text'],
                              buttonText: newData[index]['title'],
                              thumbnail: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Image.asset(newData[index]['img']),
                                ),
                              ),
                              title: newData[index]['title'],
                              categoryID: newData[index]['catId'],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
              itemCount: newData == null ? 0 : newData.length,
            );
          },
        ),
      ),
    );
  }
}

class CustomListItem extends StatelessWidget {
  const CustomListItem({
    Key? key,
    required this.thumbnail,
    required this.title,
    required this.text,
    required this.buttonText,
    required this.categoryID,
  }) : super(key: key);

  final Widget thumbnail;
  final String title;
  final String text;
  final String buttonText;
  final int categoryID;

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
            child: _CategoryDescription(
              title: title,
              text: text,
              buttonText: buttonText,
              categoryID: categoryID,
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryDescription extends StatelessWidget {
  const _CategoryDescription({
    Key? key,
    required this.title,
    required this.text,
    required this.buttonText,
    required this.categoryID,
  }) : super(key: key);

  final String title;
  final String text;
  final String buttonText;
  final int categoryID;

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
            child: Text('Explore $buttonText'),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductPage(
                      categoryId: categoryID,
                    ),
                  ));
            },
          ),
        ],
      ),
    );
  }
}
