import 'lwa_method_channel.dart';

class Lwa {
  var channel = MethodChannelLwa();

  Future<String?> signIn({List? scopes}) {
    scopes ??= ['profile'];
    return channel.signIn(scopes: scopes);
  }

  Future<String?> signOut() {
    return channel.signOut();
  }

  Stream getLWAAuthState() {
    return MethodChannelLwa.getLWAAuthState;
  }
}
