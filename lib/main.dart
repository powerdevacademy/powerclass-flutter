import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:power_library/components/authGuard.dart';
import 'package:power_library/screens/form.dart';
import 'package:power_library/screens/home.dart';
import 'package:power_library/screens/login.dart';
import 'package:power_library/screens/signup.dart';
import 'package:power_library/services/auth.dart';
import 'package:power_library/services/database.dart';
import 'package:power_library/utils/utils.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

ThemeData buildTheme() {
  final ThemeData _base = ThemeData(
    primarySwatch: CreateMaterialColor(Color.fromRGBO(58, 66, 86, 1.0)),
  );
  
  return _base.copyWith(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    textTheme: GoogleFonts.firaSansTextTheme(
      _base.textTheme.apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
        decorationColor: Colors.white
      )
    ),
    inputDecorationTheme: InputDecorationTheme(
      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
      focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
      border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      labelStyle: TextStyle(color: Colors.white54),
      helperStyle: TextStyle(color: Colors.white54),
      hintStyle: TextStyle(color: Colors.white54),
      errorStyle: TextStyle(color: Colors.red),
    )
  );
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          StreamProvider<User>(
            create: (_) => AuthService().user,
          ),
          StreamProvider<QuerySnapshot>(
            create: (ctx) {
              final user = Provider.of<User>(ctx, listen: false);
              return DatabaseService(uid: user?.uid).booksStream;
            },
          )
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: buildTheme(),
          initialRoute: HomeScreen.routeName,
          routes: {
            HomeScreen.routeName: (context) => AuthGuard(child: HomeScreen()),
            FormScreen.routeName: (context) => AuthGuard(child: FormScreen()),
            LoginScreen.routeName: (context) => LoginScreen(),
            SignupScreen.routeName: (context) => SignupScreen()
          },
        )
    );

  }
}


