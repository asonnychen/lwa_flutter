import 'package:flutter/services.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'lwa_method_channel.dart';

/// LwaPlatform
abstract class LwaPlatform extends PlatformInterface {
  /// Constructor
  LwaPlatform() : super(token: _token);

  /// Internal platform token
  static final Object _token = Object();

  /// LwaPlatform
  static LwaPlatform _instance = MethodChannelLwa();

  /// LwaPlatform
  static LwaPlatform get instance => _instance;

  /// self instance
  static set instance(LwaPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// signIn(scopes)
  /// Logs the user in to the Amazon service
  /// Accepts an optional array of scopes and returns a string
  Future<String?> signIn({required List scopes}) async {
    final response = await _instance.signIn(scopes: scopes);
    return response;
  }

  /// signOut()
  /// Logs the user out of the Amazon service and expires their token
  /// Returns a string
  Future<String?> signOut() async {
    final response = await _instance.signOut();
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
