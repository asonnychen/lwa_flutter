import 'package:flutter_test/flutter_test.dart';
import 'package:lwa/lwa.dart';
import 'package:lwa/lwa_platform_interface.dart';
import 'package:lwa/lwa_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockLwaPlatform
    with MockPlatformInterfaceMixin
    implements LwaPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final LwaPlatform initialPlatform = LwaPlatform.instance;

  test('$MethodChannelLwa is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelLwa>());
  });

  test('getPlatformVersion', () async {
    Lwa lwaPlugin = Lwa();
    MockLwaPlatform fakePlatform = MockLwaPlatform();
    LwaPlatform.instance = fakePlatform;

    expect(await lwaPlugin.getPlatformVersion(), '42');
  });
}
