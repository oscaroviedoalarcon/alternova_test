import 'package:alternova_test/helpers/show_alert.dart';
import 'package:alternova_test/provider/products_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/products_car_provider.dart';
import '../widgets/cart_card.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {

    final cartProvider = Provider.of<ProductCartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Carrito'),
      ),
      body: (cartProvider.cart.isEmpty)
        ? const Center(child: Text('No has seleccionado ningún producto',style: TextStyle(fontSize: 20)))
        :ListView.builder(
          itemCount: cartProvider.cart.length,
          itemBuilder: (context, i) {
            return CartCard(cart: cartProvider.cart[i]);
          },
        ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          height: 80.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Precio total : \$ ${cartProvider.totalPay}', style: const TextStyle(fontSize: 20)),

              if(cartProvider.cart.isNotEmpty && cartProvider.totalPay > 0)
                MaterialButton(
                  height: 40,
                  color: Colors.red[400],
                  child: const Text('Pagar',style: TextStyle(fontSize: 25,color: Colors.white)),
                  onPressed: () async { 
                    showAlertConfirm(context, 'Compra', 'Confirmar compra por valor de \$ ${cartProvider.totalPay}',() async {
                      await Provider.of<ProductsProvider>(context,listen: false).getProductsPay();
                      cartProvider.confirmPay();
                      Navigator.pushNamed(context, 'product');
                    });
                    
                  },
                )
            ],
          ),
        ),
      ),
     );
  }
}