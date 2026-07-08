import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bthid/flutter_bthid.dart';
import 'package:flutter_bthid_example/keyboard_bar.dart';
import 'package:flutter_bthid_example/trackpad.dart';

import 'controller_type.dart';
import 'device_select_screen.dart';

class ControllerView extends StatefulWidget {
  const ControllerView({super.key});

  @override
  State<ControllerView> createState() => _ControllerViewState();
}

class _ControllerViewState extends State<ControllerView> {
  final BluetoothHidManager manager = BluetoothHidManager();
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _textController = TextEditingController();

  final List<ControllerType> _controllerTypes = [
    ControllerType(name: "Mouse/Keyboard", icon: Icons.mouse_outlined, widget: TrackpadSurface()),
    ControllerType(name: "Multimedia", icon: Icons.live_tv, widget: Text("Multimedia")),
    ControllerType(name: "PC Keyboard", icon: Icons.keyboard_outlined, widget: Text("PC Keyboard")),
    ControllerType(name: "Numpad", icon: Icons.apps, widget: Text("Numpad")),
    ControllerType(name: "Presenter", icon: Icons.co_present_outlined, widget: Text("Presenter")),
  ];

  int _drawerSelectionIndex = 0;
  bool _showKeyboardBar = false;

  static const double _drawerPadding = 28.0;

  String _device = "";
  StreamSubscription? _connectionStateSubscription;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => _focusNode.requestFocus());

    getDeviceName();
  }

  void _enableKeyboardInput() {
    _focusNode.requestFocus();
    SystemChannels.textInput.invokeMethod('TextInput.show');
  }

  void getDeviceName() async {
    final dev = await manager.getConnectedDevice();
    setState(() {
      _device = dev?.name ?? "";
    });
    _connectionStateSubscription = manager.connectionStateStream.listen((device) {
      setState(() {
        _device = device?.name ?? "";
      });
    });
  }

  //void _handleKeyEvent(KeyEvent event) {
  //  if (event is KeyDownEvent) {
  //    print("Key down: ${event.logicalKey.debugName}");
  //  } else if (event is KeyUpEvent) {
  //    print("Key up: ${event.logicalKey.debugName}");
  //  } else {
  //    print("Key event ${event.runtimeType}");
  //  }
  //}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_controllerTypes[_drawerSelectionIndex].name),
              Text(
                  _device.isNotEmpty ? "Connected to $_device" : "Not connected",
                style: const TextStyle(
                  fontSize: 14.0,
                ),
              )
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.keyboard_outlined),
              onPressed: () {
                setState(() {
                  _showKeyboardBar = !_showKeyboardBar;
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.settings_outlined),
              onPressed: () {},
            ),

          ],
        ),
        drawer: NavigationDrawer(
            selectedIndex: _drawerSelectionIndex,
            onDestinationSelected: (int index) {
              if (index < _controllerTypes.length) {
                setState(() {
                  _drawerSelectionIndex = index;
                });
              } else {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const DeviceSelectScreen())
                );
              }
            },
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: _drawerPadding, vertical: 12.0),
                child: Text (
                    "flutter_bthid demo",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    )
                )
              ),

              Divider(),
              const Padding(
                  padding: EdgeInsets.symmetric(horizontal: _drawerPadding, vertical: 8.0),
                  child: Text (
                      "Controls",
                  )
              ),

              for (var ct in _controllerTypes)
                ct.dest,

              Divider(),
              const Padding(
                  padding: EdgeInsets.symmetric(horizontal: _drawerPadding, vertical: 8.0),
                  child: Text (
                    "Confiugration",
                  )
              ),

              const NavigationDrawerDestination(
                  icon: Icon(Icons.devices), label: Text("Bluetooth devices")
              ),
            ],
        ),
        body:  Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                child: _controllerTypes[_drawerSelectionIndex].widget
            ),
            if (_showKeyboardBar)
              Container(
                padding: EdgeInsets.all(16.0),
                child: KeyboardBar(),
              )
          ],
        ),
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _connectionStateSubscription?.cancel();
    super.dispose();
  }
}