import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'task_dialog.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box('taskBox');

    return Scaffold(
      appBar: AppBar(
        title: const Text('My To-Do List'),
      ),
      // READ: the list rebuilds whenever the box changes
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box taskBox, child) {
          if (taskBox.isEmpty) {
            return const Center(
              child: Text(
                'No tasks yet. Tap + to add one.',
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          return ListView.builder(
            itemCount: taskBox.length,
            itemBuilder: (context, index) {
              final key = taskBox.keyAt(index);
              final task = taskBox.get(key);

              // "?? ''" keeps older saved tasks from crashing
              String title = task['title'] ?? '';
              String description = task['description'] ?? '';
              String date = task['date'] ?? '';
              String time = task['time'] ?? '';

              // Build the subtitle text
              String subtitle = '';
              if (description.isNotEmpty) {
                subtitle = '$description\n';
              }
              subtitle = subtitle + '$date at $time';

              // DELETE: swipe to remove from the list and the box
              return Dismissible(
                key: ValueKey(key),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.white,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.delete, color: Colors.black),
                ),
                onDismissed: (direction) {
                  taskBox.delete(key);
                },
                child: Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text(
                      title,
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      subtitle,
                      style: const TextStyle(color: Colors.white70),
                    ),
                    isThreeLine: description.isNotEmpty,
                    trailing: const Icon(Icons.edit, color: Colors.white),
                    // UPDATE: tap to edit
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => TaskDialog(taskKey: key, task: task),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      // CREATE: FAB opens the form dialog
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const TaskDialog(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
