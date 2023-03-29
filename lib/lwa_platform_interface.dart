import 'package:flutter/services.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'lwa_method_channel.dart';

abstract class LwaPlatform extends PlatformInterface {
  LwaPlatform() : super(token: _token);

  static final Object _token = Object();

  static LwaPlatform _instance = MethodChannelLwa();

  static LwaPlatform get instance => _instance;

  static set instance(LwaPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> signIn() async {
    final response = await _instance.signIn();
    return response;
  }

  Future<String?> signOut() async {
    final response = await _instance.signOut();
    return response;
  }

  static Stream get getLWAAuthState {
    const eventChannel = EventChannel('lwa.authentication');
    return eventChannel.receiveBroadcastStream().cast();
  }
}
