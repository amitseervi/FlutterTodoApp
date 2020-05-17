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
    print(result);
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
          return ListView.builder(
              itemBuilder: (ctx, position) {
                return GestureDetector(
                  child: Card(
                    child: Dismissible(
                      // Show a red background as the item is swiped away.
                      background: Container(color: Colors.black38),
                      key: Key(items[position].id.toString()),
                      onDismissed: (direction) {
                        TodoEntity item = items[position];
                        widget.db.delete(item.id);
                        setState(() {
                          items.remove(item);
                        });
                        Scaffold.of(context).showSnackBar(SnackBar(
                            content:
                                Text("${item.title} removed from todo list")));
                      },
                      child: Row(children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(16),
                          child: TodoItem(items[position]),
                        )
                      ]),
                    ),
                  ),
                  onTap: () {
                    _openNoteDetailDialog(items[position]);
                  },
                );
              },
              itemCount: items.length);
        });
  }

  void _openNoteDetailDialog(TodoEntity entity) {
    print(entity);
    showDialog(
        context: this.context,
        child: createTodoEntityDetailDialog(this.context, entity));
  }

  Widget createTodoEntityDetailDialog(BuildContext context, TodoEntity entity) {
    return AlertDialog(
      title: Text(entity.title),
      content: Text(entity.content),
    );
  }
}

class TodoItemDetailDialog extends StatefulWidget {
  final TodoEntity entity;

  TodoItemDetailDialog({this.entity});

  @override
  TodoItemDetailDialogState createState() =>
      new TodoItemDetailDialogState(entity);
}

class TodoItemDetailDialogState extends State<TodoItemDetailDialog> {
  final TodoEntity entity;

  TodoItemDetailDialogState(this.entity);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Text(entity.title),
    );
  }
}
