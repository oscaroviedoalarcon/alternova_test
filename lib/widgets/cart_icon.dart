import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/products_car_provider.dart';

class CartIcon extends StatelessWidget {
  const CartIcon({super.key});

  @override
  Widget build(BuildContext context) {

    final totalItems = Provider.of<ProductCartProvider>(context).totalItems;
    
    return Stack(
      children: [
        IconButton(
          icon: const Icon(Icons.shopping_cart_outlined),
          onPressed: () => Navigator.pushNamed(context, 'cart')
        ),
        if(totalItems>0)
          CircleAvatar(
            maxRadius: 11,
            backgroundColor: Colors.red,
            child: Text(
              (totalItems>9)
              ? '9+'
              : '$totalItems',
              style: const TextStyle(color: Colors.white)
            ),
          )
      ],
    );
  }
}