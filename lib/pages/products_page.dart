import 'package:alternova_test/helpers/show_alert.dart';
import 'package:alternova_test/provider/products_provider.dart';
import 'package:alternova_test/widgets/cart_icon.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/firebase_auth.dart';
import '../widgets/product_card.dart';


class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {

    final productProvider = Provider.of<ProductsProvider>(context);
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.logout_outlined),
          onPressed: () { 
            showAlertConfirm(
              context, 
              'Cerrar sesión', 
              '¿ Está seguro de cerrar la sesión ?',
              (){
                final authService = Provider.of<AuthService>(context,listen: false);
                authService.logout();
                Navigator.of(context).pushNamedAndRemoveUntil('login', (Route<dynamic> route) => false);
              }
            );
          }
        ),
        actions: const [
          CartIcon(),
        ],
        title: const Text('Productos'),
      ),
      body: SizedBox(
        height: height * 0.88,
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: productProvider.products.length,
          itemBuilder: (context, i) {
            final product = productProvider.products[i];

            return ProductCard(product: product);
          },
        ),
      )
   );

  }
}