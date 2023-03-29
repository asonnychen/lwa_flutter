
import 'lwa_method_channel.dart';

class Lwa {
  var channel = MethodChannelLwa();

  Future<String?> signIn() {
    return channel.signIn();
  }

  Future<String?> signOut() {
    return channel.signOut();
  }

  Stream getLWAAuthState() {
    return MethodChannelLwa.getLWAAuthState;
  }
}
