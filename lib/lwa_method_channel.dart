import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'lwa_platform_interface.dart';

class MethodChannelLwa extends LwaPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('lwa');

  @override
  Future<String?> signIn() async {
    final response = await methodChannel.invokeMethod<String>('signIn');
    return response;
  }

  @override
  Future<String?> signOut() async {
    final response = await methodChannel.invokeMethod<String>('signOut');
    return response;
  }

  static Stream get getLWAAuthState {
    const eventChannel = EventChannel('lwa.authentication');
    return eventChannel.receiveBroadcastStream().cast();
  }
}
