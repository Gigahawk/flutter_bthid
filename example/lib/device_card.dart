import 'package:flutter/material.dart';
import 'package:flutter_bthid/flutter_bthid.dart';
import 'package:flutter_bthid/gen/messages.g.dart';

class DeviceCard extends StatefulWidget {
  final BluetoothDeviceInfo device;

  const DeviceCard({super.key, required this.device});
  
  @override
  State<DeviceCard> createState() => _DeviceCardState();
}

class _DeviceCardState extends State<DeviceCard> {
  final BluetoothHidManager manager = BluetoothHidManager();
  var connected = false;

  void checkDeviceMatch(BluetoothDeviceInfo? device) {
    final c = device == widget.device;
    setState(() {
      connected = c;
    });

  }

  @override
  void initState() {
    super.initState();
    initStateAsync();
  }

  void initStateAsync() async {
    final device = await manager.getConnectedDevice();
    checkDeviceMatch(device);
    manager.connectionStateStream.listen(checkDeviceMatch);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(widget.device.name),
        // TODO: more device details
        subtitle: Text(widget.device.address),
        // TODO: icon showing device type?
        //leading: const Icon(Icons.bluetooth),
        // TODO: show a spinner for some fixed time while waiting for connection
        trailing: connected ? const Icon(Icons.bluetooth_connected) : null,
        onTap: () {
          manager.connect(widget.device);
        },
      ),
    );
  }


}