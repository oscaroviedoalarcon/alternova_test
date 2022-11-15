

import 'package:alternova_test/models/product.dart';
import 'package:alternova_test/models/product_detail.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/products.dart';

class ProductsProvider extends ChangeNotifier{

  List<Product> _products=[];
  bool isLoading=false;
  Product? productSelected;
  ProductDetail _productDetail=ProductDetail();

  final _baseUrl= '525aa86b-e6ee-4e67-bbdf-f4d543d5701a.mock.pstmn.io';

  ProductsProvider(){
    getProducts();
  }

  List<Product> get products => _products;
  ProductDetail get productDetail => _productDetail;

  set products ( List<Product> s){
    _products = s;
  } 

  getProducts() async {

    isLoading=true;
    notifyListeners();

    final url = Uri.https(_baseUrl,'all-products');
    final response= await http.get(url);

    if (response.statusCode == 200) {

      final productsResponse = ProductResponse.fromJson(response.body);
      _products = productsResponse.products;

    }else{
      print('Request failed with status: ${response.statusCode}.');
    }

    isLoading=false;
    notifyListeners();

  } 

  Future<ProductDetail> getProductDetail(int id) async {

    final url = Uri.https(_baseUrl,'detail/$id');
    final response= await http.get(url);

    if (response.statusCode == 200) {

      final productsDetailResponse = ProductDetail.fromJson(response.body);
      _productDetail = productsDetailResponse;
      return productsDetailResponse;

    }else{
      print('Request failed with status: ${response.statusCode}.');
    }

    return ProductDetail();

  }

  getProductsPay() async {

    final url = Uri.https(_baseUrl,'buy');
    final response= await http.post(url);

    if (response.statusCode == 200) {

      final productsResponse = ProductResponse.fromJson(response.body);
      _products = productsResponse.products;

    }else{
      print('Request failed with status: ${response.statusCode}.');
    }

    notifyListeners();

  } 

  addItemCart(int id, int value){

    var index = _products.indexWhere((element) => element.id==id);
    _products[index].stock = _products[index].stock + value;    
    
    notifyListeners();
  }

  reduceItemCart(int id, int value){

    var index = _products.indexWhere((element) => element.id==id);
    _products[index].stock = _products[index].stock - value;

    notifyListeners();
    
  }

}