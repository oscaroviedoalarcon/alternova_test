import 'package:alternova_test/pages/pages.dart';
import 'package:alternova_test/preferences/preferences.dart';
import 'package:alternova_test/provider/login_form_provider.dart';
import 'package:alternova_test/provider/preferences_provider.dart';
import 'package:alternova_test/provider/products_car_provider.dart';
import 'package:alternova_test/provider/products_provider.dart';
import 'package:alternova_test/services/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Preferences.initPreferences();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginFormProvider()),
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => PreferencesProvider(isDarkmode: Preferences.isDarkmode)),
        ChangeNotifierProvider(create: (_) => ProductsProvider(),lazy: false),
        ChangeNotifierProvider(create: (_) => ProductCartProvider(),lazy: false),
      ],
      child: const MyApp()
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AlternovaTest',
      initialRoute: 'loading',
      routes: {
        'loading' :(context) =>  LoadingPage(),
        'login' :(context) =>  LoginPage(),
        'product' :(context) =>  ProductsPage(),
        'register' :(context) =>  RegisterPage(),
        'productDetail' :(context) =>  ProductPage(),
        'cart' :(context) =>  CartPage(),
      },
      theme: Provider.of<PreferencesProvider>(context).currentTheme,
      //theme: miTema,
    );
  }
}