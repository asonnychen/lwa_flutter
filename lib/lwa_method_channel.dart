import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'lwa_platform_interface.dart';

/// MethodChannelLwa
class MethodChannelLwa extends LwaPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('lwa');

  @override

  /// signIn(scopes)
  /// Logs the user in to the Amazon service
  /// Accepts an optional array of scopes and returns a string
  Future<String?> signIn({required List scopes}) async {
    final response =
        await methodChannel.invokeMethod<String>('signIn', {'scopes': scopes});
    return response;
  }

  @override

  /// signOut()
  /// Logs the user out of the Amazon service and expires their token
  /// Returns a string
  Future<String?> signOut() async {
    final response = await methodChannel.invokeMethod<String>('signOut');
    return response;
  }

  /// getLWAAuthState
  /// Stream handler that listens for Amazon authentication events
  /// Returns a stream
  static Stream get getLWAAuthState {
    const eventChannel = EventChannel('lwa.authentication');
    return eventChannel.receiveBroadcastStream().cast();
  }
}
