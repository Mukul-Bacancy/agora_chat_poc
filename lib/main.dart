import 'package:agora_chat_poc/agora_constants.dart';
import 'package:agora_chat_poc/controller.dart';
import 'package:agora_chat_poc/screens/chat_room-screen/chat_room_screen.dart';
import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SignInPage(),
    );
  }
}

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final Dio dio = Dio();

  @override
  void initState() {
    initAgoraChatSDK();
    getAgoraChatAppToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Username',
                ),
                onChanged: (name) => AgoraConstants.testUserID_001 = name,
              ),
              TextField(
                decoration: const InputDecoration(
                  hintText: 'User Token',
                ),
                onChanged: (token) => AgoraConstants.testUserToken = token,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const MyHomePage(title: 'Agora'),
                        ),
                      );
                    },
                    child: const Text('Sign In'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  //Initializes the agora SDK
  initAgoraChatSDK() async {
    ChatOptions options = ChatOptions(
      appKey: AgoraConstants.appKey,
      autoLogin: false,
    );
    await ChatClient.getInstance.init(options);
  }

  getAgoraChatAppToken() async {
    try {
      var response = await dio.post(
        AgoraConstants.chatAppTokenGeneratorUrl,
        data: {'data': ''},
      );
      AgoraConstants.chatAppToken = response.data['result']['data']['token'];
      print(response.data['result']['data']['token']);
    } on Exception catch (e) {
      print(e);
    }
  }

  getAgoraUserToken({
    required String agoraUsername,
  }) async {
    try {
      var response = await dio.post(
        AgoraConstants.userTokenGeneratorUrl,
        data: {'data': ''},
      );
      AgoraConstants.testUserToken = response.data['result']['data']['token'];
      print(response.data['result']['data']['token']);
    } on Exception catch (e) {
      print(e);
    }
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // AgoraChatSDKServices agoraChatServices = AgoraChatSDKServices();

  //AgoraController agoraController = AgoraController();
  var messageContent = '';
  var chatId = '';
  List<String> logText = [];

  @override
  void initState() {
    // initAgoraChatSDK();
    addChatListener();
    addChatRoomEventsListener();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            // TextButton(
            //   onPressed: () {
            //    // getAgoraChatAppToken();
            //   },
            //   child: const Text('Generate chat app token'),
            // ),
            TextButton(
              onPressed: () {
                getAgoraUserToken(
                  agoraUsername: AgoraConstants.testUserID_001,
                );
              },
              child: const Text('Generate user token'),
            ),
            TextButton(
              onPressed: () {
                signInUserInAgoraChatSdk();
              },
              child: const Text('Sign In'),
            ),
            TextButton(
              onPressed: () {
                signOutUserInAgoraChatSdk();
              },
              child: const Text('Sign out'),
            ),
            OutlinedButton(
              onPressed: () {
                createSuperAdminService(
                    username: AgoraConstants.testUserID_001,
                    bearerToken: AgoraConstants.chatAppToken);
              },
              child: const Text('Make super admin'),
            ),
            ElevatedButton(
              onPressed: () {
                removeFromSuperAdmin(username: AgoraConstants.testUserID_001);
              },
              child: const Text('remove super admin'),
            ),
            OutlinedButton(
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => const ChatRoomScreen(),
                //   ),
                // );
                createLiveChatRoom();
              },
              child: const Text('Create Room'),
            ),
            ElevatedButton(
              onPressed: () {
                destroyChatRoom(chatRoomID: AgoraConstants.chartRoomID);
              },
              child: const Text('Delete Room'),
            ),
            ElevatedButton(
              onPressed: () {
                print(AgoraConstants.chartRoomID);
                joinAChatRoom(roomID: AgoraConstants.chartRoomID);
              },
              child: const Text('Join Room'),
            ),
            TextField(
              decoration: const InputDecoration(hintText: 'Enter Chat room ID'),
              onChanged: (chatRoomID) => AgoraConstants.chartRoomID = chatRoomID,
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: const InputDecoration(
                hintText: "Enter message",
              ),
              onChanged: (msg) => messageContent = msg,
            ),

            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                sendAChatRoomMessage(
                    username: AgoraConstants.testUserID_001,
                    chatRoomID: AgoraConstants.chartRoomID,
                    message: messageContent);
              },
              child: const Text("SEND TEXT"),
            ),


            Flexible(
              child: ListView.builder(
                //controller: agoraController.scrollController,
                itemBuilder: (_, index) {
                  return Text(logText[index]);
                },
                itemCount: logText.length,
              ),
            ),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void addLogToConsole(String log) {
    setState(() {
      logText.add("$_timeString: $log");
    });

    //scrollController.jumpTo(scrollController.position.maxScrollExtent);
  }

  String get _timeString {
    return DateTime.now().toString().split(".").first;
  }

  final Dio dio = Dio();

  //final AgoraController controller = AgoraController();

  //Initializes the agora SDK
  // initAgoraChatSDK() async {
  //   ChatOptions options = ChatOptions(
  //     appKey: AgoraConstants.appKey,
  //     autoLogin: false,
  //   );
  //   await ChatClient.getInstance.init(options);
  // }

  ///Token management callbacks

  // getAgoraChatAppToken() async {
  //   try {
  //     var response = await dio.post(
  //       AgoraConstants.chatAppTokenGeneratorUrl,
  //       data: {'data': ''},
  //     );
  //     AgoraConstants.chatAppToken = response.data['result']['data']['token'];
  //     print(response.data['result']['data']['token']);
  //   } on Exception catch (e) {
  //     print(e);
  //   }
  // }


  getAgoraUserToken({
    required String agoraUsername,
  }) async {
    try {
      var response = await dio.post(
        AgoraConstants.userTokenGeneratorUrl,
        data: {'data': ''},
      );
      AgoraConstants.testUserToken = response.data['result']['data']['token'];
      print(response.data['result']['data']['token']);
    } on Exception catch (e) {
      print(e);
    }
  }

  ///LogIn/Log out user to Agora callbacks

  //Logs in user in agora console
  signInUserInAgoraChatSdk() async {
    try {
      await ChatClient.getInstance.loginWithAgoraToken(
        AgoraConstants.testUserID_001,
        AgoraConstants.testUserToken,
      );
      addLogToConsole(
          "login succeed, userId: ${AgoraConstants.testUserID_001}");
    } on ChatError catch (e) {
      addLogToConsole("login failed, code: ${e.code}, desc: ${e.description}");
    }
  }

  //Logs out user from agora console
  signOutUserInAgoraChatSdk() async {
    try {
      await ChatClient.getInstance.logout(true);
      addLogToConsole("sign out succeed");
    } on ChatError catch (e) {
      addLogToConsole(
          "sign out failed, code: ${e.code}, desc: ${e.description}");
    }
  }

  ///Chat Room management callbacks

  createSuperAdminService({
    required String username,
    required String bearerToken,
  }) async {
    try {
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
    ///
    try {
      ChatRoom room = await ChatClient.getInstance.chatRoomManager
          .createChatRoom(AgoraConstants.agoraUsername);
      AgoraConstants.chartRoomID = room.roomId;
    } on ChatError catch (e) {
      print(e.description);
    }
  }

  joinAChatRoom({required String roomID}) async {
    try {
      print(roomID);
      await ChatClient.getInstance.chatRoomManager.joinChatRoom(roomID);
    } on ChatError catch (e) {
      print(e.description);

    }
  }

  addChatRoomMember(
      {required String chatRoomID, required String username}) async {
    try {
      dio.options.headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${AgoraConstants.chatAppToken}'
      };

      var response = await dio.post(
        "https://a41.chat.agora.io/41748750/984614/chatrooms/$chatRoomID/users/$username",
      );
      if (response.statusCode == 200) {
        print(response.data);
      }
    } on DioError catch (e) {
      print(e.message);
    }
  }

  //No use as of now, but could be useful in future
  addMultipleChatRoomMembers({
    required String chatRoomID,
    required String username,
  }) async {
    //username => List<String> username -> as it is going to add multiple members
    try {
      dio.options.headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${AgoraConstants.chatAppToken}'
      };

      var response = await dio.post(
        "https://a41.chat.agora.io/41748750/984614/chatrooms/$chatRoomID/users",
        data: {
          'usernames': [
            {'user': username},
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

  void sendAChatRoomMessage({
    String? message,
    required String username,
    required String chatRoomID,
    String messageType = 'txt',
  }) async {
    /* As of now it is made to support on text message , later image , voice,
    video, file, location, CMD types can be integrated*/

    MessageType messageType = MessageType.TXT;
    String targetId = AgoraConstants.chartRoomID;
    ChatType chatType = ChatType.ChatRoom;
    ChatMessageBody body = ChatTextMessageBody(content: message ?? '');
    ChatMessage txtMsg = ChatMessage.createSendMessage(
      body: body,
      to: AgoraConstants.chartRoomID,
      chatType: ChatType.ChatRoom,
    );
    ChatClient.getInstance.chatManager.sendMessage(txtMsg).then((value) {
      print(value);

      addLogToConsole("send message: $message");
      print('Message sent');
    });

    // try {
    //   dio.options.headers = {
    //     'Content-Type': 'application/json',
    //     'Accept': 'application/json',
    //     'Authorization': 'Bearer ${AgoraConstants.chatAppToken}'
    //   };
    //
    //   var response = await dio.post(
    //     "https://a41.chat.agora.io/41748750/984614/messages/chatrooms/",
    //     data: {
    //       "from": AgoraConstants.testUserID_001,
    //       "to": [AgoraConstants.chartRoomID],
    //       "type": messageType,
    //       "body": {
    //         "msg": message,
    //       },
    //     },
    //   );
    //   if (response.statusCode == 200) {
    //     print(response.data);
    //   }
    // } on DioError catch (e) {
    //   print(e.message);
    // }
  }

  destroyChatRoom({required String chatRoomID}) async {
    try {
      dio.options.headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${AgoraConstants.chatAppToken}'
      };

      var response = await dio.delete(
        "https://a41.chat.agora.io/41748750/984614/chatrooms/${AgoraConstants.chartRoomID}",
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

  receiveMessageInChatRoom() async* {
    ///Todo: receive messages in chat room sent by others.
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

  void addChatRoomEventsListener() {
    ChatClient.getInstance.chatRoomManager.addEventHandler(
      'UNIQUE_HANDLER_ID',
      ChatRoomEventHandler(onMemberJoinedFromChatRoom: onMemberJoinChatRoom),
    );
  }

  void onMemberJoinChatRoom(String roomID ,String participant) {
    addLogToConsole('$participant joined the chat room ID ($roomID)');
  }
}
