import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bthid/flutter_bthid.dart';

class KeyboardBar extends StatefulWidget {
  const KeyboardBar({super.key});

  @override
  State<KeyboardBar> createState() => _KeyboardBarState();
}

class _KeyboardBarState extends State<KeyboardBar> {
  final BluetoothHidManager hidManager = BluetoothHidManager();
  final ScrollController _textScrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _directTextController = TextEditingController();
  final FocusNode _directFocusNode = FocusNode();

  bool _direct = true;
  bool _hideInputs = false;

  void _resetDirectContents() {
    _directTextController.text = "\u200B";
    _directTextController.selection = TextSelection.fromPosition(
      TextPosition(offset: 1),
    );
  }

  void _setDirect() {
    setState(() {
      _direct = true;
      _resetDirectContents();
      _directFocusNode.requestFocus();
    });
  }

  @override
  void initState() {
    super.initState();
    _setDirect();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10.0,
      children: [
        FilterChip(
          showCheckmark: false,
          label: const Text("Direct"),
          selected: _direct,
          onSelected: (bool selected) {
            _setDirect();
          },
        ),
        Expanded(
          child: Scrollbar(
            controller: _textScrollController,
            thumbVisibility: true,
            child: TextField(
              controller: _textController,
              scrollController: _textScrollController,
              maxLines: 5,
              minLines: 1,
              keyboardType: TextInputType.multiline,
              obscureText: _hideInputs,
              enableSuggestions: !_hideInputs,
              autocorrect: !_hideInputs,
              decoration: InputDecoration(
                hintText: "Enter text and press send",
                isDense: true,
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    final text = _textController.text;
                    if (text.isNotEmpty) {
                      print("Sending ${jsonEncode(text)}");
                      hidManager.sendString(text);
                      _textController.clear();
                    }
                  },
                ),
              ),
              onTap: () {
                setState(() {
                  _direct = false;
                });
              },
            ),
          ),
        ),
        IconButton(
          icon: _hideInputs
              ? const Icon(Icons.visibility_off)
              : const Icon(Icons.visibility),
          onPressed: () {
            setState(() {
              _hideInputs = !_hideInputs;
            });
          },
        ),
        Offstage(
          offstage: true,
          child: SizedBox(
            width: 0.0,
            height: 0.0,
            child: TextField(
              focusNode: _directFocusNode,
              controller: _directTextController,
              maxLines: null,
              autocorrect: false,
              enableSuggestions: false,
              keyboardType: TextInputType.multiline,
              onChanged: (value) {
                if (!_direct) return;

                if (value.isEmpty) {
                  print("Sending backspace");
                  hidManager.sendBackspace();
                } else if (value.length > 1) {
                  String char = value.substring(1);
                  print("Sending ${jsonEncode(char)}");
                  hidManager.sendString(char);
                }

                _resetDirectContents();
              },
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _textScrollController.dispose();
    _textController.dispose();
    _directTextController.dispose();
    _directFocusNode.dispose();
    super.dispose();
  }
}
