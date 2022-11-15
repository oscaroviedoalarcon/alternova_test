import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService extends ChangeNotifier {

  final String _baseUrl='identitytoolkit.googleapis.com';
  final String _firebaseToken='AIzaSyCIj-DtC23U_sxwz-s_-G96MwXmYlqFdQM';

  final storage = const FlutterSecureStorage();

  //si retornamos algo es un error
  Future <String?> createUSer(String email,String password) async{

    final Map<String,dynamic> authData = {
      'email':email,
      'password':password,
      'returnSecureToken':true,
    };

    final url=Uri.https(_baseUrl,'/v1/accounts:signUp',{
      'key': _firebaseToken
    });

    try{
      
      final resp= await http.post(url,body: json.encode(authData));
      final Map<String,dynamic> decodecResp = json.decode(resp.body);

      if(decodecResp.containsKey('idToken')){
        //token guardarlo en un lugar seguro
        await storage.write(key: 'idToken', value: decodecResp['idToken']);
        return null;
      }else{

        return decodecResp['error']['message'];

      }

    } catch(e){
      return '';
    }

  }

   Future <String?> loginUSer(String email,String password) async{

    final Map<String,dynamic> authData = {
      'email':email,
      'password':password,
      'returnSecureToken':true,
    };

    final url=Uri.https(_baseUrl,'/v1/accounts:signInWithPassword',{
      'key': _firebaseToken
    });

    final resp= await http.post(url,body: json.encode(authData));

    final Map<String,dynamic> decodecResp = json.decode(resp.body);

    if(decodecResp.containsKey('idToken')){
      //token guardarlo en un lugar seguro
      await storage.write(key: 'idToken', value: decodecResp['idToken']);
      return null;
    }else{

      return decodecResp['error']['message'];

    }

  }

  Future logout() async {
    await storage.delete(key: 'idToken');
  }

  Future <String> readToken() async {
    return await storage.read(key: 'idToken') ?? '';
  }

}