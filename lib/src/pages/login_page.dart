import 'dart:async';

import 'package:flutter/material.dart';
import 'package:practica_1/src/pages/index_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _emailvalid = false;
  bool _passvalid = false;

  bool _statusEmail = true;
  bool _statusPass = true;

  bool isLoadin = false;
  bool disabled = false;
  bool _isDisabledButton = true;

  DateTime currentBackPressTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(child: renderBody(), onWillPop: null),
    );
  }

  Widget renderBody() {
    return Stack(
      children: <Widget>[
        crearLoadin(),
        ListView(
          padding: EdgeInsets.symmetric(horizontal: 40.0),
          children: <Widget>[
            SizedBox(
              height: 275.00,
            ),
            Text(
              'LOGIN',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 50, letterSpacing: 30),
            ),
            SizedBox(
              height: 25.00,
            ),
            emailField(),
            SizedBox(
              height: 15.00,
            ),
            passwordField(),
            RaisedButton(
              color: Colors.green,
              shape: StadiumBorder(),
              child: Text('Iniciar Sesión'),
              onPressed: _isDisabledButton
                  ? null
                  : () {
                      setState(() {
                        isLoadin = true;
                        iniciarSesion(context);
                      });
                    },
            ),
            SizedBox(
              height: 10.00,
            ),
            Center(
              child: GestureDetector(
                onTap: () {
                  // Navigator.pushNamed(context, 'registro');
                  Navigator.of(context).pushNamed('registro');
                },
                child: Text(
                  'No tengo cuenta',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget emailField() {
    return TextField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
        hintText: 'Correo',
        labelText: 'Correo',
        suffixIcon: Icon(Icons.email),
        errorText: _emailvalid ? 'Correo Invalido' : null,
        //  icon: Icon(Icons.email)
      ),
      onChanged: (valor) {
        setState(() {
          _emailvalid = _validarCorreo(valor);
        });
      },
    );
  }

  Widget passwordField() {
    return TextField(
      obscureText: true,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
        hintText: 'Password',
        labelText: 'Password',
        errorText: _passvalid ? 'Contraseña invalida' : null,
        suffixIcon: Icon(Icons.lock_open),
      ),
      onChanged: (valor) {
        setState(() {
          _passvalid = _validarPassword(valor);
        });
      },
    );
  }

  bool _validarCorreo(String valor) {
    bool regexEmail = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(valor);
    if (valor.length <= 0 || !regexEmail) {
      _statusEmail = true;
      enableDisableLogin();
      return true;
    }

    _statusEmail = false;
    enableDisableLogin();
    return false;
  }

  bool _validarPassword(String valor) {
    String patter_password =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = new RegExp(patter_password);

    if (regExp.hasMatch(valor)) {
      _statusPass = false;
      enableDisableLogin();
      return false;
    }
    _statusPass = true;
    enableDisableLogin();
    return true;
  }

  Widget crearLoadin() {
    if (isLoadin) {
      return Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[CircularProgressIndicator()],
            ),
          ),
          SizedBox(
            height: 400.0,
          )
        ],
      );
    }

    return Container();
  }

  Future<Null> iniciarSesion(BuildContext context) async {
    return Future.delayed(new Duration(seconds: 3), () {
      setState(() {
        isLoadin = false;
        final route = MaterialPageRoute(builder: (context) => IndexPage());
        Navigator.push(context, route);
      });
    });
  }

  void enableDisableLogin() {
    setState(() {
      if (_statusEmail || _statusPass) {
        _isDisabledButton = true;
      } else {
        _isDisabledButton = false;
      }
    });
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      SnackBar(content: Text('alerta de salida'));
      print("alerta de salida falso");
      return Future.value(false);
    }
    print("retorno true");
    return Future.value(true);
  }
}
