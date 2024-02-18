import 'package:flutter/material.dart';
import 'package:uionly_flutter/trip_legs/add_trip_leg_view.dart';
import 'package:uionly_flutter/trip_legs/progress_view.dart';
import 'package:uionly_flutter/trip_legs/splash_view.dart';
import 'package:uionly_flutter/trip_legs/top_view.dart';
import 'package:uionly_flutter/trip_legs/trip_legs_list_view.dart';

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
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: ,
      routes: {
        '/main': (context) => const TripLegsListView(),
        '/': (context) => const SplashView(),
        '/add': (context) => const AddTripLegView(null),
        '/progress': (context) => const ProgressView(),
        '/top': (context) => const TopView(),
      },
    );
  }
}
