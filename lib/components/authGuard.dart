import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:power_library/screens/login.dart';
import 'package:provider/provider.dart';

class AuthGuard extends StatelessWidget {
  final Widget child;
  const AuthGuard({Key key, @required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    print("USER");
    print(user);

    return user == null ? LoginScreen() : child;
  }
}
