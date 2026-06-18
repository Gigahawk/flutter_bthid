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
  BluetoothDeviceInfo({required this.name,});
  final String name;
}

@HostApi()
abstract class FlutterBthidApi {
  @async
  List<BluetoothDeviceInfo>? getPairedDevices();
}