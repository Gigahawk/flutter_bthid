
import 'flutter_bthid_platform_interface.dart';
import 'gen/messages.g.dart';

final FlutterBthidApi _api = FlutterBthidApi();

Future<List<BluetoothDeviceInfo>> getPairedDevices() async {
  final result = await _api.getPairedDevices();
  if (result != null) return result;
  return [];
}
