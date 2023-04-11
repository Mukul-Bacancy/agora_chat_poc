import 'package:agora_chat_poc/agora_constants.dart';
import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:dio/dio.dart';

// class AgoraChatConfig {
//   static const String appKey = "41748750#984614";
//   static const String userId = "test_user_id_01";
//   static const String agoraToken =
//       '007eJxTYOha1hB20//LnejkW6eXHDB9tdrgfY+64o9jK61u7n+aY6+nwGBkkZSYmpZmbpRskGpimWpuYWyUmJaaZGGQYpFsYmph+WOXXkpDICPDy1JJZkYGVgZGIATxVRjSDC3NDY1TDXRTjC2MdQ0NU1N0E40TDXRNDBNNUo2T04xMEs0B9n4q2w==';
// }

class AgoraChatSDKServices {
  final Dio dio = Dio();

  //Default dio config

  //Initializes the agora SDK
  initAgoraChatSDK() async {
    ChatOptions options = ChatOptions(
      appKey: AgoraConstants.appKey,
      autoLogin: false,
    );
    await ChatClient.getInstance.init(options);
  }

  //Logs in user in agora console
  signInUserInAgoraChatSdk() async {
    try {
      await ChatClient.getInstance.loginWithAgoraToken(
        AgoraConstants.testUserID_001,
        AgoraConstants.testUserToken,
      );
      print('Sign in success');
    } on ChatError catch (e) {
      print(e.code);
      print('Sign in failed');
    }
  }

  //Logs out user from agora console
  signOutUserInAgoraChatSdk() async {
    ///Todo: sign out user from agora Chat sdk.
    try {
      await ChatClient.getInstance.logout(true);
      print('Sign out success');
    } on ChatError catch (e) {
      print('Sign out failed');
    }
  }

  createSuperAdminService({
    required String username,
    required String bearerToken,
  }) async {
    try {
      // dio.options.baseUrl =
      //     'https://${AgoraConstants.host}/${AgoraConstants.orgName}/${AgoraConstants.appName}';
      dio.options.headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${AgoraConstants.chatAppToken}'
      };

      var response = await dio.post(
        "https://a41.chat.agora.io/41748750/984614/chatrooms/super_admin",
        data: {
          'superadmin': AgoraConstants.testUserID_001,
        },
      );
      if (response.statusCode == 200) {
        print(response.statusCode);
      }
    } on DioError catch (e) {
      print('Failed to make super admin');
      print(e.error);
    }
  }

  createLiveChatRoom() async {
    ///Todo : creates a live chat room.
    try {
      // dio.options.baseUrl =
      //     'https://${AgoraConstants.host}/${AgoraConstants.orgName}/${AgoraConstants.appName}';
      dio.options.headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${AgoraConstants.chatAppToken}'
      };

      var response = await dio.post(
        "https://a41.chat.agora.io/41748750/984614/chatrooms",
        data: {
          "name": "testchatroom001",
          "description": "test",
          "maxusers": 300,
          "owner": AgoraConstants.testUserID_001,
          "members": [
            AgoraConstants.testUserID_002,
          ]
        },
      );
      if (response.statusCode == 200) {
        print(response.data);
      }
    } on DioError catch (e) {
      print(e.message);
    }
  }

  destroyChatRoom({required String chatRoomID}) async {
    try {
      dio.options.headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${AgoraConstants.chatAppToken}'
      };

      var response = await dio.delete(
        "https://a41.chat.agora.io/41748750/984614/chatrooms/$chatRoomID",
      );
      if (response.statusCode == 200) {
        print(response.data);
      }
    } on DioError catch (e) {
      print(e.message);
    }
  }

  removeFromSuperAdmin({
    required String username,
  }) async {
    try {
      // dio.options.baseUrl =
      //     'https://${AgoraConstants.host}/${AgoraConstants.orgName}/${AgoraConstants.appName}';
      dio.options.headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${AgoraConstants.chatAppToken}'
      };

      var response = await dio.delete(
        "https://a41.chat.agora.io/41748750/984614/chatrooms/super_admin/${AgoraConstants.testUserID_001}",
      );
      if (response.statusCode == 200) {
        print(response.data);
      }
    } on DioError catch (e) {
      print(e.message);
    }
  }

  sendMessageInChatRoom() async* {
    ///Todo:  send message in a chat room.
  }

  receiveMessageInChatRoom() async* {
    ///Todo: receive messages in chat room sent by others.
  }
}
