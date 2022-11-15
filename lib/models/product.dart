import 'dart:convert';

class Product {
  Product({
    required this.id,
    required this.name,
    required this.unitPrice,
    required this.stock,
    this.image,

  });

  int id;
  String name;
  int unitPrice;
  int stock;
  String? image;  

  factory Product.fromJson(String str) => Product.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Product.fromMap(Map<String, dynamic> json) => Product(
      id: json["id"],
      name: json["name"],
      unitPrice: json["unit_price"],
      stock: json["stock"],
      image: json["image"],
  );

  Map<String, dynamic> toMap() => {
      "id": id,
      "name": name,
      "unit_price": unitPrice,
      "stock": stock,
      "image": image,
  };

  Product copyWith({
    int? id,
    String? name,
    int? unitPrice,
    int? stock,
    String? image,
  }) => Product(
    id: id ?? this.id, 
    name: name ?? this.name,
    image: image ?? this.image, 
    stock: stock ?? this.stock,
    unitPrice: unitPrice ?? this.unitPrice,
  );
}
