import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bthid/flutter_bthid.dart';
import 'package:flutter_bthid_example/trackpad.dart';

class ControllerView extends StatefulWidget {
  const ControllerView({super.key});

  @override
  State<ControllerView> createState() => _ControllerViewState();
}

class _ControllerViewState extends State<ControllerView> {
  final BluetoothHidManager manager = BluetoothHidManager();
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _textController = TextEditingController();

  int _count = 0;
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
        appBar: AppBar(title: Text('Connected to $_device')),
        body: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(child: Text('You have pressed the button $_count times.')),
                  TrackpadSurface(),
                ],
              ),

              Positioned(
                left: -1000,
                child: SizedBox(
                  width: 1,
                  height: 1,
                  child: TextField(
                    focusNode: _focusNode,
                    controller: _textController,
                    autofocus: true,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    // TODO: enter and backspace doesn't seem to work?
                    onChanged: (value) {
                      if (value.isEmpty) return;
                      print("Input: $value");
                      _textController.clear();
                    },
                    decoration: const InputDecoration(border: InputBorder.none),
                  )
                )
              )
            ]
        ),
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          child: Container(height: 50.0),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => setState(() {
            _count++;
            _enableKeyboardInput();
          }),
          tooltip: 'Increment Counter',
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _connectionStateSubscription?.cancel();
    super.dispose();
  }
}