class ToDo {
  final int id;
  final String title;
  final int isDone;

  ToDo({required this.id, required this.title, required this.isDone});

  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'isDone': isDone};
  }
}
