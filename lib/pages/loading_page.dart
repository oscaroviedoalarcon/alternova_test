import 'package:alternova_test/pages/pages.dart';
import 'package:alternova_test/provider/preferences_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

import '../services/firebase_auth.dart';

class LoadingPage extends StatelessWidget {
   
  const LoadingPage({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
         child: FutureBuilder(
          future: checkLoginState(context),
          builder: (context, snapshot) {
            return const Text('Espere un momento...');
          },
        ),
      ),
    );
  }

  Future checkLoginState(BuildContext context) async{

    final authService = Provider.of<AuthService>(context,listen: false);
    final autenticado = await authService.readToken();

    await loadPreferences(context);

    if(autenticado.isNotEmpty){

      // DE ESTA FORMA SE HACE MAS RAPIDO EL PASE DE PANTALLAS
      Navigator.pushReplacement(
        context, 
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const ProductsPage(),
          transitionDuration: const Duration(milliseconds: 0)
        )
      );
    }else{
      Navigator.pushReplacement(
        context, 
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const LoginPage(),
          transitionDuration: const Duration(milliseconds: 0)
        )
      );
    }

  }

  Future loadPreferences(BuildContext context) async {
    final preferences = Provider.of<PreferencesProvider>(context,listen: false);
    const storage =  FlutterSecureStorage();

    final darkMode = await storage.read(key: 'isDarkmode') ?? 'false';

    preferences.isDarkmode = darkMode.toLowerCase()=='true';

    preferences.isDarkmode 
    ? preferences.setDarkmode()
    : preferences.setLightMode();

  }
}