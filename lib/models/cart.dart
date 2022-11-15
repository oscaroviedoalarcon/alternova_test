

import 'package:alternova_test/models/product.dart';

class Cart extends Product {

  int? itemCart=0;
  int? totalPrice=0;

  Cart({
    required super.id, 
    required super.name, 
    required super.unitPrice, 
    required super.stock,
    super.image,
    this.itemCart,
    this.totalPrice
  });

}