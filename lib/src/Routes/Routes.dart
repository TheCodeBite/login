import 'package:flutter/material.dart';
import 'package:practica_1/src/pages/login_page.dart';
import 'package:practica_1/src/pages/registro_page.dart';

Map<String, WidgetBuilder> getRoutes() {
  return <String, WidgetBuilder>{
    '/': (BuildContext context) => LoginPage(),
    'registro': (BuildContext context) => RegistroPage(),
  };
}
