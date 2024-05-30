import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:reminder/bloc/reminder_bloc.dart';
import 'package:reminder/screens/home_screen.dart';
import 'package:reminder/service/notification_service.dart';
import 'package:reminder/simple_bloc_observer.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

_requestIOSPermission() {
  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(
        alert: false,
        badge: true,
        sound: true,
      );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: await getTemporaryDirectory());
  _requestIOSPermission();
  Bloc.observer = SimpleBlocObserver();

  NotificationService.initialize();
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ReminderBloc>(
      create: (context) => ReminderBloc()
        ..add(
          ReminderStarted(),
        ),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      ),
    );
  }
}
