import 'package:flutter/material.dart';
import 'package:flutter_bthid_example/onboarding.dart';
import 'dart:async';

import 'package:introduction_screen/introduction_screen.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:flutter_bthid/flutter_bthid.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final BluetoothHidManager _bluetoothHidManager = BluetoothHidManager();

  @override
  void initState() {
    super.initState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: OnboardingView()
    );
  }
}
