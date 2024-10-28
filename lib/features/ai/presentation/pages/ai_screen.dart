import 'package:flutter/material.dart';
// import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AiScreen extends StatefulWidget {
  const AiScreen({super.key});

  @override
  _AiScreenState createState() => _AiScreenState();
}

class _AiScreenState extends State<AiScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, String>> messages = [];

  Future<void> sendMessage(String message) async {
    setState(() {
      messages.add({"data": "You", "message": message});
    });
    _controller.clear();

    // Define your Rasa server URL here
    var url = Uri.parse('http://localhost:5005/webhooks/rest/webhook');
    
    try {
      var response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({"sender": "user", "message": message}),
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data.isNotEmpty) {
          setState(() {
            for (var msg in data) {
              messages.add({"data": "Bot", "message": msg["text"]});
            }
          });
        }
      } else {
        setState(() {
          messages.add({
            "data": "Bot",
            "message": "Oops! Something went wrong. Try again later."
          });
        });
      }
    } catch (e) {
      setState(() {
        messages.add({
          "data": "Bot",
          "message": "Could not connect to the server. Please check your connection."
        });
      });
    }
  }

  Widget buildMessage(String sender, String message) {
    return Align(
      alignment: sender == "You" ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: sender == "You" ? Colors.blue[100] : Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          "$sender: $message",
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return buildMessage(
                    messages[index]["data"]!, messages[index]["message"]!);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Enter your message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      sendMessage(_controller.text);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}