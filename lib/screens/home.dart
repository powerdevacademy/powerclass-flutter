import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firestore_ui/animated_firestore_list.dart';
import 'package:flutter/material.dart';
import 'package:power_library/components/bookTile.dart';
import 'package:power_library/models/book.dart';
import 'package:power_library/screens/form.dart';
import 'package:power_library/services/auth.dart';
import 'package:power_library/services/database.dart';
import 'package:provider/provider.dart';


class HomeScreen extends StatefulWidget {
  static const routeName = '/';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<Widget> _bookTiles = [];

  void _loadList(QuerySnapshot books) {

    setState(() {
      _bookTiles.clear();

      books.docs.forEach((data) {
        Book b = Book.fromJson({
          'id': data.id,
          ...data.data()
        });

        _bookTiles.add(BookTile(book: b));
      });
    });

  }

  var _tweenInsert = Tween(
      begin: Offset(1, 0),
      end: Offset(0,0)
  ).chain(CurveTween(curve: Curves.ease));

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);
    String uid = user?.uid;

    return Scaffold(
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      appBar: AppBar(
          title: Text("Power Library"),
          elevation: 0,
          actions: [
            FlatButton.icon(
                onPressed: () async {
                  await AuthService().signOut();
                },
                icon: Icon(Icons.logout, color: Colors.white),
                label: Text("Sair", style: TextStyle(color: Colors.white),),
            )
          ],
      ),
      body: Container(
        margin: EdgeInsets.only(top: 20.0),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: FirestoreAnimatedList(
                query: DatabaseService(uid: uid).booksQuery,
                itemBuilder: (context, data, animation, index) {
                  Book b = Book.fromJson({
                    'id': data.id,
                    ...data.data()
                  });

                  return SlideTransition(
                    position: animation.drive(_tweenInsert),
                    child: BookTile(book: b,)
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, FormScreen.routeName);
        },
        tooltip: 'Adicionar Livro',
        child: Icon(Icons.add),
      ),
    );
  }

}