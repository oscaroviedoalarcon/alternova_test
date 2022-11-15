
import 'package:alternova_test/models/product.dart';
import 'package:http/http.dart' as http;

class ProductService {

  final String _baseUrl= 'https://525aa86b-e6ee-4e67-bbdf-f4d543d5701a.mock.pstmn.io';
  
  static List<Product> products=[];

  getProducts() async {

    final url = Uri.https(_baseUrl,'all-products');
    final resp= await http.get(url);

  }  

}