import 'package:agora_chat_poc/agora_constants.dart';
import 'package:agora_chat_poc/services/agora_chat_SDK_services.dart';
import 'package:get/get.dart';

class AgoraController extends GetxController {
  var currentSuperAdmin = ''.obs;
  AgoraChatSDKServices agoraChatServices = AgoraChatSDKServices();



  void createSuperAdmin() {
    agoraChatServices.createSuperAdminService(
        username: 'test_user_id_001', bearerToken: AgoraConstants.chatAppToken);
  }

  void removeSuperAdmin() {
    agoraChatServices.removeFromSuperAdmin(username: AgoraConstants.testUserID_001);
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
  void destroyLiveChatRoom({required String chatRoomID,}) async {
    agoraChatServices.destroyChatRoom(chatRoomID: chatRoomID,);
  }
  void joinLiveChatRoom() async {

  }
}
