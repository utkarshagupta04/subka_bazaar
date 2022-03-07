class Products {
  late String title;
  late String type;
  late String description;
  late String filename;
  late int catId;
  late double price;
  late int quantity;

  Products(this.title, this.type, this.description, this.catId, this.filename,
      this.price, this.quantity);

  Map toJson() => {
        'title': title,
        'type': type,
        'description': description,
        'catId': catId,
        'filename': filename,
        'price': price,
        'quantity': quantity,
      };
  factory Products.fromJson(dynamic json) {
    return Products(
        json['title'] as String,
        json['type'] as String,
        json['description'] as String,
        json['catId'] as int,
        json['filename'] as String,
        json['price'] as double,
        json['quantity'] as int);
  }
}
