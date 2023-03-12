import 'package:flutter/material.dart';
import 'package:todo_app/screens/add_page.dart';
import 'package:todo_app/services/todo_service.dart';
import 'package:todo_app/utils/snackbar_helper.dart';
import 'package:todo_app/widget/todo_card.dart';

class ToDoListPage extends StatefulWidget {
  const ToDoListPage({super.key});

  @override
  State<ToDoListPage> createState() => _ToDoListPageState();
}

class _ToDoListPageState extends State<ToDoListPage> {
  bool isLoading = true;
  List items = [];

  @override
  void initState() {
    fetchTodo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To Do List'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: navigateToAddPage,
        label: const Text('Add todo'),
      ),
      body: Visibility(
        visible: isLoading,
        replacement: RefreshIndicator(
          onRefresh: fetchTodo,
          child: Visibility(
            visible: items.isNotEmpty,
            replacement: Center(
              child: Text(
                'No Todo item',
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
            child: ListView.builder(
              padding: const EdgeInsets.only(
                left: 5,
                right: 5,
                top: 5,
              ),
              itemBuilder: (context, index) {
                final item = items[index];
                return TodoCard(
                    index: index,
                    item: item,
                    navigateToEdit: navigateToEditPage,
                    deleteById: deleteById);
              },
              itemCount: items.length,
            ),
          ),
        ),
        child: const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Future<void> navigateToEditPage(Map item) async {
    final route = MaterialPageRoute(
      builder: (context) => AddToDoPage(todo: item),
    );

    await Navigator.push(context, route);

    setState(() {
      isLoading = true;
    });

    fetchTodo();
  }

  Future<void> navigateToAddPage() async {
    final route = MaterialPageRoute(
      builder: (context) => const AddToDoPage(),
    );

    await Navigator.push(context, route);

    setState(() {
      isLoading = true;
    });

    fetchTodo();
  }

  Future<void> deleteById(String id) async {
    //Delete the item
    final isSuccess = await TodoService.deleteById(id);
    if (isSuccess) {
      //Remove item from the list
      final filtered = items.where((element) => element['_id'] != id).toList();
      setState(() {
        items = filtered;
      });
    } else {
      //Show error
      showSnackbar(context, Colors.red, message: 'Deletion failed');
    }
  }

  Future<void> fetchTodo() async {
    final response = await TodoService.fetchTodo();
    if (response != null) {
      setState(() {
        items = response;
      });
    } else {
      showSnackbar(context, Colors.red, message: 'Something went wrong');
    }
    setState(() {
      isLoading = false;
    });
  }
}
