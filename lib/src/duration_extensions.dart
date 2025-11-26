/// Extension on [Duration] to extract normalized time components.
///
/// These getters return time components within their standard ranges,
/// useful for time-of-day calculations where values wrap around.
///
/// Example:
/// ```dart
/// final duration = Duration(hours: 25, minutes: 90);
/// print(duration.hours);   // 1 (25 % 24)
/// print(duration.minutes); // 30 (90 % 60)
/// ```
extension DurationExtension on Duration {
  /// Returns hours within a day (0-23).
  ///
  /// This is the remainder of total hours divided by 24.
  int get hours => inHours % Duration.hoursPerDay;

  /// Returns minutes within an hour (0-59).
  ///
  /// This is the remainder of total minutes divided by 60.
  int get minutes => inMinutes % Duration.minutesPerHour;

  /// Returns seconds within a minute (0-59).
  ///
  /// This is the remainder of total seconds divided by 60.
  int get seconds => inSeconds % Duration.secondsPerMinute;

  /// Returns milliseconds within a second (0-999).
  ///
  /// This is the remainder of total milliseconds divided by 1000.
  int get milliseconds => inMilliseconds % Duration.millisecondsPerSecond;

  /// Returns microseconds within a millisecond (0-999).
  ///
  /// This is the remainder of total microseconds divided by 1000.
  int get microseconds => inMicroseconds % Duration.microsecondsPerMillisecond;
}
