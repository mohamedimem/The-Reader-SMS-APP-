import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthManager {
  final FlutterSecureStorage _storage;
  final String _signInKey = 'signedin';

  AuthManager(this._storage);
  Future<void> setSignInStatus(bool isSignedIn) async {
    await _storage.write(key: _signInKey, value: isSignedIn.toString());
  }

  Future<bool> isSignedIn() async {
    String value = await _storage.read(key: _signInKey) ?? 'false';
    return value == 'true';
  }

  Future<void> signIn() async {
    await setSignInStatus(true);
  }

  Future<void> signOut() async {
    print("before deleting...");
    var f = _storage.read(key: "uid");
    print(f);

    await setSignInStatus(false);
    await _storage.delete(key: 'uid');
    print("after deleting...");

    print(f);
  }
}
