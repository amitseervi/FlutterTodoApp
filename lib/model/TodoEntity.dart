class TodoEntity {
  final int id;
  final String title;
  final String content;

  TodoEntity({this.id, this.title, this.content});

  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'content': content};
  }

  static TodoEntity fromMap(Map<String, dynamic> map) {
    return TodoEntity(
        id: map['id'], title: map['title'], content: map['content']);
  }

  @override
  String toString() {
    return 'TodoEntity{id: $id, title: $title, content: $content}';
  }
}
