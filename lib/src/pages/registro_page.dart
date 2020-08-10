import 'package:flutter/material.dart';
import 'package:practica_1/src/pages/login_page.dart';
import 'package:string_validator/string_validator.dart';

class RegistroPage extends StatefulWidget {
  @override
  _RegistroPageState createState() => _RegistroPageState();
}

class _RegistroPageState extends State<RegistroPage> {
  bool _validatorEmail = false;
  bool _validatorName = false;
  bool _validatorPass = false;
  bool _validatorFecha = false;
  bool _isDisabledButton = true;
  bool isLoadin = false;

  String _email = '';
  String _fullname = '';

  String _fecha = '';

  DateTime currentBackPressTime;

  TextEditingController _inputFileController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('REGISTRATE'),
        centerTitle: true,
      ),
      body: _renderBoyd(),
    );
  }

  Widget _renderBoyd() {
    return Stack(
      children: <Widget>[
        SizedBox(
          height: 400,
        ),
        crearLoadin(),
        Center(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 40.0),
            children: <Widget>[
              SizedBox(
                height: 200,
              ),
              _inputText(),
              emailField(),
              passwordField(),
              _crearFecha(),
              _createButton()
            ],
          ),
        )
      ],
    );
  }

  Widget _createButton() {
    return RaisedButton(
      color: Colors.green,
      shape: StadiumBorder(),
      child: Text('Iniciar Sesión'),
      onPressed: _isDisabledButton
          ? null
          : () {
              setState(() {
                isLoadin = true;
                crearCuenta(context);
              });
            },
    );
  }

  Widget emailField() {
    return TextField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: 'Correo',
        labelText: 'Correo',
        suffixIcon: Icon(Icons.email),
        errorText:
            (_validatorEmail = !isEmail(_email)) ? 'Correo Invalido' : null,
      ),
      onChanged: (valor) {
        setState(() {
          _email = valor;
          _habilitarboton();
        });
      },
    );
  }

  Widget _inputText() {
    return TextField(
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        hintText: 'Escriba su nombre',
        labelText: 'Nombre',
        errorText:
            ((_validatorName = _isName(_fullname)) ? 'Valor invalido' : null),
        suffixIcon: Icon(Icons.accessibility),
      ),
      onChanged: (valor) {
        setState(() {
          _fullname = valor;
          _isName(valor);
          _habilitarboton();
        });
      },
    );
  }

  _crearFecha() {
    return TextField(
      controller: _inputFileController,
      enableInteractiveSelection: false,
      decoration: InputDecoration(
        hintText: '',
        labelText: '',
        helperText: 'Fecha de nacimiento',
        suffixIcon: Icon(Icons.calendar_today),
      ),
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
        _selectDate(context);
      },
    );
  }

  Widget passwordField() {
    return TextField(
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Password',
        labelText: 'Password',
        errorText: _validatorPass ? 'Contraseña invalida' : null,
        suffixIcon: Icon(Icons.lock_open),
      ),
      onChanged: (valor) {
        setState(() {
          _validatorPass = _validarPassword(valor);
          _habilitarboton();
        });
      },
    );
  }

  _selectDate(BuildContext context) async {
    DateTime picked = await showDatePicker(
        context: context,
        locale: Locale('es'),
        helpText: 'Fecha de nacimiento',
        initialDate: new DateTime.now(),
        firstDate: new DateTime(1980),
        lastDate: new DateTime.now());

    if (picked != null) {
      _fecha = picked.toString();
      _inputFileController.text = _fecha;
    }
  }

  bool _isName(String valor) {
    return !RegExp(r"^[A-Za-z ]+$").hasMatch(valor);
  }

  bool _validarPassword(String valor) {
    String patter_password =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = new RegExp(patter_password);

    if (regExp.hasMatch(valor)) {
      return false;
    }
    //print("mal papu");
    return true;
  }

  void _habilitarboton() {
    setState(() {
      if (_validatorEmail == false &&
          _validatorName == false &&
          _validatorPass == false) {
        _isDisabledButton = false;
      } else {
        _isDisabledButton = true;
      }
    });
  }

  Future<Null> crearCuenta(BuildContext context) async {
    //isLoadin = false;
    return Future.delayed(new Duration(seconds: 3), () {
      setState(() {
        isLoadin = false;
        _mostrarAlerta(context);
      });
    });
  }

  void _mostrarAlerta(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text('Bienvenido $_fullname'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('Tu correo: $_email a sido registrado con exito!'),
                FlutterLogo(
                  size: 100,
                )
              ],
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cancelar'),
              ),
              FlatButton(
                onPressed: () {
                  final route =
                      MaterialPageRoute(builder: (context) => LoginPage());
                  Navigator.push(context, route);
                },
                child: Text('Iniciar sesión!'),
              )
            ],
          );
        });
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
}
