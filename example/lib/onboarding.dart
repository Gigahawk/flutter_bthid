import 'package:flutter/material.dart';
import 'package:flutter_bthid_example/device_select.dart';
import 'dart:async';

import 'package:permission_handler/permission_handler.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  bool _hasBluetoothPermission = false;

  @override
  void initState() {
    super.initState();
    getBluetoothPermission();
  }

  Future<void> getBluetoothPermission() async {
    final permissions = [
      Permission.bluetoothConnect,
      Permission.bluetoothScan,
      Permission.bluetoothAdvertise,
      //Permission.bluetooth,
    ];

    for (final perm in permissions) {
      print("Requesting permission: ${perm.toString()}");
      await perm.request();
      if (await perm.status.isDenied) {
        print("Permission denied: ${perm.toString()}");
        return;
      }
    }
    setState(() {
      _hasBluetoothPermission = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      showDoneButton: false,
      next: const Icon(Icons.arrow_forward),
      pages: [
        PageViewModel(
          title: "Bluetooth Permissions are required",
          bodyWidget: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: _hasBluetoothPermission
                    ? null
                    : getBluetoothPermission,
                child: Text(
                  _hasBluetoothPermission
                      ? "Permission Granted"
                      : "Request Permission",
                ),
              ),
            ],
          ),
        ),
        PageViewModel(
          title: "Select a device to connect to",
          bodyWidget: DeviceSelectView()
        ),
      ],
      canProgress: (page) => _hasBluetoothPermission,
    );
  }
}
