import 'package:flutter/material.dart';

import 'device_select.dart';

class DeviceSelectScreen extends StatelessWidget {
  const DeviceSelectScreen({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Device"),
      ),
      body: DeviceSelectView()
    );
  }
}