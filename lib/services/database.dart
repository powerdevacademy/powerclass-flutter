import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DatabaseService {
  final String uid;

  DatabaseService({@required this.uid});

  final CollectionReference _booksCol = FirebaseFirestore.instance.collection('books');
  final _booksBucket = FirebaseStorage.instance.ref();
  static final coverFolder = 'covers';

  Stream<QuerySnapshot> get booksStream => _booksCol.where('uid', isEqualTo: uid).orderBy('title').snapshots();

  Query get booksQuery => _booksCol.where('uid', isEqualTo: uid).orderBy('title');

  Future<DocumentReference> addBook(Map<String, dynamic> data) => _booksCol.add(data);

  Future<void> updateBook(String id, Map<String, dynamic> data) => _booksCol.doc(id).update(data);

  Future<void> deleteBook(String id) => _booksCol.doc(id).delete();

  Future<String> uploadFile(File file) async {

    String path = "${coverFolder}/${DateTime.now()}.png";
    try {
      await _booksBucket.child(path).putFile(file);
    } on FirebaseException catch (e) {
      print (e);
    }

    return path;
  }

  Future<String> getFileURL(path) async {
    return await FirebaseStorage.instance.ref(path).getDownloadURL();
  }

}