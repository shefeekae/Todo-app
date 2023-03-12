import 'package:flutter/material.dart';
import 'package:todo_app/services/todo_service.dart';
import 'package:todo_app/utils/snackbar_helper.dart';

class AddToDoPage extends StatefulWidget {
  final Map? todo;
  const AddToDoPage({super.key, this.todo});

  @override
  State<AddToDoPage> createState() => _AddToDoPageState();
}

class _AddToDoPageState extends State<AddToDoPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      final title = todo['title'];
      final description = todo['description'];
      titleController.text = title;
      descriptionController.text = description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Todo' : 'Add Todo'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(hintText: "Title"),
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(hintText: "Description"),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
              onPressed: isEdit ? updateData : submitData,
              child: Text(isEdit ? 'Update' : 'Submit'))
        ],
      ),
    );
  }

  Future<void> updateData() async {
    // Get data from form

    final todo = widget.todo;
    if (todo == null) {
      print('You cannot update without todo');
      return;
    }

    final id = todo['_id'];
    final isCompleted = todo['is_completed'];
    final title = titleController.text;
    final description = descriptionController.text;

    final body = {
      "title": title,
      "description": description,
      "is_completed": false,
    };

    // Submit updated data to the server

    final isSuccess = await TodoService.updateTodo(id, body);

    //Show success or failure message based on status

    if (isSuccess) {
      titleController.text = '';
      descriptionController.text = '';

      showSnackbar(context, Colors.green, message: 'Updation Success');
    } else {
      showSnackbar(context, Colors.red, message: 'Updation failed');
    }
  }

  Future<void> submitData() async {
    // Get data from form
    final title = titleController.text;
    final description = descriptionController.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false
    };

    // Submit data to the server
    final isSuccess = await TodoService.addTodo(body);

    //Show success or failure message based on status
    if (isSuccess) {
      titleController.text = '';
      descriptionController.text = '';

      showSnackbar(context, Colors.green, message: 'Creation Success');
    } else {
      showSnackbar(context, Colors.red, message: 'Creation failed');
    }
  }
}
