import 'package:agora_chat_poc/agora_constants.dart';
import 'package:agora_chat_poc/controller.dart';
import 'package:agora_chat_poc/screens/chat_room-screen/chat_room_screen.dart';
import 'package:agora_chat_poc/services/agora_chat_SDK_services.dart';
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
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  AgoraChatSDKServices agoraChatServices = AgoraChatSDKServices();
  AgoraController agoraController = AgoraController();

  @override
  void initState() {
    agoraChatServices.initAgoraChatSDK();
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
              onPressed: () {
                agoraController.agoraChatUserSignIn();
              },
              child: const Text('Sign In'),
            ),
            TextButton(
              onPressed: () {
                agoraController.agoraChatUserSignOut();
              },
              child: const Text('Sign out'),
            ),
            OutlinedButton(
              onPressed: () {
                agoraController.createSuperAdmin();
              },
              child: const Text('Make super admin'),
            ),
            ElevatedButton(
              onPressed: () {
                agoraController.removeSuperAdmin();
              },
              child: const Text('remove super admin'),
            ),
            OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChatRoomScreen(),
                  ),
                );
                agoraController.createLiveChatRoom();
              },
              child: const Text('Create Room'),
            ),
            ElevatedButton(
              onPressed: () {
                agoraController.destroyLiveChatRoom(
                    chatRoomID: '211611501527041');
              },
              child: const Text('Delete Room'),
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Join Room'),
            ),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
