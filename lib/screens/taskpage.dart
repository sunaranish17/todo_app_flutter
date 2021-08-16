import 'package:flutter/material.dart';
import 'package:what_todo/widgets.dart';

class TaskPage extends StatefulWidget {
  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
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
                          image:
                              AssetImage('assets/images/back_arrow_icon.png'),
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextField(
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
              Padding(
                padding: EdgeInsets.only(
                  bottom: 12.0,
                ),
                child: TextField(
                  decoration: InputDecoration(
                      hintText: "Enter Descriptio for the task....",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 24.0)),
                ),
              ),
              ToDoWidget(
                text: "ToDo Item",
                isDone: false,
              ),
              ToDoWidget(
                isDone: true,
              ),
              ToDoWidget(isDone: true),
              ToDoWidget(isDone: true),
            ],
          ),
        ),
      ),
    );
  }
}
