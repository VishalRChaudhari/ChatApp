import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var _enteredMessage = TextEditingController();
  final user = FirebaseAuth.instance.currentUser!;

  @override
  void dispose() {
    _enteredMessage.dispose();
    super.dispose();
  }

  void _submitMessage() async {
    var message = _enteredMessage.text;
    if (message.trim().isEmpty) {
      return;
    }
    _enteredMessage.clear();
    FocusScope.of(context).unfocus();

    final userData = await FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .get();

    FirebaseFirestore.instance.collection('chat').add({
      'Message': message,
      'Username ': userData.data()!['UserName'],
      'UserImage': userData.data()!['ImageURL'],
      'CreatedAt': Timestamp.now(),
      'userID': user.uid,
    });
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
