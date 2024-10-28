import 'package:flutter/material.dart';

class Personalinfo extends StatefulWidget {
  const Personalinfo({super.key});

  @override
  State<Personalinfo> createState() => _PersonalinfoState();
}

class _PersonalinfoState extends State<Personalinfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration:const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF015DA9),
              Color(0xFF016BC1),
              Color(0xFF027FE6),
              Color(0xFF028AF9),
            ],
            )
        ),
        child: const Column(
          children: [
            SizedBox(
              width: 350,
              child: Card(
              
              ),
            )
          ],
        ),
      ),
    );
  }
}