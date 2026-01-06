import 'package:shared_preferences/shared_preferences.dart';

class TimerSettingsService {
  static const String _timerDurationKey = 'werewolf_timer_duration';
  static const int defaultDuration = 300; // 5 minutes in seconds

  /// Get the saved timer duration in seconds
  Future<int> getTimerDuration() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_timerDurationKey) ?? defaultDuration;
  }

  /// Save timer duration in seconds
  Future<void> setTimerDuration(int seconds) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_timerDurationKey, seconds);
  }

  /// Get available timer options in seconds
  static List<int> get timerOptions => [120, 300, 600]; // 2, 5, 10 minutes

  /// Convert seconds to display string (e.g., "2 MIN", "5 MIN")
  static String formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    return '$minutes MIN';
  }
}
