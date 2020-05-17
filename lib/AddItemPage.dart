import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertodoapp/model/TodoEntity.dart';

class AddItemPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddItemPageState();
  }
}

class AddItemPageState extends State<AddItemPage> {
  @override
  Widget build(BuildContext context) {
    AddNoteContentForm noteContentForm = AddNoteContentForm();
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            title: Text("Add Note"),
            actions: <Widget>[
              Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context, noteContentForm.getTodoEntity());
                    },
                    child: Icon(
                      Icons.check,
                      size: 26.0,
                    ),
                  ))
            ],
          ),
          body: noteContentForm,
        ),
        onWillPop: _onBackPressed);
  }

  Future<bool> _onBackPressed() {
    return showDialog(
        context: this.context, child: createAlertDialog(this.context));
  }

  createAlertDialog(BuildContext context) {
    return AlertDialog(
      title: Text("Exit"),
      content: Text("Do you want to discard changes"),
      actions: <Widget>[
        MaterialButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
          elevation: 4.0,
          child: Text("Yes"),
        ),
        MaterialButton(
          onPressed: () {
            //Navigator.pop(context);
            Navigator.pop(context);
          },
          elevation: 4.0,
          child: Text("No"),
        ),
      ],
    );
  }
}

class AddNoteContentForm extends StatefulWidget {
  final state = _MyCustomFormState();

  TodoEntity getTodoEntity() {
    String title = state.titleController.text.trim().toString();
    String content = state.contentController.text.trim().toString();
    if (title.isEmpty) {
      title = "Empty Title";
    }
    return TodoEntity(title: title, content: content);
  }

  @override
  State<StatefulWidget> createState() {
    return state;
  }
}

class _MyCustomFormState extends State<AddNoteContentForm> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              color: Colors.lightBlueAccent,
              borderRadius: BorderRadius.circular(10)),
          margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
          child: TextField(
            autocorrect: true,
            enableSuggestions: true,
            controller: titleController,
            minLines: 1,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
              hintText: "Title",
              hintStyle: TextStyle(color: Colors.white),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
              color: Colors.lightBlue, borderRadius: BorderRadius.circular(10)),
          margin: EdgeInsets.only(left: 10, right: 10, top: 5),
          child: TextField(
            autocorrect: true,
            enableSuggestions: true,
            minLines: 4,
            maxLength: 200,
            maxLengthEnforced: true,
            controller: contentController,
            maxLines: 10,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
              hintText: "Note description",
              hintStyle: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
