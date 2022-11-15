import 'package:alternova_test/models/cart.dart';
import 'package:alternova_test/provider/products_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/products_car_provider.dart';

class CartCard extends StatelessWidget {

  final Cart cart;

  const CartCard({
    Key? key, 
    required this.cart
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        width: double.infinity,
        height: 120,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(25)),
        child: Stack(
          children: [

            _BackgroundImage(url:cart.image),

            _ProductDetails(cart:cart),

            Positioned(
              top: 0,
              right: 0,
              child: _PriceTag(price: cart.unitPrice),
            ),
            
            if (cart.stock > 0)
              Positioned(
                bottom: 0,
                right: 20,
                child: _AddCar(cart:cart),
              ),

            const Divider( 
              height: 1,
              color: Colors.black45,
            )
          ],
        ),
        
      ),
    );
  }

}

class _PriceTag extends StatelessWidget {

  final int price;

  const _PriceTag({
    Key? key, 
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 120,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(topRight: Radius.circular(25),bottomLeft: Radius.circular(25)),

      ),
      child: FittedBox(
        fit: BoxFit.contain,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text('\$$price',style: const TextStyle(fontSize: 20) ,)
          ),
      ),
      
    );
  }
}

class _ProductDetails extends StatelessWidget {

  final Cart cart;

  const _ProductDetails({
    Key? key, 
    required this.cart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    double margen = size.width * 0.30;

    return Padding(
      padding: EdgeInsets.only(left: margen),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
        width: size.width * 0.70,
        height: 150,
        decoration: _buildBoxDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              cart.name,
              style: const TextStyle(fontSize: 15,fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            
            const SizedBox(height: 45),
        
          ],
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => const BoxDecoration(
    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25),topRight: Radius.circular(25)),
  );
}

class _BackgroundImage extends StatelessWidget {

  final String? url;

  const _BackgroundImage({
    Key? key, 
    this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: SizedBox(
        width : size.width * 0.20,
        height: 130,
        child: url== null 
          ? const Image(
              image: AssetImage('assets/no-image.png'),
              fit: BoxFit.cover,
            )
          :FadeInImage(
            placeholder: const AssetImage('assets/loadin.gif'),
            image: NetworkImage(url!),
            fit: BoxFit.cover,
          ),
      ),
    );
  }
}

class _AddCar extends StatefulWidget {

  final Cart cart;

  const _AddCar({ required this.cart});

  @override
  State<_AddCar> createState() => _AddCarState();
}

class _AddCarState extends State<_AddCar> {

  int cantItem=0;

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final productCart = Provider.of<ProductCartProvider>(context);
    final productsProvider = Provider.of<ProductsProvider>(context);
    final product = widget.cart;
    cantItem = product.itemCart!;

    return Container(
      width: size.width * 0.70,
      height: 40,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [

          MaterialButton(
            color: ThemeData().primaryColor,
            minWidth: 5,
            child: const Text('-',style: TextStyle(color: Colors.white),),
            onPressed: () => (cantItem==0)
              ? null
              :setState(() {
                productsProvider.addItemCart(product.id, 1);
                productCart.reduceItemCart(product.id);
                cantItem--;
              })
            
          ),

          const SizedBox(width: 10),

          Text('$cantItem',style: const TextStyle(fontSize: 18)),

          const SizedBox(width: 10),

          MaterialButton(
            color: ThemeData().primaryColor,
            minWidth: 5,
            child: const Text('+',style: TextStyle(color: Colors.white),),
            onPressed:  () => (cantItem==product.stock)
              ? null
              : 
              setState(() {
                productsProvider.reduceItemCart(product.id, 1);
                productCart.addItemCart(product.id);  
                cantItem++;
            })
          ),

          const SizedBox(width: 11),

          MaterialButton(
            color: Colors.red[400],
            minWidth: 5,
            child: const Text('Eliminar',style: TextStyle(color: Colors.white),),
            onPressed: () {
              setState(() {
                productsProvider.addItemCart(product.id, cantItem);
                productCart.deleteProduct(product.id); 
               
              });
            }
          ),         
        ],
      ),
      
    );
  }
}