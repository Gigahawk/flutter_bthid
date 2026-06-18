import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bthid/flutter_bthid.dart';
import 'package:flutter_bthid/flutter_bthid_platform_interface.dart';
import 'package:flutter_bthid/flutter_bthid_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterBthidPlatform
    with MockPlatformInterfaceMixin
    implements FlutterBthidPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterBthidPlatform initialPlatform = FlutterBthidPlatform.instance;

  test('$MethodChannelFlutterBthid is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterBthid>());
  });

  test('getPlatformVersion', () async {
    FlutterBthid flutterBthidPlugin = FlutterBthid();
    MockFlutterBthidPlatform fakePlatform = MockFlutterBthidPlatform();
    FlutterBthidPlatform.instance = fakePlatform;

    expect(await flutterBthidPlugin.getPlatformVersion(), '42');
  });
}
