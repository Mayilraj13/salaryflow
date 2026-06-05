import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'dart:math';

class SecurityService {
  final FlutterSecureStorage _storage;
  
  SecurityService() : _storage = const FlutterSecureStorage();

  Future<bool> isPinEnabled() async {
    final value = await _storage.read(key: 'pin_enabled');
    return value == 'true';
  }

  Future<void> setPinEnabled(bool enabled) async {
    await _storage.write(key: 'pin_enabled', value: enabled.toString());
  }

  Future<void> setPin(String pin) async {
    final hash = _hashPin(pin);
    await _storage.write(key: 'pin_hash', value: hash);
    await setPinEnabled(true);
  }

  Future<bool> verifyPin(String pin) async {
    final hash = await _storage.read(key: 'pin_hash');
    if (hash == null) return false;
    return hash == _hashPin(pin);
  }

  Future<void> disablePin() async {
    await _storage.delete(key: 'pin_hash');
    await setPinEnabled(false);
  }

  Future<bool> isBiometricEnabled() async {
    final value = await _storage.read(key: 'biometric_enabled');
    return value == 'true';
  }

  Future<void> setBiometricEnabled(bool enabled) async {
    await _storage.write(key: 'biometric_enabled', value: enabled.toString());
  }

  String _hashPin(String pin) {
    final bytes = utf8.encode(pin);
    // Simple hash for PIN storage (in production, use bcrypt or similar)
    final hash = bytes.fold<int>(0, (prev, byte) => prev ^ byte);
    final salt = (pin.length * 7).toString();
    return '${hash.toString()}_${pin.length}_$salt';
  }

  Future<void> setAppLockTimer(int minutes) async {
    await _storage.write(key: 'app_lock_timer', value: minutes.toString());
  }

  Future<int> getAppLockTimer() async {
    final value = await _storage.read(key: 'app_lock_timer');
    return int.tryParse(value ?? '5') ?? 5;
  }

  Future<void> setLastActiveTime() async {
    await _storage.write(
      key: 'last_active_time',
      value: DateTime.now().millisecondsSinceEpoch.toString(),
    );
  }

  Future<bool> isLockRequired() async {
    final isEnabled = await isPinEnabled();
    if (!isEnabled) return false;

    final lastActive = await _storage.read(key: 'last_active_time');
    if (lastActive == null) return false;

    final lastTime = int.tryParse(lastActive) ?? 0;
    final timerMinutes = await getAppLockTimer();
    final elapsed = DateTime.now().millisecondsSinceEpoch - lastTime;
    return elapsed > (timerMinutes * 60 * 1000);
  }

  Future<void> saveBackupKey(String key) async {
    await _storage.write(key: 'backup_encryption_key', value: key);
  }

  Future<String?> getBackupKey() async {
    return await _storage.read(key: 'backup_encryption_key');
  }
}
