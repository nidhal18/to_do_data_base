import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_data_base/todo.dart';


class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  TodoListScreenState createState() => TodoListScreenState();
}

class TodoListScreenState extends State<TodoListScreen> {
  final _todoController = TextEditingController();
  late Box<Todo> _todoBox;

  @override
  void initState() {
    super.initState();
    _todoBox = Hive.box<Todo>('todos');
  }

  void _addTodo() {
    final todoText = _todoController.text;
    if (todoText.isEmpty) return;
    final todo = Todo(task: todoText);
    _todoBox.add(todo);
    _todoController.clear();
    setState(() {});
  }

  void _toggleCompletion(int index) {
    final todo = _todoBox.getAt(index);
    todo!.isCompleted = !todo.isCompleted;
    todo.save();
    setState(() {});
  }

  void _deleteTodo(int index) {
    _todoBox.deleteAt(index);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do List'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _todoController,
              decoration: const InputDecoration(
                labelText: 'Enter new task',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _addTodo,
            child: const Text('Add Task'),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: _todoBox.listenable(),
              builder: (context, Box<Todo> box, _) {
                final todos = box.values.toList();
                return ListView.builder(
                  itemCount: todos.length,
                  itemBuilder: (context, index) {
                    final todo = todos[index];
                    return ListTile(
                      title: Text(
                        todo.task,
                        style: TextStyle(
                          decoration: todo.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      leading: Checkbox(
                        value: todo.isCompleted,
                        onChanged: (_) => _toggleCompletion(index),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteTodo(index),
                      ),
                    );
                    },
                  );
                }),
          )
        ],
      ),
    );
  }
}
