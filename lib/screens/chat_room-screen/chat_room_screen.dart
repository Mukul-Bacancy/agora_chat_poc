import 'package:agora_chat_poc/agora_constants.dart';
import 'package:agora_chat_poc/controller.dart';
import 'package:agora_chat_poc/services/agora_chat_SDK_services.dart';
import 'package:flutter/material.dart';

class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen({Key? key}) : super(key: key);

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  AgoraController agoraController = AgoraController();
  AgoraChatSDKServices agoraChatSDKServices = AgoraChatSDKServices();

  @override
  void initState() {
    agoraController.addChatListener();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Room'),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(height: 10),
            TextField(
              decoration: const InputDecoration(
                hintText: "Enter message",
              ),
              onChanged: (msg) => agoraController.messageContent.value = msg,
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                agoraController.sendAChatRoomMessage(
                  AgoraConstants.testUserID_001,
                  AgoraConstants.chartRoomID,
                  agoraController.messageContent,
                );
              },
              child: const Text("SEND TEXT"),
            ),
            Flexible(
              child: ListView.builder(
                controller: agoraController.scrollController,
                itemBuilder: (_, index) {
                  return Text(agoraController.logText[index]);
                },
                itemCount: agoraController.logText.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
