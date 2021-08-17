import 'package:flutter/material.dart';
import 'package:what_todo/database_helper.dart';
import 'package:what_todo/models/task.dart';
import 'package:what_todo/models/todo.dart';
import 'package:what_todo/widgets.dart';

class TaskPage extends StatefulWidget {
  final Task? task;

  TaskPage({this.task});
  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  DatabaseHelper _dbHelper = DatabaseHelper();

  int _taskId = 0;
  String? _taskTitle = "";

  late FocusNode _titleFocus;
  late FocusNode _descriptionFocus;
  late FocusNode _todoFocus;

  bool _contentVisible = false;

  @override
  void initState() {
    if (widget.task != null) {
      //Set visibilty true
      _contentVisible = true;

      _taskTitle = (widget.task as dynamic).title;
      _taskId = (widget.task as dynamic).id;
    }

    _titleFocus = FocusNode();
    _descriptionFocus = FocusNode();
    _todoFocus = FocusNode();

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _titleFocus.dispose();
    _descriptionFocus.dispose();
    _todoFocus.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 24.0,
                      bottom: 6.0,
                    ),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Image(
                              image: AssetImage(
                                  'assets/images/back_arrow_icon.png'),
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            focusNode: _titleFocus,
                            onSubmitted: (value) async {
                              //Check if field is empty
                              if (value != "") {
                                //Check of task is null
                                if (widget.task == null) {
                                  Task newTask = Task(title: value);

                                  _taskId = await _dbHelper.insertTask(newTask);
                                  print("New Task is added");
                                  print("TaskID $_taskId");
                                  setState(() {
                                    _contentVisible = true;
                                    _taskTitle = value;
                                  });
                                } else {
                                  print("Update the exisiting task");
                                  await _dbHelper.updateTaskTitle(
                                      _taskId, value);
                                  print("Task Updated");
                                }

                                _descriptionFocus.requestFocus();
                              }
                            },
                            controller: TextEditingController()
                              ..text = _taskTitle.toString(),
                            decoration: InputDecoration(
                              hintText: "Enter Task Title",
                              border: InputBorder.none,
                            ),
                            style: TextStyle(
                              fontSize: 26.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF211551),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Visibility(
                    visible: _contentVisible,
                    child: Padding(
                      padding: EdgeInsets.only(
                        bottom: 12.0,
                      ),
                      child: TextField(
                        focusNode: _descriptionFocus,
                        onSubmitted: (value) {
                          _todoFocus.requestFocus();
                          if (value != "") {
                            if (_taskId != 0) {
                              _dbHelper.updateTaskDescription(_taskId, value);
                              print("Description updated");
                            }
                          }
                        },
                        decoration: InputDecoration(
                            hintText: "Enter Description for the task....",
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 24.0)),
                      ),
                    ),
                  ),
                  // Expanded(
                  //   child: ListView(
                  //     children: [
                  //       Text("List View Text"),
                  //     ],
                  //   ),
                  // ),
                  Visibility(
                    visible: _contentVisible,
                    child: FutureBuilder(
                      initialData: [],
                      future: _dbHelper.getToDo(_taskId),
                      builder: (context, snapshot) {
                        return Expanded(
                          child: ListView.builder(
                            itemCount: (snapshot.data as dynamic).length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  //Switch the ToDo status
                                },
                                child: ToDoWidget(
                                  isDone: (snapshot.data as dynamic)[index]
                                              .isDone ==
                                          0
                                      ? false
                                      : true,
                                  text: (snapshot.data as dynamic)[index].title,
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  Visibility(
                    visible: _contentVisible,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.0,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 20.0,
                            height: 20.0,
                            margin: EdgeInsets.only(
                              right: 12.0,
                            ),
                            decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(6.0),
                                border: Border.all(
                                  color: Color(0xFF86829D),
                                  width: 1.5,
                                )),
                            child: Image(
                              image: AssetImage('assets/images/check_icon.png'),
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              focusNode: _todoFocus,
                              onSubmitted: (value) async {
                                if (value != "") {
                                  //Check of task is null
                                  if (widget.task != null) {
                                    DatabaseHelper _dbHelper = DatabaseHelper();

                                    ToDo newToDo = ToDo(
                                      title: value,
                                      isDone: 0,
                                      taskId: (widget.task as dynamic).id,
                                    );

                                    await _dbHelper.insertToDo(newToDo);
                                    print("Creating new ToDo");
                                    setState(() {});
                                  }
                                }
                              },
                              decoration: InputDecoration(
                                hintText: "Enter ToDo item...",
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Visibility(
                visible: _contentVisible,
                child: Positioned(
                  bottom: 24.0,
                  right: 24.0,
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 60.0,
                      height: 60.0,
                      decoration: BoxDecoration(
                        color: Color(0xFFFE3577),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Image(
                        image: AssetImage('assets/images/delete_icon.png'),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
