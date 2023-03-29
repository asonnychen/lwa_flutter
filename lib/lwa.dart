import 'lwa_method_channel.dart';

/// LWA
class Lwa {
  var channel = MethodChannelLwa();

  /// signIn(scopes)
  /// Logs the user in to the Amazon service
  /// Accepts an optional array of scopes and returns a string
  Future<String?> signIn({List? scopes}) {
    scopes ??= ['profile'];
    return channel.signIn(scopes: scopes);
  }

  /// signOut()
  /// Logs the user out of the Amazon service and expires their token
  /// Returns a string
  Future<String?> signOut() {
    return channel.signOut();
  }

  /// getLWAAuthState
  /// Stream handler that listens for Amazon authentication events
  /// Returns a stream
  Stream getLWAAuthState() {
    return MethodChannelLwa.getLWAAuthState;
  }
}
