import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';

class ModelTodoList {
  late String _uid;
  late String _title;
  late String _content;
  late String _dateTodo;
  late String _isComplete;

  ModelTodoList(
      this._uid, this._title, this._content, this._dateTodo, this._isComplete);

  String get title => _title;

  String get content => _content;

  String get dateTodo => _dateTodo;

  String get isComplete => _isComplete;

  String get uid => _uid;

  ModelTodoList.fromSnapshot(DataSnapshot snapshot) {
    _uid = snapshot.key.toString();
    _title = snapshot.value['title'];
    _content = snapshot.value['content'];
    _dateTodo = snapshot.value['dateTodo'];
    _isComplete = snapshot.value['isComplete'];
  }
}
