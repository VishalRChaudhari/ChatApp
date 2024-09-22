import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var _enteredMessage = TextEditingController();

  @override
  void dispose() {
    _enteredMessage.dispose();
    super.dispose();
  }

  void _submitMessage() {
    var message = _enteredMessage.text;
    if (message.trim().isEmpty) {
      return;
    }

    // firebase send

    _enteredMessage.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 1, bottom: 14),
      child: Center(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _enteredMessage,
                autocorrect: true,
                enableSuggestions: true,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  label: Text('Send a message...'),
                ),
              ),
            ),
            IconButton(
              onPressed: _submitMessage,
              icon: const Icon(Icons.send),
              color: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}
