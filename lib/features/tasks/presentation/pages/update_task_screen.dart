import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scholar_mate/features/tasks/domain/services/update_task.dart';

class UpdateTaskScreen extends StatefulWidget {
  final Map<String, dynamic> task;

  const UpdateTaskScreen({super.key, required this.task});

  @override
  _UpdateTaskScreenState createState() => _UpdateTaskScreenState();
}

class _UpdateTaskScreenState extends State<UpdateTaskScreen> {
  late TextEditingController _taskTitleController;
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  bool _isLoading = false;
  final TaskUpdateService _taskService = TaskUpdateService();

  @override
  void initState() {
    super.initState();
    _taskTitleController = TextEditingController(text: widget.task['Tasktitle'] ?? '');
    _selectedDate = widget.task['dateTime'] != null
        ? (widget.task['dateTime'] as Timestamp).toDate()
        : DateTime.now();
    _selectedTime = TimeOfDay.fromDateTime(_selectedDate);
  }

  @override
  void dispose() {
    _taskTitleController.dispose();
    super.dispose();
  }

  Future<void> _updateTask() async {
    if (_taskTitleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task title cannot be empty')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      DateTime updatedDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      // Update task in Firestore
      await _taskService.updateTask(
          widget.task['id'], _taskTitleController.text, updatedDateTime);

      // Return true to indicate success
      Navigator.of(context).pop(true);
    } catch (e) {
      print('Failed to update task: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update task: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _pickTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Task'),
        backgroundColor: const Color.fromARGB(255, 1, 97, 205),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _taskTitleController,
                    decoration: const InputDecoration(labelText: 'Task Title'),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Text('Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}'),
                      ),
                      ElevatedButton(
                        onPressed: _pickDate,
                        child: const Text('Pick Date'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Text('Time: ${_selectedTime.format(context)}'),
                      ),
                      ElevatedButton(
                        onPressed: _pickTime,
                        child: const Text('Pick Time'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _updateTask,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: const Color(0xff1d3557),
                      ),
                      child: const Text('Update Task'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
