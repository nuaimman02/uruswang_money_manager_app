import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:uruswang_money_manager_app/register_service.dart';
import 'package:uruswang_money_manager_app/services/navigation_service.dart';
import 'package:uruswang_money_manager_app/services/notification_controller.dart';

// TODO: BEFORE START DEBUGGING THE APP, 
//  PLEASE COMMENT OUT THE ScheduledNotificationReceiver and RefreshSchedulesReceiver
//  in uruswang_money_manager_app\android\app\src\main\AndroidManifest.xml

void main() {
  setup();
  runApp(const MyApp());
}

Future<void> setup() async {
  WidgetsFlutterBinding.ensureInitialized();
  await registerServices();
  await initializeNotificationsAndRequestPermission();

  // final driver = StorageServerDriver(
  //   bundleId: 'com.example.uruswang_money_manager_app',
  //   icon: '<some icon>',
  // );

  // final driftDb = AppDatabase();

  // final sqlServer = DriftSQLDatabaseServer(
  //   id: "1",
  //   name: "SQL server",
  //   database: driftDb,
  // );

  // driver.addSQLServer(sqlServer);

  // await driver.start(paused: false);
}

Future<void> initializeNotificationsAndRequestPermission() async {
  AwesomeNotifications().initialize(
    null, 
    [
      NotificationChannel(
          channelGroupKey: 'basic_channel_group',
          channelKey: 'basic_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          importance: NotificationImportance.Max,
          channelShowBadge: true,
          // defaultColor: Color(0xFF9D50DD),
          // ledColor: Colors.white
      ),
      NotificationChannel(
          channelGroupKey: 'scheduled_channel_group',
          channelKey: 'scheduled_channel',
          channelName: 'Scheduled notifications',
          channelDescription: 'Notification channel for scheduled tests',
          importance: NotificationImportance.Max,
          channelShowBadge: true,
          // defaultColor: Color(0xFF9D50DD),
          // ledColor: Colors.white
      )
    ],
    // Channel groups are only visual and are not required
    channelGroups: [
      NotificationChannelGroup(
          channelGroupKey: 'basic_channel_group',
          channelGroupName: 'Basic group'),
      NotificationChannelGroup(
          channelGroupKey: 'scheduled_channel_group',
          channelGroupName: 'Scheduled group')
    ],
    debug: kDebugMode
  );

  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
  if (!isAllowed) {
    // This is just a basic example. For real apps, you must show some
    // friendly dialog box before call the request method.
    // This is very important to not harm the user experience
    AwesomeNotifications().requestPermissionToSendNotifications();
  }
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GetIt _getIt = GetIt.instance;
  late NavigationService _navigationService;

  @override
  void initState() {
    // Only after at least the action method is set, the notification events are delivered
    AwesomeNotifications().setListeners(
        onActionReceivedMethod: NotificationController.onActionReceivedMethod,
        onNotificationCreatedMethod: NotificationController.onNotificationCreatedMethod,
        onNotificationDisplayedMethod: NotificationController.onNotificationDisplayedMethod,
        onDismissActionReceivedMethod: NotificationController.onDismissActionReceivedMethod
        
    );

    _navigationService = _getIt.get<NavigationService>();
    
    // TODO: implement initState
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigationService.navigatorKey,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
        fontFamily: 'Montserrat',
      ),
      initialRoute: '/dynamic',
      routes: _navigationService.routes,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)), // Disable text scaling
          child: child!,
        );
      },
      // localizationsDelegates: const [
      //   GlobalWidgetsLocalizations.delegate,
      //   GlobalMaterialLocalizations.delegate,
      // ]
    );
  }
}

