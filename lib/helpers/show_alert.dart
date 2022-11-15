import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../services/firebase_auth.dart';


showAlert(BuildContext context,String titulo,String subtitulo){

  //Solo para Android
  if(Platform.isAndroid){

    return showDialog(
      context: context, 
      builder: (_) => AlertDialog(
        title: Text(titulo),
        content: Text(subtitulo),
        actions: [
          MaterialButton(
            elevation: 5,
            textColor: Colors.blue,
            child: const Text('Ok'),
            onPressed: () => Navigator.pop(context), //cerrar el dialogo
          )
        ],
      )

    );
    
  } // usamos el return en el widget anterior para no hacer el else

  //Solo para IOS
  showCupertinoDialog(
    context: context, 
    builder: (context) =>  CupertinoAlertDialog(
      title: Text(titulo),
      content: Text(subtitulo),
      actions: [
        CupertinoDialogAction(
          isDefaultAction: true,
          child: const Text('Ok'),
          onPressed: () => Navigator.pop(context),
        )
      ],
    ),
  );


}

showAlertLogOut(BuildContext context,String titulo,String subtitulo){

  //Solo para Android
  if(Platform.isAndroid){

    return showDialog(
      context: context, 
      builder: (_) => AlertDialog(
        title: Text(titulo),
        content: Text(subtitulo),
        actions: [
          MaterialButton(
            elevation: 5,
            textColor: Colors.blue,
            child: const Text('Cancelar'),
            onPressed: () => Navigator.pop(context), //cerrar el dialogo
          ),
          MaterialButton(
            elevation: 5,
            textColor: Colors.blue,
            onPressed: () {
              final authService = Provider.of<AuthService>(context,listen: false);
              authService.logout();
              Navigator.pushReplacementNamed(context, 'login');
            }, //
            child: const Text('Confirmar'),
          )
        ],
      )
    );
  } // usamos el return en el widget anterior para no hacer el else

  //Solo para IOS
  showCupertinoDialog(
    context: context, 
    builder: (context) =>  CupertinoAlertDialog(
      title: Text(titulo),
      content: Text(subtitulo),
      actions: [
        CupertinoDialogAction(
          isDefaultAction: true,
          child: const Text('Cancelar'),
          onPressed: () => Navigator.pop(context),
        ),
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () {
            final authService = Provider.of<AuthService>(context,listen: false);
            authService.logout();
            Navigator.pushReplacementNamed(context, 'login');
          }, //
          child: const Text('Confirmar'),
        )
      ],
    ),
  );


}

showAlertConfirm(BuildContext context,String titulo,String subtitulo, Function onPressed){

  //Solo para Android
  if(Platform.isAndroid){

    return showDialog(
      context: context, 
      builder: (_) => AlertDialog(
        title: Text(titulo),
        content: Text(subtitulo),
        actions: [
          MaterialButton(
            elevation: 5,
            textColor: Colors.blue,
            child: const Text('Cancelar'),
            onPressed: () => Navigator.pop(context), //cerrar el dialogo
          ),
          MaterialButton(
            elevation: 5,
            textColor: Colors.blue,
            onPressed: () => onPressed.call(), // funcion a ejecutar al confirmar
            child: const Text('Confirmar'),
          )
        ],
      )
    );
  } // usamos el return en el widget anterior para no hacer el else

  //Solo para IOS
  showCupertinoDialog(
    context: context, 
    builder: (context) =>  CupertinoAlertDialog(
      title: Text(titulo),
      content: Text(subtitulo),
      actions: [
        CupertinoDialogAction(
          isDefaultAction: true,
          child: const Text('Cancelar'),
          onPressed: () => Navigator.pop(context),
        ),
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () => onPressed.call(),  // funcion a ejecutar al confirmar
          child: const Text('Confirmar'),
        )
      ],
    ),
  );


}