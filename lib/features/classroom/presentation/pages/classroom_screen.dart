import 'package:flutter/material.dart';
import 'package:scholar_mate/mainPage/navigation.dart';

class ClassroomScreen extends StatefulWidget {
  const ClassroomScreen({super.key});

  @override
  State<ClassroomScreen> createState() => _ClassroomScreenState();
}

class _ClassroomScreenState extends State<ClassroomScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text(
          "Classroom",
          style: TextStyle(
            color: Colors.white
          ),
          ),
        backgroundColor: const Color.fromARGB(255, 1, 97, 205),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>const Navigation()));
          },
          ),
      ),
      body: const Center(
        
        child: Text("class room"),
      ),
    );
  }
}