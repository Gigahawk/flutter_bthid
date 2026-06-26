
import 'dart:async';
import 'gen/messages.g.dart';

final FlutterBthidApi _api = FlutterBthidApi();

class BluetoothHidManager extends BluetoothEventsApi {
  static final BluetoothHidManager _singleton = BluetoothHidManager._internal();

  bool _initialized = false;
  final StreamController<BluetoothDeviceInfo?> _connectionStateController =
      StreamController<BluetoothDeviceInfo?>.broadcast();

  /// A stream of the currently connected device.
  /// Emits the [BluetoothDeviceInfo] when connected, and `null` when disconnected.
  Stream<BluetoothDeviceInfo?> get connectionStateStream =>
      _connectionStateController.stream;

  factory BluetoothHidManager() {
    return _singleton;
  }

  BluetoothHidManager._internal() {
    BluetoothEventsApi.setUp(this);
  }

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

  Future<void> connect(BluetoothDeviceInfo device) async {
    await _api.connect(device);
  }

  Future<BluetoothDeviceInfo?> getConnectedDevice() async {
    return await _api.getConnectedDevice();
  }

  @override
  void onConnectionStateChanged(BluetoothDeviceInfo? device) {
    _connectionStateController.add(device);
  }
}
