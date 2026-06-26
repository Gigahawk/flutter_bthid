
import 'gen/messages.g.dart';

final FlutterBthidApi _api = FlutterBthidApi();

class BluetoothHidManager {
  static final BluetoothHidManager _singleton = BluetoothHidManager._internal();

  bool _initialized = false;

  factory BluetoothHidManager() {
    return _singleton;
  }

  BluetoothHidManager._internal();

  Future<List<BluetoothDeviceInfo>> getPairedDevices() async {
    final result = await _api.getPairedDevices();
    if (result != null) return result;
    return [];
  }

  Future<void> init() async {
    // TODO: is there a usecase for initing more than once?
    if (_initialized) {
      return;
    }
    await _api.init();
  }
}
