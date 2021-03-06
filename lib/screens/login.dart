import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:power_library/screens/signup.dart';
import 'package:power_library/services/auth.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}


class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormBuilderState>();

  void _doLogin(Map<String, dynamic> loginData) async {
    User user = await AuthService()
        .signInWithEmailandPassword(loginData["email"].trim(), loginData["password"].trim());

    if(user == null) {
      await showDialog(
          context: context,
          builder: (context) =>
            AlertDialog(
              title: Text('Erro!', style: TextStyle(color: Colors.black87)),
              content: Text(
                'Não foi possível efetuar o login',
                style: TextStyle(color: Colors.black87),
              ),
              actions: [
                FlatButton(
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                    child: Text('OK', style: TextStyle(color: Colors.black87))
                )
              ],
            )
      );
    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      appBar: AppBar(
        title: Text("Entre"),
        actions: [
          FlatButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pushNamed(SignupScreen.routeName);
              },
              child: Text('Cadastre-se', style: TextStyle(color: Colors.white))
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(30.0),
        child: Column(
          children: <Widget>[
            FormBuilder(
              key: _formKey,
              autovalidateMode: AutovalidateMode.disabled,
              child: Column(
                children: <Widget>[
                  FormBuilderTextField(
                    name: 'email',
                    decoration: InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.name,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(context,
                          errorText: 'O email é obrigatório'),
                    ]),
                  ),
                  SizedBox(height: 10),
                  FormBuilderTextField(
                    name: 'password',
                    obscureText: true,
                    decoration: InputDecoration(labelText: 'Senha'),
                    keyboardType: TextInputType.name,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(context,
                          errorText: 'A senha é obrigatório'),
                    ]),
                  ),
                  SizedBox(height: 10),

                ],
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: MaterialButton(
                    color: Colors.green,
                    child: Text(
                      "Entrar",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      _formKey.currentState.save();
                      if (_formKey.currentState.validate()) {
                        await _doLogin(_formKey.currentState.value);
                      } else {
                        await showDialog(
                          context: context,
                          builder: (context) =>
                          new AlertDialog(
                            title: new Text('Erro!', style: TextStyle(color: Colors.black87)),
                            content: Text(
                              'Não foi possível efetuar o login',
                              style: TextStyle(color: Colors.black87),
                            ),
                            actions: <Widget>[
                              new FlatButton(
                                onPressed: () {
                                  Navigator.of(context, rootNavigator: true).pop();
                                },
                                child: new Text('OK', style: TextStyle(color: Colors.black87)),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      )
    );
  }
}
