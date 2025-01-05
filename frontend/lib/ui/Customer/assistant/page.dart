import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../commons/nav_bar/NavBar.dart';

// Update with the actual path to the NavBar file

void main() {
  runApp(ChatApp());
}

class ChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: NavBar(
        bodyContent: ChatScreen(),
        title: 'Chat',
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<Map<String, String>> _messages = [];

  final String apiUrl = 'http://192.168.0.157:5500/chat';
  String _selectedLang = '1';

  void _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add({'sender': 'user', 'message': text});
    });

    _textController.clear();

    try {
      final response = await http.post(
        Uri.parse('$apiUrl?lang=$_selectedLang'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': 'john_smith',
          'query': text,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final botMessage = responseData['response'];

        setState(() {
          _messages.add({'sender': 'bot', 'message': botMessage});
        });
      } else {
        setState(() {
          _messages.add({
            'sender': 'bot',
            'message': 'Failed to fetch response. Please try again later.',
          });
        });
      }
    } catch (e) {
      setState(() {
        _messages.add({
          'sender': 'bot',
          'message': 'Error connecting to the server. Please try again later.',
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButton<String>(
          value: _selectedLang,
          onChanged: (String? newValue) {
            setState(() {
              _selectedLang = newValue!;
            });
          },
          items: [
            DropdownMenuItem(value: '1', child: Text('English')),
            DropdownMenuItem(value: '2', child: Text('Kannada')),
            DropdownMenuItem(value: '3', child: Text('Malyalam')),
          ],
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              final message = _messages[index];
              final isUserMessage = message['sender'] == 'user';

              return Align(
                alignment: isUserMessage
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isUserMessage ? Colors.blue : Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    message['message']!,
                    style: TextStyle(
                      color: isUserMessage ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _textController,
                  decoration: InputDecoration(
                    hintText: 'Type your message...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: () => _sendMessage(_textController.text),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
