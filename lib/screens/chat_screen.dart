import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final TextEditingController _inputController = TextEditingController();
  final List<Map<String, String>> _messages = []; // [text, sender]

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_inputController.text.isNotEmpty) {
      setState(() {
        _messages.add({'text': _inputController.text, 'sender': 'user'});
        _messages.add({
          'text': 'Je suis SmartChick, créé par xxx. Réponse à : "${_inputController.text}"\nJe suis ici pour aider !',
          'sender': 'ai'
        });
        _inputController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Discussion avec l\'IA'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(8.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUser = message['sender'] == 'user';
                return Align(
                  alignment: isUser ? Alignment.centerLeft : Alignment.centerRight,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                    padding: EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.grey[300] : Colors.green[100],
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Text(
                      message['text']!,
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _inputController,
                    decoration: InputDecoration(
                      hintText: 'Tapez votre message...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                SizedBox(width: 8.0),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.green),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}