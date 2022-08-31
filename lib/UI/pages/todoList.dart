import 'package:flutter/material.dart';
import 'package:todo_firebase/UI/widgets/loading.dart';
import 'package:todo_firebase/services/database_services.dart';

import '../../models/todo.dart';

class TodoListPage extends StatefulWidget {
  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  bool isComplete = false;
  TextEditingController titleContr = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<List<Todo>>(
            stream: DatabaseService().listTodos(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Loading();
              }
              List<Todo> todos = snapshot.data;
              return Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "All Todos",
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Divider(
                      color: Colors.grey[600],
                    ),
                    const SizedBox(height: 20),
                    ListView.separated(
                      separatorBuilder: (context, index) => Divider(
                        color: Colors.grey[800],
                      ),
                      shrinkWrap: true,
                      itemCount: todos.length,
                      itemBuilder: (context, index) {
                        return Dismissible(
                          key: Key(todos[index].title),
                          background: Container(
                            padding: const EdgeInsets.only(left: 20),
                            alignment: Alignment.centerLeft,
                            child: Icon(Icons.delete),
                            color: Colors.red,
                          ),
                          onDismissed: (direction) async {
                            await DatabaseService()
                                .removeTodo(todos[index].uid);
                            //
                          },
                          child: ListTile(
                            onTap: () {
                              DatabaseService().completeTask(todos[index].uid);
                            },
                            leading: Container(
                                padding: const EdgeInsets.all(2),
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  shape: BoxShape.circle,
                                ),
                                child: todos[index].isComplete
                                    ? const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                      )
                                    : Container),
                            title: Text(
                              todos[index].title,
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.grey[200],
                                fontWeight: FontWeight.w600,
                                decoration: todos[index].isComplete
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  ],
                ),
              );
            }),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => (SimpleDialog(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 26, vertical: 20),
              backgroundColor: Colors.grey[800],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Row(
                children: [
                  const Text(
                    "Add Todo",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.cancel,
                      color: Colors.grey,
                      size: 30,
                    ),
                  ),
                ],
              ),
              children: [
                const Divider(),
                TextFormField(
                  controller: titleContr,
                  style: const TextStyle(
                      color: Colors.white, height: 1.5, fontSize: 20),
                  autofocus: true,
                  decoration: const InputDecoration(
                      hintText: "Masukkan Tugas",
                      hintStyle: TextStyle(color: Colors.white70),
                      border: InputBorder.none),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 50,
                  width: width,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      primary: Colors.blue,
                    ),
                    onPressed: () async {
                      if (titleContr.text.isNotEmpty) {
                        await DatabaseService()
                            .createNewTodo(titleContr.text.trim());
                        Navigator.pop(context);
                      }
                    },
                    child: const Text("Add"),
                  ),
                )
              ],
            )),
          );
        },
      ),
    );
  }
}
