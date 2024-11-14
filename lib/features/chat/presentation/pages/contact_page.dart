import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:scholar_mate/mainPage/navigation.dart';

class ChatScreen extends StatefulWidget {
  final String contactId;

  const ChatScreen({super.key, required this.contactId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late String currentUserId;
  List<String> selectedMessages = []; // State variable for selected messages

  @override
  void initState() {
    super.initState();
    currentUserId = _auth.currentUser!.uid;
    initializeNotifications();
  }

  void initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<Map<String, dynamic>> fetchContactInfo() async {
    DocumentSnapshot contactSnapshot =
        await _firestore.collection('users').doc(widget.contactId).get();
    return contactSnapshot.data() as Map<String, dynamic>;
  }

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _firestore
          .collection('chats')
          .doc(getChatRoomId(currentUserId, widget.contactId))
          .collection('messages')
          .add({
        'senderId': currentUserId,
        'message': _messageController.text.trim(),
        'timestamp': FieldValue.serverTimestamp(),
      });

      _messageController.clear();
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> deleteSelectedMessages() async {
    for (String messageId in selectedMessages) {
      await _firestore
          .collection('chats')
          .doc(getChatRoomId(currentUserId, widget.contactId))
          .collection('messages')
          .doc(messageId)
          .delete();
    }

    setState(() {
      selectedMessages.clear(); // Clear selection after deletion
    });
  }

  String getChatRoomId(String id1, String id2) {
    return id1.hashCode <= id2.hashCode ? '${id1}_$id2' : '${id2}_$id1';
  }

  @override
  Widget build(BuildContext context) {
    double iconHeight = MediaQuery.of(context).size.height * 0.15;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: FutureBuilder<Map<String, dynamic>>(
          future: fetchContactInfo(),
          builder: (context, snapshot) {
            String title = ''; // Default title while loading
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                title = 'Error loading contact';
              } else {
                final contactData = snapshot.data!;
                title = contactData['name'] ?? 'Unknown';
              }
            }

            return AppBar(
              automaticallyImplyLeading: false,
              leading: Padding(
                padding: const EdgeInsets.only(top: 30),
                child: IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const Navigation()));
                  },
                  icon: const Icon(Icons.arrow_back),
                  color: Colors.white,
                ),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              flexibleSpace: ClipPath(
                clipper: AppBarClipper(),
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomLeft,
                      colors: [
                        Colors.blue,
                        Color.fromARGB(255, 4, 126, 226),
                        Color.fromARGB(255, 2, 105, 189),
                        Color.fromARGB(255, 1, 94, 170),
                      ],
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: MediaQuery.of(context).padding.top),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (selectedMessages.isNotEmpty) ...[
                            IconButton(
                              icon:
                                  const Icon(Icons.delete, color: Colors.white),
                              onPressed: deleteSelectedMessages,
                            ),
                          ],
                        ],
                      ),
                      if (snapshot.connectionState == ConnectionState.waiting)
                        const LinearProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                          backgroundColor: Colors.blueAccent,
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('chats')
                  .doc(getChatRoomId(currentUserId, widget.contactId))
                  .collection('messages')
                  .orderBy('timestamp')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                      child: Text(
                    "No messages yet",
                    style: TextStyle(color: Colors.grey),
                  ));
                }

                final messages = snapshot.data!.docs;

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message =
                        messages[index].data() as Map<String, dynamic>;
                    final isCurrentUser = message['senderId'] == currentUserId;
                    final isSelected = selectedMessages
                        .contains(messages[index].id); // Track selection

                    return GestureDetector(
                      onLongPress: () {
                        if (selectedMessages.isEmpty) {
                          setState(() {
                            selectedMessages.add(messages[index].id);
                          });
                        }
                      },
                      onTap: () {
                        if (selectedMessages.isNotEmpty) {
                          setState(() {
                            if (selectedMessages.contains(messages[index].id)) {
                              selectedMessages.remove(messages[index].id);
                            } else {
                              selectedMessages.add(messages[index].id);
                            }
                          });
                        }
                      },
                      child: Align(
                        alignment: isCurrentUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 14),
                          margin: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.blue[200]
                                : (isCurrentUser
                                    ? Colors.blue[100]
                                    : Colors.white),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            message['message'],
                            style: const TextStyle(
                                color: Colors.black87, fontSize: 16),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const Divider(
            height: 4,
            thickness: 4,
            color: Color.fromARGB(255, 1, 94, 170),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: const Color.fromARGB(255, 1, 94, 170),
                  radius: iconHeight * 0.18,
                  child: Image.asset(
                    "assets/logo1.png",
                    height: iconHeight * 0.2,
                    width: iconHeight * 0.2,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                    ),
                  ),
                ),
                IconButton(
                  icon:const Icon(
                    Icons.send,
                    color: Color.fromARGB(255, 1, 94, 170),
                  ),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 20);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 20);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
