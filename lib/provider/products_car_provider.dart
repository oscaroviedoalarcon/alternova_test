import 'package:alternova_test/models/cart.dart';
import 'package:flutter/material.dart';

class ProductCartProvider extends ChangeNotifier {
  
  List<Cart> _cart=[];
  
  int totalPay=0;
  int totalItems=0;

  List<Cart> get cart => _cart;

  addUpdateProduct(Cart cartItem){

    var index = _cart.indexWhere((element) => element.id==cartItem.id);

    if (index < 0){
      _cart.add(cartItem);
    }else{
      _cart[index].itemCart = cart[index].itemCart! + cartItem.itemCart!;
    }

    totalValues();
    
  }

  addItemCart(int id){

    var index = _cart.indexWhere((element) => element.id==id);
    _cart[index].itemCart = cart[index].itemCart! + 1;
  
    totalValues();
    
  }

  reduceItemCart(int id){

    var index = _cart.indexWhere((element) => element.id==id);
    _cart[index].itemCart = cart[index].itemCart! - 1;

    totalValues();
    
  }

  deleteProduct(int id){

    var newCart = _cart.where((element) => element.id!=id);
    _cart = [...newCart];
    
    totalValues();
    
  }

  confirmPay(){
    _cart=[];
    totalPay=0;
    totalItems=0;
    notifyListeners();
  }

  totalValues(){
    totalPay=0;
    totalItems=0;

    for(var c in _cart){
      totalPay += c.unitPrice*c.itemCart!;
      totalItems += c.itemCart!;
    }

    notifyListeners();
  }

}