import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bthid/flutter_bthid.dart';

class ControllerView extends StatefulWidget {
  const ControllerView({super.key});

  @override
  State<ControllerView> createState() => _ControllerViewState();
}

class _ControllerViewState extends State<ControllerView> {
  final BluetoothHidManager manager = BluetoothHidManager();

  int _count = 0;
  String _device = "";
  StreamSubscription? _connectionStateSubscription;

  @override
  void initState() {
    super.initState();
    getDeviceName();
  }

  void getDeviceName() async {
    final dev = await manager.getConnectedDevice();
    setState(() {
      _device = dev?.name ?? "";
    });
    _connectionStateSubscription = manager.connectionStateStream.listen((device) {
      if (device == null) {
        if (mounted) {
          Navigator.of(context).pop();
          return;
        }
      }
      setState(() {
        _device = device?.name ?? "";
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Connected to $_device')),
        body: Center(child: Text('You have pressed the button $_count times.')),
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          child: Container(height: 50.0),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => setState(() {
            _count++;
          }),
          tooltip: 'Increment Counter',
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  @override
  void dispose() {
    _connectionStateSubscription?.cancel();
    super.dispose();
  }
}