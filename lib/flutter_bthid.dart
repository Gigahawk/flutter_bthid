
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

  Future<void> sendReport(int id, List<int> data) async {
    return await _api.sendReport(id, data);
  }

  // TODO: idk
  Future<void> sendAKey() async {
    const int key = 0x04;
    // TODO: this is hardcoded to 1 for some reason??? Something to do with HID descriptor
    const int reportId = 1;
    await sendReport(reportId, [0x00, 0x00, key, 0x00, 0x00, 0x00, 0x00, 0x00]);
    await Future.delayed(const Duration(milliseconds: 1000));
    await sendReport(reportId, [0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]);

  }

  Future<void> moveMouse(int x, int y) async {
    // TODO: this is hardcoded to 2 for some reason??? Something to do with HID descriptor
    const int reportId = 2;
    // TODO: support sending buttons
    final List<int> report = [
      0x00,                   // Byte 0: Buttons bitmask
      x.clamp(-127, 127) & 0xFF,  // Byte 1: X-axis (8-bit)
      y.clamp(-127, 127) & 0xFF,  // Byte 2: Y-axis (8-bit)
      0x00,                      // Byte 3: Vertical Wheel
      0x00,                      // Byte 4: Horizontal Wheel (if supported)
    ];

    await sendReport(reportId, report);
  }


  @override
  void onConnectionStateChanged(BluetoothDeviceInfo? device) {
    _connectionStateController.add(device);
  }
}
