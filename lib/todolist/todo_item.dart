import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertodoapp/model/TodoEntity.dart';

class TodoItem extends StatelessWidget {
  const TodoItem(this.entity)
      : assert(entity != null),
        super();
  final TodoEntity entity;

  @override
  Widget build(BuildContext context) {
    return Text(
      "${entity.title} : ${entity.id}",
      style: TextStyle(
          fontSize: 20,
          color: Colors.indigoAccent,
          fontWeight: FontWeight.normal),
    );
  }
}
