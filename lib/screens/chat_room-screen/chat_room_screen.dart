import 'package:flutter/material.dart';

class ChatRoomScreen extends StatelessWidget {
  const ChatRoomScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Chat Room '),
      ),
      body: StreamBuilder(
        builder: (context, snap) {
          return const Text('Chat Stream');
        },
      ),
    );
  }
}
