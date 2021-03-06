import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:power_library/models/book.dart';
import 'package:power_library/services/database.dart';
import 'package:provider/provider.dart';

class FormScreen extends StatefulWidget {
  static const routeName = '/form';

  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isRead = false;
  Book book;
  String uid;

  void _toggleSwitch(_) {
    setState(() {
      _isRead = _formKey.currentState.fields['isRead'].value;
      if(!_isRead) {
        _formKey.currentState.fields["rate"]?.didChange(0.0);
      }
      print("Pode avaliar o livro? ${_isRead}");
    });
  }

  void _saveBook(Map<String, dynamic> bookData) async {

    if(uid == null) {
      return;
    }

    String coverPath;

    if(bookData['cover']?.length > 0) {
      coverPath = await DatabaseService(uid: uid).uploadFile(bookData['cover'][0]);
    }

    coverPath ??= book?.cover;

    var newBookData = {
      ...bookData,
      'uid': uid,
      'cover': coverPath
    };

    if(book?.id == null) {
      await DatabaseService(uid: uid).addBook(newBookData);
    } else {
      await DatabaseService(uid: uid).updateBook(book.id, newBookData);
    }


    Navigator.of(context, rootNavigator: true).pop();
  }

  @override
  void didChangeDependencies() {
    book = ModalRoute.of(context).settings.arguments;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    uid = user?.uid;

    return Scaffold(
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      appBar: AppBar(
        title: Text('Novo Livro'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            FormBuilder(
              key: _formKey,
              initialValue: book?.toJson(),
              autovalidateMode: AutovalidateMode.always,
              child: Column(
                children: [
                  FormBuilderTextField(
                    name: 'title',
                    autocorrect: true,
                    keyboardType: TextInputType.name,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.minLength(
                        context,
                        3,
                        errorText:
                            "O nome do livro tem que ter pelo menos 3 caracteres",
                      ),
                    ]),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Nome do Livro",
                        labelText: "Livro"),
                  ),
                  SizedBox(height: 20.0),
                  FormBuilderTextField(
                    name: 'author',
                    autocorrect: true,
                    keyboardType: TextInputType.name,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                        context,
                        errorText: "O nome do autor é obrigatório",
                      )
                    ]),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Nome do Autor",
                        labelText: "Autor"),
                  ),
                  SizedBox(height: 20.0),
                  FormBuilderImagePicker(
                    name: 'cover',
                    maxImages: 1,
                    initialValue: [],
                    cameraLabel: Text(
                      'Tire uma foto da capa do livro',
                      style: TextStyle(color: Colors.black87),
                    ),
                    galleryLabel: Text(
                      'Escolha uma imagem da sua galeria',
                      style: TextStyle(color: Colors.black87),
                    ),
                    placeholderImage: book?.url != null
                        ?
                        Image.network(
                          book.url,
                          width: 60.0,
                          height: 80.0,
                        ).image
                        :
                        Image.asset(
                          "assets/images/imageplaceholder.png",
                          width: 60.0,
                          height: 80.0,
                        ).image,
                    decoration: InputDecoration(
                      labelText: 'Capa',
                      errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red)
                      ),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromRGBO(58, 66, 86, 1.0))
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  FormBuilderSwitch(
                    name: 'isRead',
                    initialValue: book?.isRead ?? false,
                    activeColor: Colors.green,
                    title: Text('Leitura Finalizada'),
                    decoration: InputDecoration(
                      errorBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromRGBO(58, 66, 86, 1.0))),
                    ),
                    onChanged: _toggleSwitch,
                  ),
                  SizedBox(height: 20.0),
                  FormBuilderRating(
                    name: 'rate',
                    initialValue: book?.rate?.toDouble() ?? 0.0,
                    iconSize: 28.0,
                    max: 5.0,
                    enabled: _isRead,
                    filledColor: Colors.amber,
                    validator: (val) {
                      if(!_isRead) {
                        return null;
                      }
                      if (val == null || val < 1.0) {
                        return "Dê uma avaliação entre 1 e 5 estrelas";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Avaliação',
                      errorBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromRGBO(58, 66, 86, 1.0))),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 20.0),
            RaisedButton(
              child: Text('Salvar'),
              onPressed: () async {
                _formKey.currentState.save();
                if (_formKey.currentState.validate()) {
                  await _saveBook(_formKey.currentState.value);
                } else {
                  await showDialog(
                      context: context,
                      builder: (context) =>
                          AlertDialog(
                            title: Text('Erro!', style: TextStyle(color: Colors.black87),),
                            content: Text(
                              'Não foi possível salvar o livro. Dados inválidos',
                              style: TextStyle(color: Colors.black87),
                            ),
                            actions: [
                              FlatButton(
                                onPressed: () {
                                  Navigator.of(context, rootNavigator: true).pop();
                                },
                                child: Text('OK', style: TextStyle(color: Colors.black87),),
                              )
                            ],
                          ),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
