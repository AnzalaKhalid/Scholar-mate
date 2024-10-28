import 'package:flutter/material.dart';
import 'package:scholar_mate/features/tasks/domain/services/fetch_task.dart';
import 'package:scholar_mate/features/tasks/presentation/pages/create_task.dart';
import 'package:scholar_mate/features/tasks/presentation/pages/detail_screen.dart';
import 'package:scholar_mate/mainPage/navigation.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final TaskfetchService _taskService = TaskfetchService();
  final List<Map<String, dynamic>> tasks = [];
  List<Map<String, dynamic>> filteredTasks = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _retrieveTasks();
    _searchController.addListener(_filterTasks);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _retrieveTasks() async {
    try {
      List<Map<String, dynamic>> fetchedTasks = await _taskService.retrieveTasks();
      setState(() {
        tasks.clear();
        tasks.addAll(fetchedTasks);
        filteredTasks = tasks;
      });
    } catch (e) {
      print('Error occurred while fetching tasks: $e');
    }
  }

  void _filterTasks() {
    String searchTerm = _searchController.text.toLowerCase();
    setState(() {
      filteredTasks = tasks.where((task) {
        String taskTitle = task['Tasktitle']?.toString().toLowerCase() ?? '';
        return taskTitle.contains(searchTerm);
      }).toList();
    });
  }

  void _confirmDeleteTask(String taskId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          title: const Text("Confirm Deletion", style: TextStyle(fontWeight: FontWeight.bold)),
          content: const Text(
            "Are you sure you want to delete this task?",
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                _deleteTask(taskId); // Delete task on confirmation
                Navigator.of(context).pop(); // Close the dialog
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              ),
              child: const Text("Delete", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteTask(String taskId) async {
    try {
      await _taskService.deleteTask(taskId);
      setState(() {
        filteredTasks.removeWhere((task) => task['id'] == taskId);
      });
    } catch (e) {
      debugPrint('Failed to delete task: $e');
    }
  }

  Future<void> _addTask() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const AddTaskScreen()),
    );

    if (result == true) {
      _retrieveTasks(); // Refresh the task list if a task was added
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Tasks",
          style: TextStyle(
            color: Colors.white
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 1, 97, 205),
        automaticallyImplyLeading: false,
        leading: IconButton(
          color: Colors.white,
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const Navigation()));
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 219, 218, 218),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: EdgeInsets.all(screenWidth * 0.04), // Responsive padding
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search tasks...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(vertical: screenHeight * 0.02, horizontal: screenWidth * 0.04), // Responsive content padding
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: const BorderSide(color: Color(0xff1d3557), width: 2.0),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          _searchController.clear();
                        },
                      )
                    : null,
              ),
            ),
          ),
          // Task List or Placeholder
          Expanded(
            child: filteredTasks.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inbox_rounded, size: 100, color: Colors.grey.shade400),
                        const SizedBox(height: 16),
                        Text(
                          'No tasks added yet',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredTasks.length,
                    itemBuilder: (BuildContext context, int index) {
                      final task = filteredTasks[index];
                      return GestureDetector(
                        onTap: () async {
                          bool? isUpdated = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TaskDetailScreen(
                                task: task,
                                taskId: null,
                              ),
                            ),
                          );

                          if (isUpdated == true) {
                            _retrieveTasks();
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01, horizontal: screenWidth * 0.04), // Responsive padding
                          child: Row(
                            children: [
                              Expanded(
                                child: Card(
                                  color: Colors.blue,
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(screenWidth * 0.04), // Responsive padding
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          task['Tasktitle'] ?? '',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          children: [
                                            Text(
                                              task['formattedDate'] ?? '',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.white,
                                              ),
                                            ),
                                            const SizedBox(width: 120),
                                            Text(
                                              task['formattedTime'] ?? '',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.redAccent),
                                onPressed: () => _confirmDeleteTask(task['id']),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        backgroundColor: const Color(0xff1d3557),
        child: const Icon(Icons.add),
      ),
    );
  }
}
