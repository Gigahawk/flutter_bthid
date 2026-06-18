import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_bthid_platform_interface.dart';

/// An implementation of [FlutterBthidPlatform] that uses method channels.
class MethodChannelFlutterBthid extends FlutterBthidPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_bthid');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>(
      'getPlatformVersion',
    );
    return version;
  }
}
