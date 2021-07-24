import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:uas/Utils/model_todolist.dart';

class DBTodolist {
  late DatabaseReference _counterRef;
  late DatabaseReference _todolistRef;
  late StreamSubscription<Event> _counterSubscription;
  late StreamSubscription<Event> _messagesSubscription;
  late FirebaseDatabase database = new FirebaseDatabase();
  late int _counter;
  late DatabaseError? error;

  static final DBTodolist _instance = new DBTodolist.internal();

  DBTodolist.internal();

  factory DBTodolist() {
    return _instance;
  }

  void initState() {
    // Demonstrates configuring to the database using a file
    _counterRef = FirebaseDatabase.instance.reference().child('counter');
    // Demonstrates configuring the database directly

    _todolistRef = database.reference().child('todolist');
    database.reference().child('counter').once().then((DataSnapshot snapshot) {
      print('Connected to second database and read ${snapshot.value}');
    });
    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(10000000);
    _counterRef.keepSynced(true);

    _counterSubscription = _counterRef.onValue.listen((Event event) {
      error = null;
      _counter = event.snapshot.value ?? 0;
    }, onError: (o) {
      error = o;
    });
  }

  DatabaseError? getError() {
    return error;
  }

  int getCounter() {
    return _counter;
  }

  DatabaseReference getTodolist() {
    return _todolistRef;
  }

  addTodolist(ModelTodoList todoList) async {
    final TransactionResult transactionResult =
        await _counterRef.runTransaction((MutableData mutableData) async {
      mutableData.value = (mutableData.value ?? 0) + 1;

      return mutableData;
    });

    if (transactionResult.committed) {
      _todolistRef.push().set(<String, dynamic>{
        "title": "" + todoList.title,
        "content": "" + todoList.content,
        "dateTodo": "" + todoList.dateTodo.toString(),
        "isComplete": "" + todoList.isComplete.toString(),
      }).then((_) {
        print('Transaction  committed.');
      });
    } else {
      print('Transaction not committed.');
      if (transactionResult.error != null) {
        print(transactionResult.error!.message);
      }
    }
  }

  void deleteTodolist(ModelTodoList todoList) async {
    await _todolistRef.child(todoList.uid).remove().then((_) {
      print('Transaction  committed.');
    });
  }

  void updateTodolist(ModelTodoList todoList) async {
    await _todolistRef.child(todoList.uid).update({
      "title": "" + todoList.title,
      "content": "" + todoList.content,
      "dateTodo": "" + todoList.dateTodo.toString(),
      "isComplete": "" + todoList.isComplete.toString(),
    }).then((_) {
      print('Transaction  committed.');
    });
  }

  void dispose() {
    _messagesSubscription.cancel();
    _counterSubscription.cancel();
  }
}

extension BoolParsing on String {
  bool parseBool() {
    return this.toLowerCase() == 'true';
  }
}
