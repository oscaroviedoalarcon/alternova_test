import 'dart:convert';

class ProductDetail {
    ProductDetail({
      this.name,
      this.unitPrice,
      this.stock,
      this.description,
      this.image,
    });

    String? name;
    int? unitPrice;
    int? stock;
    String? description;
    String? image;

    factory ProductDetail.fromJson(String str) => ProductDetail.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory ProductDetail.fromMap(Map<String, dynamic> json) => ProductDetail(
        name: json["name"] ?? '',
        unitPrice: json["unit_price"]  ?? 0,
        stock: json["stock"]  ?? 0,
        description: json["description"] ?? '',
        image: json["image"],
    );

    Map<String, dynamic> toMap() => {
        "name": name ?? '',
        "unit_price": unitPrice  ?? 0,
        "stock": stock  ?? 0,
        "description": description ?? '',
        "image": image,
    };
}
