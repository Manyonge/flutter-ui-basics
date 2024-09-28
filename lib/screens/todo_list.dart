import 'dart:convert';

import 'package:fitness/models/todo_model.dart';
import 'package:fitness/screens/add_todo.dart';
import 'package:fitness/screens/edit_todo.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fitness/utils.dart'; // Add this import

class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  List items = [];
  bool isLoading = true;

  Future<void> fetchTodos() async {
    final url = 'https://api.nstack.in/v1/todos?page=1&limit=10';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json['items'] as List;

      setState(() {
        isLoading = false;
        items = result;
      });
      return;
    }
    if (mounted) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(
          context: context,
          message: 'An error occurred while fetching todos',
          isError: true);
    }
  }

  Future<void> deleteById(id) async {
    final url = 'https://api.nstack.in/v1/todos/${id}';
    final uri = Uri.parse(url);
    final response = await http.delete(uri);
    if (response.statusCode == 200) {
      fetchTodos();
    }
    if (mounted) {
      showSnackBar(
          context: context,
          message: 'An error occurred while fetching todos',
          isError: true);
    }
  }

  

  @override
  void initState() {
    super.initState();
    fetchTodos();
  }

  @override
  Widget build(BuildContext context) {
    void navigateAdd() {
      final route = MaterialPageRoute(builder: (context) => AddTodo());
      Navigator.push(context, route);
    }

    void navigateEdit(todo) {
      final route = MaterialPageRoute(builder: (context) => EditTodo(todo: todo as TodoModel,));
      Navigator.push(context, route);
    }


    return Scaffold(
      appBar: AppBar(
        title: Text('To Do List'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text('Add Todo'),
        onPressed: navigateAdd,
      ),
      body: Visibility(
        visible: isLoading,
        child: Center(
          child: CircularProgressIndicator(),
        ),
        replacement: RefreshIndicator(
          onRefresh: fetchTodos,
          child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index] as Map;
                return ListTile(
                  leading: CircleAvatar(
                    child: Text('${index + 1}'),
                  ),
                  title: Text(item['title']),
                  subtitle: Text(item['description']),
                  trailing: PopupMenuButton(
                    onSelected: (value) {
                      if (value == 'delete') {
                        deleteById(item['id']);
                      }
                      if (value == 'edit') {
                        navigateEdit(item);
                      }
                    },
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                          child: Text('Edit'),
                          value: 'edit',
                        ),
                        PopupMenuItem(child: Text('Delete'), value: 'delete'),
                      ];
                    },
                    icon: Icon(Icons.more_horiz),
                  ),
                );
              }),
        ),
      ),
    );
  }
}
