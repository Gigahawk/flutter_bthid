import 'package:flutter/material.dart';
import 'package:flutter_bthid/flutter_bthid.dart';
import 'package:flutter_bthid/gen/messages.g.dart';

class DeviceSelectView extends StatefulWidget {
  const DeviceSelectView({super.key});

  @override
  State<DeviceSelectView> createState() => _DeviceSelectViewState();
}

class _DeviceSelectViewState extends State<DeviceSelectView> {
  final BluetoothHidManager manager = BluetoothHidManager();

  List<BluetoothDeviceInfo> devices = [];

  @override
  void initState() {
    super.initState();
    btInit();
  }

  void btInit() async {
    print("Initing manager");
    await manager.init();
    print("Getting paired devices");
    final d = await manager.getPairedDevices();
    setState(() {
      devices = d;
    });
  }


  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: devices.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(devices[index].name),
          subtitle: Text("${devices[index].address}\n${devices[index].deviceClass}"),
          onTap: () {}

        );
      }
    );
  }
}