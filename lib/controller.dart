import 'package:agora_chat_poc/agora_constants.dart';
import 'package:agora_chat_poc/services/agora_chat_SDK_services.dart';
import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AgoraController extends GetxController {
  var currentSuperAdmin = ''.obs;
  AgoraChatSDKServices agoraChatServices = AgoraChatSDKServices();
  ScrollController scrollController = ScrollController();
  var messageContent = ''.obs;
  var chatId = ''.obs;
  final List<String> logText = [];

  void createSuperAdmin() {
    agoraChatServices.createSuperAdminService(
        username: AgoraConstants.testUserID_001, bearerToken: AgoraConstants.chatAppToken);
  }

  void removeSuperAdmin() {
    agoraChatServices.removeFromSuperAdmin(
        username: AgoraConstants.testUserID_001);
  }

  void agoraChatUserSignIn() {
    agoraChatServices.signInUserInAgoraChatSdk();
  }

  void agoraChatUserSignOut() {
    agoraChatServices.signOutUserInAgoraChatSdk();
  }

  void createLiveChatRoom() async {
    agoraChatServices.createLiveChatRoom();
  }

  void destroyLiveChatRoom({
    required String chatRoomID,
  }) async {
    agoraChatServices.destroyChatRoom(
      chatRoomID: chatRoomID,
    );
  }

  void joinLiveChatRoom() async {}

  sendAChatRoomMessage(username,chatRoomID,message) {


   agoraChatServices.sendAChatRoomMessage(username: username, chatRoomID: chatRoomID,message: messageContent.value);
  }

  void addLogToConsole(String log) {
    logText.add("$_timeString: $log");

    scrollController.jumpTo(scrollController.position.maxScrollExtent);
  }

  String get _timeString {
    return DateTime.now().toString().split(".").first;
  }

  void addChatListener() {
    ChatClient.getInstance.chatManager.addEventHandler(
      "UNIQUE_HANDLER_ID",
      ChatEventHandler(onMessagesReceived: onMessagesReceived),
    );
  }

  void onMessagesReceived(List<ChatMessage> messages) {
    for (var msg in messages) {
      switch (msg.body.type) {
        case MessageType.TXT:
          {
            ChatTextMessageBody body = msg.body as ChatTextMessageBody;
            addLogToConsole(
              "receive text message: ${body.content}, from: ${msg.from}",
            );
          }
          break;
        case MessageType.IMAGE:
          {
            addLogToConsole(
              "receive image message, from: ${msg.from}",
            );
          }
          break;
        case MessageType.VIDEO:
          {
            addLogToConsole(
              "receive video message, from: ${msg.from}",
            );
          }
          break;
        case MessageType.LOCATION:
          {
            addLogToConsole(
              "receive location message, from: ${msg.from}",
            );
          }
          break;
        case MessageType.VOICE:
          {
            addLogToConsole(
              "receive voice message, from: ${msg.from}",
            );
          }
          break;
        case MessageType.FILE:
          {
            addLogToConsole(
              "receive image message, from: ${msg.from}",
            );
          }
          break;
        case MessageType.CUSTOM:
          {
            addLogToConsole(
              "receive custom message, from: ${msg.from}",
            );
          }
          break;
        case MessageType.CMD:
          {}
          break;
      }
    }
  }
}
