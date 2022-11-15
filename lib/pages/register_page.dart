import 'package:alternova_test/helpers/show_alert.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:alternova_test/ui/input_decorations.dart';

import '../provider/login_form_provider.dart';
import '../services/firebase_auth.dart';


class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});
 
  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(), // rebota al hacer el scroll
          child: Column(
            children: [
              //header
              _Header(size: size),
              const SizedBox(height: 30),
              ChangeNotifierProvider(
                create: (_) => LoginFormProvider() ,
                child: const _Body()
              ),
              const SizedBox(height: 30),
              
            ]
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
        //autovalidateMode: AutovalidateMode.onUserInteraction, // validar con la interaccion del usuario
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
              validator: (value){
                String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regExp  = RegExp(pattern);

                return regExp.hasMatch(value ?? '')
                  ? null
                  : 'El correo no es correcto';
              },
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
              validator: (value){
                if (value!= null && value.length >= 6) return null;
                return 'La contraseña debe ser de 6 caracteres';
              }, 
            ),

            const SizedBox(height: 30),

            TextFormField(
              autocorrect: false,
              obscureText: true,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                hintText: '******',
                labelText: 'Confirmar contraseña',
                prefixIcon: Icons.lock_outline
              ),
              onChanged: (value) => loginForm.passwordConfirm=value,
              validator: (value){
                if (value == loginForm.password) return null;
                return 'Las contraseñas no son iguales';
              }, 
            ),

            const SizedBox(height: 30),
            
            _BtnLogin(loginForm: loginForm),

            const SizedBox(height: 50),
              
            TextButton(
              onPressed: () => Navigator.pushReplacementNamed(context, 'login') ,
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(Colors.indigo.withOpacity(0.1)),
                shape: MaterialStateProperty.all(const StadiumBorder())
              ), 
              child: const Text(
                '¿ Ya tienes una cuenta ?',
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
        onPressed: loginForm.isLoading ? null : () async {  // loginform.isloading apra bloquear el botton
          FocusScope.of(context).unfocus();

          if(!loginForm.isValidForm()) return;

          loginForm.isLoading=true;
          final authService = Provider.of<AuthService>(context,listen: false);
          final String? errorMessage = await authService.createUSer(loginForm.email, loginForm.password);

          if (errorMessage==null){
            Navigator.pushNamed(context, 'product'); // cambiar a pushReplacementNamed
          } else {
            //NotificationService.showSnackbar(errorMessage);
            showAlert(context, 'Revise los datos', errorMessage);
          }

          loginForm.isLoading=false;

        },
        child: SizedBox(
          width: double.infinity,
          child: Center(
            child: Text(
              loginForm.isLoading
                ? 'Espere'
                :'Crear cuenta',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}