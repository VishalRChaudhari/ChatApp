import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasechat/Widgets/chat_bubble.dart';
import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  const ChatMessage({super.key});

  @override
  Widget build(BuildContext context) {
    final authenticatedUser = FirebaseAuth.instance.currentUser!;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('CreatedAt', descending: true)
          .snapshots(),
      builder: (ctx, chatSnapshots) {
        if (chatSnapshots.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (!chatSnapshots.hasData || chatSnapshots.data!.docs.isEmpty) {
          return const Center(
            child: Text('No messages found.'),
          );
        }

        if (chatSnapshots.hasError) {
          return const Center(
            child: Text('Something went wrong...'),
          );
        }

        final loadedMessages = chatSnapshots.data!.docs;
        return ListView.builder(
          padding: const EdgeInsets.only(
            bottom: 30,
            left: 12,
            right: 12,
          ),
          reverse: true,
          itemCount: loadedMessages.length,
          itemBuilder: (ctx, index) {
            final chatMessage = loadedMessages[index].data();
            final nextMessage = index + 1 < loadedMessages.length
                ? loadedMessages[index + 1].data()
                : null;
            final currenMessagetUserID = chatMessage['userID'];
            final nextMessageUserID =
                nextMessage != null ? nextMessage['userID'] : null;

            final nextUserisSame = nextMessageUserID == currenMessagetUserID;
            if (nextUserisSame) {
              return MessageBubble.next(
                  message: chatMessage['Message'],
                  isMe: authenticatedUser.uid == currenMessagetUserID);
            } else {
              return MessageBubble.first(
                  userImage: chatMessage['UserImage'],
                  username: chatMessage['Username'],
                  message: chatMessage['Message'],
                  isMe: authenticatedUser.uid == currenMessagetUserID);
            }
          },
        );
      },
    );
  }
}
