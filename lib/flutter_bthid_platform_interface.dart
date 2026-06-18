import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_bthid_method_channel.dart';

abstract class FlutterBthidPlatform extends PlatformInterface {
  /// Constructs a FlutterBthidPlatform.
  FlutterBthidPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterBthidPlatform _instance = MethodChannelFlutterBthid();

  /// The default instance of [FlutterBthidPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterBthid].
  static FlutterBthidPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterBthidPlatform] when
  /// they register themselves.
  static set instance(FlutterBthidPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
