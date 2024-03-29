import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uionly_flutter/src/repository.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  Future<void> initRepository(BuildContext context) async {
    await Repository.tryDatabaseOp(context, () async {
      await Repository.instance.init();
    }, exitOnFail: true);
    await Future.delayed(const Duration(seconds: 0));
    if (!context.mounted) return;
    Navigator.pushReplacementNamed(context, '/main');
  }

  String getRandomText() {
    var list = List.of([
      "Hold the f*** up",
      "Wait a hot second",
      "Don't be impatient!",
      "What, you picked up sports?",
      "You'll get tired anyway",
      "This app is Russian spyware"
    ]);
    final random = Random();
    return list[random.nextInt(list.length)];
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () {
      if (Repository.instance.isInited) {
        Navigator.pushNamed(context, '/main');
      } else {
        initRepository(context);
      }
    });
    return Scaffold(
        body: SizedBox.expand(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const CircularProgressIndicator(),
        const Padding(padding: EdgeInsets.all(17.0)),
        Text(getRandomText()),
      ],
    )));
  }
}
