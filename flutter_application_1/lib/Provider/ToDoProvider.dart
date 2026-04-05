import 'package:flutter/material.dart';
import '../Database/db_helper_Bai2.dart'; // Đảm bảo đúng tên file của bro
import '../Model/Todo.dart';

class TodoProvider extends ChangeNotifier {
  List<TodoItem> _todos = [];
  List<TodoItem> get todos => _todos;

  Future<void> loadTodos() async {
    _todos = await DatabaseHelper.instance.getTodos();
    notifyListeners();
  }

  Future<void> addTodo(TodoItem todo) async {
    await DatabaseHelper.instance.insertTodo(todo);
    loadTodos();
  }

  Future<void> deleteTodo(int id) async {
    await DatabaseHelper.instance.deleteTodo(id);
    loadTodos();
  }

  Future<void> toggleTodoStatus(TodoItem todo) async {
    // Đảo ngược trạng thái hiện tại
    final updatedTodo = TodoItem(
      id: todo.id,
      title: todo.title,
      content: todo.content,
      isCompleted: !todo.isCompleted,
    );
    await DatabaseHelper.instance.updateTodo(updatedTodo);
    loadTodos();
  }
}