
import 'dart:convert';
import 'package:fitness/utils.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class EditTodo extends StatefulWidget {
  final  todo;  
    const EditTodo({super.key, required this.todo});

  @override
  State<EditTodo> createState() => _EditTodoState();
}

class _EditTodoState extends State<EditTodo> {

  TextEditingController titleController = TextEditingController();

  TextEditingController descriptionController = TextEditingController();

  Future<void> edititTodo() async {
    FocusScope.of(context).unfocus();
    final title = titleController.text;
    final description = descriptionController.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false,
    };
    final url = 'https://api.nstack.in/v1/todos/${widget.todo.id}';
    final uri = Uri.parse(url);
    final response = await http.put(uri,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 201) {
      if (mounted) {
        showSnackBar(
          message: 'Todo created successfully',
          context: context,
        );
      }
      titleController.text = '';
      descriptionController.text = '';
      return;
    }
    if (mounted) {
      showSnackBar(
        message: 'There was an error ${response.body.toString()}',
        isError: true,
        context: context,
      );
    }
  }

@override
void initState(){
  super.initState();
  setState(() {
    titleController.text = widget.todo.title;
    descriptionController.text = widget.todo.description;
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Todo'),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(hintText: 'Title'),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: descriptionController,
            keyboardType: TextInputType.multiline,
            maxLines: 8,
            minLines: 5,
            decoration: InputDecoration(hintText: 'Description'),
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(onPressed: edititTodo, child: Text('Edit'))
        ],
      ),
    );
  }
}

