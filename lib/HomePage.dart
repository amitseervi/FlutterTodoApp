import 'package:flutter/material.dart';
import 'package:fluttertodoapp/AddItemPage.dart';
import 'package:fluttertodoapp/model/TodoEntity.dart';
import 'package:fluttertodoapp/model/database_helper.dart';
import 'package:fluttertodoapp/todolist/todo_item.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;
  MyTodoList todoList;

  @override
  Widget build(BuildContext context) {
    todoList = MyTodoList();
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: todoList,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("on add button clicked");
          _onAddButtonClicked(context);
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }

  _onAddButtonClicked(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddItemPage()),
    );
    todoList.addTodoEntity(result);
  }
}

class MyTodoList extends StatefulWidget {
  DatabaseHelper db = DatabaseHelper.instance;
  _MyTodoListState state;

  void addTodoEntity(TodoEntity entity) {
    if (state != null) {
      state.appendItem(entity);
    }
  }

  @override
  State<StatefulWidget> createState() {
    state = _MyTodoListState();
    return state;
  }
}

class _MyTodoListState extends State<MyTodoList> {
  List<TodoEntity> items = [];

  @override
  void initState() {
    widget.db.queryAllRows().then((items) => {
          setState(() {
            this.items.clear();
            this.items.addAll(items.map((e) => TodoEntity.fromMap(e)).toList());
          })
        });
  }

  void appendItem(TodoEntity entity) {
    Future<int> insert = widget.db.insert(entity);
    insert.then((value) => {
          if (value > 0)
            {
              setState(() {
                this.items.add(entity);
              })
            }
          else
            {print("Item is not inserted")}
        });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.db.queryAllRows(),
      initialData: List(),
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemBuilder: (ctx, position) {
                  final TodoEntity item =
                      TodoEntity.fromMap(snapshot.data[position]);
                  return Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: TodoItem(item),
                    ),
                  );
                },
                itemCount:
                    snapshot.hasData ? (snapshot.data as List).length : 0,
              )
            : Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }
}
