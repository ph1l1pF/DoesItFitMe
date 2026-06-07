import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Speichert die Foto-Einwilligung lokal.
///
/// Wird beim App-Start initialisiert. Falls [SharedPreferences] nach einem
/// Hot Restart nicht erreichbar ist, fällt der Service auf Speicher im RAM zurück.
class PrivacyConsentService {
  PrivacyConsentService._(this._storage);

  static const _consentKey = 'photo_processing_consent';
  static const _consentAtKey = 'photo_processing_consent_at';
  static const _consentVersionKey = 'photo_processing_consent_version';

  static PrivacyConsentService? _instance;

  final _ConsentStorage _storage;

  static bool get usesInMemoryFallback =>
      _instance?._storage is _InMemoryConsentStorage;

  static Future<void> initialize() async {
    await create();
  }

  static Future<PrivacyConsentService> create() async {
    final existing = _instance;
    if (existing != null) {
      return existing;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      _instance = PrivacyConsentService._(_SharedPreferencesStorage(prefs));
      return _instance!;
    } catch (error, stackTrace) {
      debugPrint(
        'SharedPreferences nicht verfügbar, nutze In-Memory-Fallback: $error',
      );
      debugPrint('$stackTrace');
      _instance = PrivacyConsentService._(_InMemoryConsentStorage());
      return _instance!;
    }
  }

  bool get hasPhotoProcessingConsent =>
      _storage.readBool(_consentKey) ?? false;

  DateTime? get consentGrantedAt {
    final value = _storage.readString(_consentAtKey);
    return value == null ? null : DateTime.tryParse(value);
  }

  String? get consentPolicyVersion => _storage.readString(_consentVersionKey);

  Future<void> grantConsent({required String policyVersion}) async {
    await _storage.writeBool(_consentKey, true);
    await _storage.writeString(_consentAtKey, DateTime.now().toIso8601String());
    await _storage.writeString(_consentVersionKey, policyVersion);
  }

  Future<void> revokeConsent() async {
    await _storage.remove(_consentKey);
    await _storage.remove(_consentAtKey);
    await _storage.remove(_consentVersionKey);
  }
}

abstract class _ConsentStorage {
  bool? readBool(String key);
  String? readString(String key);
  Future<void> writeBool(String key, bool value);
  Future<void> writeString(String key, String value);
  Future<void> remove(String key);
}

class _SharedPreferencesStorage implements _ConsentStorage {
  _SharedPreferencesStorage(this._prefs);

  final SharedPreferences _prefs;

  @override
  bool? readBool(String key) => _prefs.getBool(key);

  @override
  String? readString(String key) => _prefs.getString(key);

  @override
  Future<void> writeBool(String key, bool value) => _prefs.setBool(key, value);

  @override
  Future<void> writeString(String key, String value) =>
      _prefs.setString(key, value);

  @override
  Future<void> remove(String key) => _prefs.remove(key);
}

class _InMemoryConsentStorage implements _ConsentStorage {
  final Map<String, Object> _values = {};

  @override
  bool? readBool(String key) => _values[key] as bool?;

  @override
  String? readString(String key) => _values[key] as String?;

  @override
  Future<void> writeBool(String key, bool value) async {
    _values[key] = value;
  }

  @override
  Future<void> writeString(String key, String value) async {
    _values[key] = value;
  }

  @override
  Future<void> remove(String key) async {
    _values.remove(key);
  }
}
