import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:uas/Utils/db_todolist.dart';
import 'package:uas/constants.dart';
import 'package:uas/Screens/login_screen.dart';
import 'package:uas/Utils/model_todolist.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomeScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _dateTodoController = TextEditingController();

  String? _setDate;
  DateTime selectedDate = DateTime.now();
  bool _isProcessing = false;

  final auth = FirebaseAuth.instance;

  bool _anchorToBottom = false;
  late DBTodolist databaseUtil;

  @override
  void initState() {
    super.initState();
    databaseUtil = new DBTodolist();
    databaseUtil.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (auth.currentUser == null) {
      return LoginScreen();
    }

    return Scaffold(
        backgroundColor: Colors.blue,
        appBar: AppBar(
          title: Text(
            'Todo App',
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: primaryTextColor),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  auth.signOut();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      'login', (Route<dynamic> route) => false);
                },
                icon: Icon(Icons.logout))
          ],
          centerTitle: true,
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(
                  child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(vertical: 30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40)),
                ),
                child: new FirebaseAnimatedList(
                  key: new ValueKey<bool>(_anchorToBottom),
                  query: databaseUtil.getTodolist(),
                  reverse: _anchorToBottom,
                  sort: _anchorToBottom
                      ? (DataSnapshot a, DataSnapshot b) =>
                          b.key!.compareTo((a.key ?? ""))
                      : null,
                  itemBuilder: (BuildContext context, DataSnapshot snapshot,
                      Animation<double> animation, int index) {
                    return new SizeTransition(
                      sizeFactor: animation,
                      child: showUser(snapshot),
                    );
                  },
                ),
              ))
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => {_createOrUpdate()},
          child: Icon(Icons.add),
        ));
  }

  Widget showUser(DataSnapshot res) {
    ModelTodoList todoList = ModelTodoList.fromSnapshot(res);

    var item = new Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.15,
      child: Container(
        margin: EdgeInsets.fromLTRB(20, 0, 20, 15),
        padding: EdgeInsets.fromLTRB(15, 15, 10, 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(right: 10),
                child: Text(
                  todoList.dateTodo,
                  style: TextStyle(color: Colors.grey[700]),
                )),
            Expanded(
              child: Text(
                todoList.title,
                style: TextStyle(
                    color: CustomColors.TextHeader,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            stops: [0.015, 0.015],
            colors: [
              ((todoList.isComplete == 'true')
                  ? CustomColors.GreenIcon
                  : CustomColors.YellowIcon),
              Colors.white
            ],
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          ),
          boxShadow: [
            BoxShadow(
              color: CustomColors.GreyBorder,
              blurRadius: 5.0,
              spreadRadius: 1.0,
              offset: Offset(0.0, 0.0),
            ),
          ],
        ),
      ),
      secondaryActions: <Widget>[
        SlideAction(
          child: Container(
            padding: EdgeInsets.only(bottom: 10),
            child: Container(
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: CustomColors.BlueBackground),
                child: Icon(
                  Icons.drive_file_rename_outline,
                  color: CustomColors.BlueIcon,
                )),
          ),
          onTap: () => {_createOrUpdate(res)},
        ),
        SlideAction(
          child: Container(
            padding: EdgeInsets.only(bottom: 10),
            child: Container(
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: CustomColors.TrashRedBackground),
                child: Icon(
                  Icons.delete,
                  color: CustomColors.TrashRed,
                )),
          ),
          onTap: () {
            deleteTodoList(todoList);
          },
        ),
      ],
    );

    return item;
  }

  Future<void> _createOrUpdate([DataSnapshot? res]) async {
    ModelTodoList? todoList;

    String action = 'create';
    if (res != null) {
      todoList = ModelTodoList.fromSnapshot(res);
      action = 'update';

      DateTime dateTodo = DateTime.parse(todoList.dateTodo);

      _titleController.text = todoList.title;
      _contentController.text = todoList.content;
      _dateTodoController.text = DateFormat.yMd().format(dateTodo);
    }

    await showModalBottomSheet(
        backgroundColor: Colors.white,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                  controller: _contentController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                  ),
                ),
                TextField(
                    // style: TextStyle(fontSize: 40),
                    // textAlign: TextAlign.center,
                    readOnly: true,
                    keyboardType: TextInputType.text,
                    controller: _dateTodoController,
                    onChanged: (String val) {
                      _setDate = val;
                    },
                    onTap: () {
                      _selectDate(context);
                    },
                    decoration: InputDecoration(
                      labelText: 'Tanggal',
                    )),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: Text(action == 'create' ? 'Create' : 'Update'),
                  onPressed: () async {
                    final String title = _titleController.text;
                    final String content = _contentController.text;
                    final String dateTodo = _dateTodoController.text;
                    if (title != "") {
                      setState(() {
                        _isProcessing = true;
                      });

                      if (todoList != null) {
                        ModelTodoList dtInsert = new ModelTodoList(todoList.uid,
                            title, content, dateTodo, todoList.isComplete);
                        databaseUtil.updateTodolist(dtInsert);
                      } else {
                        ModelTodoList dtInsert = new ModelTodoList("", title,
                            content, DateTime.now().toString(), 'false');
                        databaseUtil.addTodolist(dtInsert);
                      }

                      setState(() {
                        _isProcessing = false;
                      });

                      _titleController.text = "";
                      _contentController.text = "";
                      _dateTodoController.text = "";

                      Navigator.of(context).pop();
                    } else {
                      print("invalid form");
                    }
                  },
                )
              ],
            ),
          );
        });
  }

  deleteTodoList(ModelTodoList todoList) {
    setState(() {
      databaseUtil.deleteTodolist(todoList);
    });
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedDate = picked;
        _dateTodoController.text = DateFormat.yMd().format(selectedDate);
      });
  }
}
