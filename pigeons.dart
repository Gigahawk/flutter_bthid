import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/gen/messages.g.dart',
    kotlinOut: 'android/src/main/kotlin/com/gigahawk/flutter_bthid/gen/Messages.g.kt',
    kotlinOptions: KotlinOptions(
      package: 'com.gigahawk.flutter_bthid.gen',
    ),
    dartPackageName: 'flutter_bthid',
  ),
)

class BluetoothDeviceInfo {
  BluetoothDeviceInfo({required this.name, required this.deviceClass, required this.address});
  final String name;
  final String deviceClass;
  final String address;
}

@HostApi()
abstract class FlutterBthidApi {
  @async
  void init();

  @async
  void connect(BluetoothDeviceInfo device);

  @async
  BluetoothDeviceInfo? getConnectedDevice();

  @async
  void sendReport(int id, List<int> data);

  @async
  List<BluetoothDeviceInfo>? getPairedDevices();
}

@FlutterApi()
abstract class BluetoothEventsApi {
  void onConnectionStateChanged(BluetoothDeviceInfo? device);
}