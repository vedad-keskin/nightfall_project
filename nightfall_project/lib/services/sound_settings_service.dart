import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SoundSettingsService extends ChangeNotifier {
  bool _isMuted = false;

  bool get isMuted => _isMuted;

  SoundSettingsService() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isMuted = prefs.getBool('sound_muted') ?? false;
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading sound settings: $e');
    }
  }

  Future<void> toggleMute() async {
    _isMuted = !_isMuted;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('sound_muted', _isMuted);
    } catch (e) {
      debugPrint('Error saving sound settings: $e');
    }
  }

  Future<void> setMuted(bool muted) async {
    if (_isMuted == muted) return;

    _isMuted = muted;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('sound_muted', muted);
    } catch (e) {
      debugPrint('Error saving sound settings: $e');
    }
  }
}
