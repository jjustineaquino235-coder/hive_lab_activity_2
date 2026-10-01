import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Used for both adding a new task and editing an existing one.
// If taskKey is null, it adds. If not, it updates.
class TaskDialog extends StatefulWidget {
  final dynamic taskKey;
  final Map? task;

  const TaskDialog({super.key, this.taskKey, this.task});

  @override
  State<TaskDialog> createState() => _TaskDialogState();
}

class _TaskDialogState extends State<TaskDialog> {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      titleController.text = widget.task!['title'] ?? '';
      descriptionController.text = widget.task!['description'] ?? '';
      dateController.text = widget.task!['date'] ?? '';
      timeController.text = widget.task!['time'] ?? '';
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    dateController.dispose();
    timeController.dispose();
    super.dispose();
  }

  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      String month = picked.month.toString().padLeft(2, '0');
      String day = picked.day.toString().padLeft(2, '0');
      dateController.text = '${picked.year}-$month-$day';
    }
  }

  void saveTask() {
    if (!formKey.currentState!.validate()) {
      return;
    }

    final box = Hive.box('taskBox');
    final newTask = {
      'title': titleController.text.trim(),
      'description': descriptionController.text.trim(),
      'date': dateController.text,
      'time': timeController.text.trim(),
    };

    if (widget.taskKey == null) {
      box.add(newTask); // Create
    } else {
      box.put(widget.taskKey, newTask); // Update
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.taskKey != null;

    return AlertDialog(
      title: Text(isEditing ? 'Edit Task' : 'Add Task'),
      content: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Title cannot be empty';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: dateController,
                readOnly: true,
                onTap: pickDate,
                decoration: const InputDecoration(
                  labelText: 'Date',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please pick a date';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: timeController,
                keyboardType: TextInputType.datetime,
                decoration: const InputDecoration(
                  labelText: 'Time',
                  hintText: 'e.g. 3:30 PM or 15:30',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Time cannot be empty';
                  }
                  // Accepts 3:30 PM, 03:30pm, 15:30
                  final timeFormat = RegExp(r'^([01]?\d|2[0-3]):[0-5]\d\s?([AaPp][Mm])?$');
                  if (!timeFormat.hasMatch(value.trim())) {
                    return 'Use a format like 3:30 PM or 15:30';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: saveTask,
          child: Text(isEditing ? 'Update' : 'Save'),
        ),
      ],
    );
  }
}