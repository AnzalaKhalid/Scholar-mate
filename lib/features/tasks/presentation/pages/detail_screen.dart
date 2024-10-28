import 'package:flutter/material.dart';
import 'package:scholar_mate/features/tasks/presentation/pages/update_task_screen.dart';

class TaskDetailScreen extends StatefulWidget {
  final Map<String, dynamic> task;

  const TaskDetailScreen({super.key, required this.task, required taskId});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Task Details",
          style: TextStyle(
            color: Colors.white
          ),
          ),
        backgroundColor: const Color.fromARGB(255, 1, 97, 205),
        leading: IconButton(
          color: Colors.white,
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 219, 218, 218),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.task['Tasktitle'] ?? 'No Title',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10), // Space between title and other details
            Text(
              'Date: ${widget.task['formattedDate'] ?? 'No Date'}',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            Text(
              'Time: ${widget.task['formattedTime'] ?? 'No Time'}',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            ElevatedButton(
              onPressed: () async {
                // Wait for the result from the UpdateTaskScreen
                bool? isUpdated = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UpdateTaskScreen(task: widget.task),
                  ),
                );

                // If the task was updated, refresh the screen
                if (isUpdated == true) {
                  // Reload task data (you may need to fetch from Firestore if needed)
                  // For simplicity, you can use setState in a StatefulWidget or reload task from the source
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Task updated!')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff1d3557), // Button color
              ),
              child: const Text("Edit Task"),
            ),
          ],
        ),
      ),
    );
  }
}
