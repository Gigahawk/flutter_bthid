
import 'gen/messages.g.dart';

final FlutterBthidApi _api = FlutterBthidApi();

class BluetoothHidManager {
  Future<List<BluetoothDeviceInfo>> getPairedDevices() async {
    final result = await _api.getPairedDevices();
    if (result != null) return result;
    return [];
  }
}
