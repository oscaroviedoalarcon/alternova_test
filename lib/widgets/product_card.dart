import 'package:alternova_test/models/cart.dart';
import 'package:alternova_test/provider/products_provider.dart';
import 'package:flutter/material.dart';
import 'package:alternova_test/models/product.dart';
import 'package:provider/provider.dart';

import '../provider/products_car_provider.dart';

class ProductCard extends StatelessWidget {

  final Product product;

  const ProductCard({
    Key? key, 
    required this.product
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        width: double.infinity,
        height: 150,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(25)),
        child: Stack(          
          children: [

            _BackgroundImage(url:product.image,id: product.id),

            _ProductDetails(product:product),

            Positioned(
              top: 0,
              right: 0,
              child: _PriceTag(price: product.unitPrice),
            ),
            
            if (product.stock == 0)
              Positioned(
                top: 0,
                left: 0,
                child: _Stock(),
              ),
            
            if (product.stock > 0)
              Positioned(
                bottom: 0,
                right: 20,
                child: _AddCar(product:product),
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

class _Stock extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 20,
      decoration: const BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.only(bottomRight: Radius.circular(25))
      ),
      child: const FittedBox(
        fit: BoxFit.contain,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            'Agotado',
            style: TextStyle(fontSize: 20),
          ),
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
      height: 180,
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

  final Product product;

  const _ProductDetails({
    Key? key, 
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final productProvider= Provider.of<ProductsProvider>(context); 
    final size = MediaQuery.of(context).size;
    double margen = size.width * 0.30;

    return Padding(
      padding: EdgeInsets.only(left: margen),
      child: GestureDetector(
        onTap: () {
          productProvider.productSelected = product;
          Navigator.pushNamed(context, 'productDetail');
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
          width: size.width * 0.70,
          height: 150,
          decoration: _buildBoxDecoration(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start ,
            children: [
              Text(
                product.name,
                style: const TextStyle(fontSize: 15,fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10),
      
              Text(
                '${product.stock} Unidades disponibles',
                style: const TextStyle(fontSize: 15),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              
              const SizedBox(height: 35),
          
            ],
          ),
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
  final int id;

  const _BackgroundImage({
    Key? key, 
    this.url, 
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: Container(
        padding: const EdgeInsets.only(top: 10),
        width: size.width * 0.20,
        height: 130,
        child: Hero(
          tag: id, 
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
        )
      ),
    );
  }
}

class _AddCar extends StatefulWidget {

  final Product product;

  const _AddCar({required this.product});

  @override
  State<_AddCar> createState() => _AddCarState();
}

class _AddCarState extends State<_AddCar> {

  int cantItem=1;

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final productCart = Provider.of<ProductCartProvider>(context);
    final productsProvider = Provider.of<ProductsProvider>(context);
    final product = widget.product;

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
            onPressed: () => (cantItem==1)
              ? null
              :setState(() {
                cantItem--;
              })
            
          ),

          const SizedBox(width: 10),

          Text('$cantItem',style: const TextStyle(fontSize: 10)),

          const SizedBox(width: 10),

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
                image: product.image, 
                stock: product.stock,
                itemCart : cantItem
              );
              productsProvider.reduceItemCart(product.id, cantItem);
              productCart.addUpdateProduct(cart);
              //mostrar la información de la compra
              final snackBar = SnackBar(content: (cantItem>1) 
                ? Text('Se han agregado $cantItem items a su carrito') 
                : Text('Se ha agregado $cantItem item a su carrito'));

              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              setState(() {
                cantItem=1;
              });
              
            }
          ),
        ],
      ),
    );
  }
}