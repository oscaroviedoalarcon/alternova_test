import 'package:alternova_test/helpers/show_alert.dart';
import 'package:alternova_test/pages/pages.dart';
import 'package:alternova_test/provider/preferences_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:alternova_test/ui/input_decorations.dart';

import '../provider/login_form_provider.dart';
import '../services/firebase_auth.dart';


class LoginPage extends StatelessWidget {
  const LoginPage({super.key});
 
  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final preferences = Provider.of<PreferencesProvider>(context,listen: false);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(), // rebota al hacer el scroll
          child: SizedBox(
            height: MediaQuery.of(context).size.height*0.9, // ocupa el 90% espacio de la pantalla
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // los elementos ocupen toda la pantalla
              children: [
                //header
                _Header(size: size),
                const SizedBox(height: 30),
                ChangeNotifierProvider(
                  create: (_) => LoginFormProvider() ,
                  child: const _Body()
                ),

                const SizedBox(height: 50),

                SwitchListTile.adaptive(
                  value: preferences.isDarkmode, 
                  title: const Text('Modo dark',textAlign: TextAlign.right),
                  onChanged: (value) {
                    preferences.isDarkmode=value;
                    value 
                      ? preferences.setDarkmode() 
                      : preferences.setLightMode();
                  },
                ),
                
              ]
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [

        //fondo
        Container(
          height: size.height*0.3,
          decoration: const BoxDecoration(
          ),
        ),
        //logo
        Positioned(
          top: size.height*0.12,
          left: size.width*0.20,
          right: size.width*0.20,
          child: Container(
            alignment: Alignment.center,
            
            height: size.height*0.2,
            child: const Image(
              image: AssetImage('assets/full-Alternova.png')
            )
          )
        )
      ],

    );
  }
}

class _Body extends StatelessWidget {
  const _Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final loginForm = Provider.of<LoginFormProvider>(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Form(
        key: loginForm.formKey,

        child: Column(
          children: [          
            
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                hintText: 'example@corre.com',
                labelText: 'Correo electrónico',
                prefixIcon: Icons.alternate_email_sharp
              ),
              onChanged: (value) => loginForm.email=value,
            ),

            const SizedBox(height: 30),

            TextFormField(
              autocorrect: false,
              obscureText: true,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                hintText: '******',
                labelText: 'Contraseña',
                prefixIcon: Icons.lock_outline
              ),
              onChanged: (value) => loginForm.password=value,
            ),

            const SizedBox(height: 30),
            
            _BtnLogin(loginForm: loginForm),

            const SizedBox(height: 50),

            TextButton(
              //onPressed: () => Navigator.pushReplacementNamed(context, 'register') ,
              onPressed: () => Navigator.push(context, PageRouteBuilder(
                pageBuilder: (_, __, ___) => const RegisterPage(),
                transitionDuration: const Duration(milliseconds: 200),
                transitionsBuilder: (_, a, __, c) => SlideTransition(
                  position:Tween<Offset>(
                    begin: const Offset(1,0),
                    end: Offset.zero
                  ).animate(a), 
                  child: c
                )
              )) ,
              style: ButtonStyle(
                //overlayColor: MaterialStateProperty.all(Colors.indigo.withOpacity(0.1)),
                shape: MaterialStateProperty.all(const StadiumBorder())
              ), 
              child: const Text(
                'Crear una nueva cuenta',
                style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}

class _BtnLogin extends StatelessWidget {
  const _BtnLogin({
    Key? key,
    required this.loginForm,
  }) : super(key: key);

  final LoginFormProvider loginForm;

  @override
  Widget build(BuildContext context) {
    return Container(
      
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: ThemeData().primaryColor
      ),
      child: MaterialButton(     
        onPressed: loginForm.isLoading ? null : () async {  // loginform.isloading para bloquear el botton
          FocusScope.of(context).unfocus();

          if(!loginForm.isValidForm()) return;

          loginForm.isLoading=true;
          final authService = Provider.of<AuthService>(context,listen: false);
          final String? errorMessage =await authService.loginUSer(loginForm.email, loginForm.password);
          
          if (errorMessage==null){
            Navigator.pushReplacementNamed(context, 'product'); // cambiar a pushReplacementNamed
          } else {
            showAlert(context, 'Revise los datos', 'Los datos ingresados no son correctos');
          }

          loginForm.isLoading=false;

        },
        child: SizedBox(
          width: double.infinity,
          child: Center(
            child: Text(
              loginForm.isLoading
                ? 'Espere'
                :'Ingresar',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}