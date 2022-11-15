import 'package:flutter/material.dart';

import 'package:alternova_test/provider/products_provider.dart';
import 'package:alternova_test/views/loading_view.dart';
import 'package:alternova_test/widgets/cart_icon.dart';
import '../models/models.dart';
import 'package:provider/provider.dart';
import '../provider/products_car_provider.dart';


class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {

    final productProvider = Provider.of<ProductsProvider>(context,listen: false);

    return FutureBuilder(
      future: productProvider.getProductDetail(productProvider.productSelected!.id),
      builder: (context, snapshot) {
        if(!snapshot.hasData){
          return const LoadingView();
        }
        return Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _AppBar(product : productProvider.productDetail),
                _HeaderImage(product : productProvider.productDetail, id: productProvider.productSelected!.id),
                const Divider(),
                _Body(product : productProvider.productDetail,stock : productProvider.productSelected!.stock ),
                const Divider(),
                if(productProvider.productSelected!.stock>0)
                  _AddCart(product: productProvider.productSelected!),
              ],
            ),
          ),
        )
             );
      },
      
    );
  }
}

class _HeaderImage extends StatelessWidget {

  final ProductDetail product;
  final int id;

  const _HeaderImage({
    Key? key, 
    required this.product, required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      height: size.height * 0.3,
      alignment: Alignment.center,
      child: Hero(
        tag: id,
        child: FadeInImage(
          placeholder: const AssetImage('assets/loadin.gif'),
          image: NetworkImage(product.image!),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
} 

class _Body extends StatelessWidget {

  final ProductDetail product;
  final int stock;

  const _Body({ 
    required this.stock,
    required this.product, 
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${product.name}',style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Text('${product.description}',style: const TextStyle(fontSize: 15)),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, 
            children: [
              Text('$stock unidades disponibles',style: const TextStyle(fontSize: 20)),
              Text('\$ ${product.unitPrice}',style: const TextStyle(fontSize: 20)),
            ]
          ),
          
        ],
      ),
    );
  }
}

class _AppBar extends StatelessWidget {

  final ProductDetail product;

  const _AppBar({ 
    required this.product
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.all(16),
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context), 
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width*0.6,
            child: Column(
              children: [
                Text('${product.name}', style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    
                ),),
              ],
            ),
          ),

          const CartIcon(),
        ],
      ),
    );
  }
}

class _AddCart extends StatefulWidget {

  final Product product;

  const _AddCart({ required this.product});

  @override
  State<_AddCart> createState() => _AddCarState();
}

class _AddCarState extends State<_AddCart> {

  int cantItem=1;

  @override
  Widget build(BuildContext context) {

    final productCart = Provider.of<ProductCartProvider>(context);
    final product = widget.product;
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [

          MaterialButton(
            color: ThemeData().primaryColor,
            minWidth: 5,
            child: const Text('-',style: TextStyle(color: Colors.white),),
            onPressed: () => (cantItem==1)
              ? null
              :setState(() {
                cantItem--;
              })
            
          ),

          Text('$cantItem'),

          MaterialButton(
            color: ThemeData().primaryColor,
            minWidth: 5,
            child: const Text('+',style: TextStyle(color: Colors.white),),
            onPressed:  () => (cantItem==product.stock)
              ? null
              :setState(() {
                cantItem++;
              })
          ),

          const SizedBox(width: 11),
          
          MaterialButton(
            color: Colors.blue,
            minWidth: 5,
            child: const Text('Agregar',style: TextStyle(color: Colors.white),),
            onPressed: () {
              
              final cart= Cart(
                id: product.id, 
                name: product.name, 
                unitPrice: product.unitPrice, 
                stock: product.stock,
                itemCart : cantItem,
                image: product.image
                );

              productCart.addUpdateProduct(cart);
              
            }
          ),

        ],
      ),
      
    );
  }
}