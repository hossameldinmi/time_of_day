import 'package:equatable/equatable.dart';
import 'package:time_of_day/src/duration_extensions.dart';
import 'package:clock/clock.dart';

/// Represents a time of day with microsecond precision (00:00:00 to 24:00:00).
///
/// [TimeOfDay] provides a type-safe way to represent and manipulate times within
/// a single day, independent of any specific date. It supports microsecond precision
/// and offers rich comparison and arithmetic operations.
///
/// Example:
/// ```dart
/// final morning = TimeOfDay(hour: 9, minute: 30);
/// final afternoon = morning.add(Duration(hours: 5));
/// print(afternoon); // h:14 m:30 s:0 ms:0 μs:0
/// ```
class TimeOfDay extends Equatable implements Comparable<TimeOfDay> {
  /// Internal representation in microseconds since midnight.
  final int _value;

  /// Maximum valid value (24 hours in microseconds).
  static const int _maxValue = Duration.microsecondsPerDay;

  /// Constant representing midnight (00:00:00.000000).
  static final midNight = TimeOfDay();

  /// Constant representing noon (12:00:00.000000).
  static final noon = TimeOfDay(hour: 12);

  /// Constant representing end of day (24:00:00.000000).
  static final endOfDay = TimeOfDay(hour: 24);

  /// Internal constructor from microseconds value.
  TimeOfDay._microseconds(int value)
      : assert(_isValidValue(value)),
        _value = value;

  /// Creates a [TimeOfDay] from a [DateTime], extracting only the time portion.
  ///
  /// Example:
  /// ```dart
  /// final dt = DateTime(2024, 1, 15, 14, 30, 45);
  /// final time = TimeOfDay.fromDateTime(dt); // 14:30:45
  /// ```
  TimeOfDay.fromDateTime(DateTime dateTime)
      : this._microseconds(_getMicroseconds(
            dateTime.hour, dateTime.minute, dateTime.second, dateTime.millisecond, dateTime.microsecond));

  /// Creates a [TimeOfDay] representing the current time.
  ///
  /// Uses the [clock] package for testable time.
  TimeOfDay.now() : this.fromDateTime(clock.now());

  /// Creates a [TimeOfDay] from individual time components.
  ///
  /// All parameters are optional and default to 0. Hour can be 0-24, but if hour is 24,
  /// all other components must be 0.
  ///
  /// Example:
  /// ```dart
  /// final time1 = TimeOfDay(hour: 15, minute: 30);
  /// final time2 = TimeOfDay(hour: 9, minute: 15, second: 30, millisecond: 500);
  /// ```
  TimeOfDay({
    int hour = 0,
    int minute = 0,
    int second = 0,
    int millisecond = 0,
    int microsecond = 0,
  }) : this._microseconds(_getMicroseconds(
          hour,
          minute,
          second,
          millisecond,
          microsecond,
        ));

  /// Creates a [TimeOfDay] using 12-hour format with AM/PM.
  ///
  /// [periodHour] must be between 1 and 12 (inclusive). Use [DayPeriod.am] for
  /// morning times and [DayPeriod.pm] for afternoon/evening times.
  ///
  /// Example:
  /// ```dart
  /// final morning = TimeOfDay.dayPeriod(periodHour: 9, period: DayPeriod.am); // 09:00
  /// final evening = TimeOfDay.dayPeriod(periodHour: 6, minute: 30, period: DayPeriod.pm); // 18:30
  /// final midnight = TimeOfDay.dayPeriod(periodHour: 12, period: DayPeriod.am); // 00:00
  /// final noon = TimeOfDay.dayPeriod(periodHour: 12, period: DayPeriod.pm); // 12:00
  /// ```
  TimeOfDay.dayPeriod({
    int periodHour = 12,
    int minute = 0,
    int second = 0,
    int millisecond = 0,
    int microsecond = 0,
    DayPeriod period = DayPeriod.am,
  })  : assert(periodHour > 0 && periodHour <= 12),
        _value = _getMicroseconds(
          _getHour(periodHour, period),
          minute,
          second,
          millisecond,
          microsecond,
        );

  /// Converts 12-hour format to 24-hour format.
  static int _getHour(int hourOfPeriod, DayPeriod period) {
    if (period == DayPeriod.pm) {
      if (hourOfPeriod == 12) {
        return hourOfPeriod;
      } else {
        return hourOfPeriod + 12;
      }
    } else {
      if (hourOfPeriod == 12 || hourOfPeriod == 0) {
        return 0;
      } else {
        return hourOfPeriod;
      }
    }
  }

  /// The hour component (0-24).
  int get hour => _value == Duration.microsecondsPerDay ? 24 : Duration(microseconds: _value).hours;

  /// The minute component (0-59).
  int get minute => Duration(microseconds: _value).minutes;

  /// The second component (0-59).
  int get second => Duration(microseconds: _value).seconds;

  /// The millisecond component (0-999).
  int get millisecond => Duration(microseconds: _value).milliseconds;

  /// The microsecond component (0-999).
  int get microsecond => Duration(microseconds: _value).microseconds;

  /// The period of the day (AM or PM).
  DayPeriod get period => hour < 12 || hour == 24 ? DayPeriod.am : DayPeriod.pm;

  /// The hour in 12-hour format (1-12).
  ///
  /// Converts 24-hour format to 12-hour format:
  /// - 0:00 (midnight) → 12
  /// - 1:00-11:00 → 1-11
  /// - 12:00 (noon) → 12
  /// - 13:00-23:00 → 1-11
  /// - 24:00 (end of day) → 12
  int get hourOfPeriod =>
      hour -
      (hour > 12
          ? 12
          : hour == 0
              ? -12
              : 0);

  /// Generates a list of [TimeOfDay] values starting from [seed].
  ///
  /// Creates [length] times by repeatedly adding [interval] to the previous time.
  ///
  /// [mode] controls overflow behavior (see [TimeAddOption]).
  /// [trimIfException] determines whether to return a partial list or throw an error
  /// when overflow occurs with [TimeAddOption.throwOnOverflow].
  ///
  /// Example:
  /// ```dart
  /// // Generate hourly times from 9 AM for 8 hours
  /// final workHours = TimeOfDay.generateByDurations(
  ///   TimeOfDay(hour: 9),
  ///   8,
  ///   Duration(hours: 1),
  /// );
  /// ```
  static List<TimeOfDay> generateByDurations(TimeOfDay seed, int length, Duration interval,
      {TimeAddOption mode = TimeAddOption.throwOnOverflow, bool trimIfException = true}) {
    var list = [seed];
    try {
      for (var i = 1; i < length; i++) {
        list.add(list[i - 1].add(interval, mode));
      }
      return list;
    } catch (e) {
      if (trimIfException) {
        return list;
      } else {
        rethrow;
      }
    }
  }

  /// Adds a [Duration] to this time, returning a new [TimeOfDay].
  ///
  /// [mode] controls what happens when the result would exceed 24:00:00:
  /// - [TimeAddOption.throwOnOverflow]: Throws an [ArgumentError] (safest)
  /// - [TimeAddOption.startNewDay]: Wraps around (e.g., 23:00 + 2h = 01:00)
  /// - [TimeAddOption.fromMidnight]: Starts from midnight with the duration (e.g., 23:00 + 2h = 02:00)
  ///
  /// Example:
  /// ```dart
  /// final time = TimeOfDay(hour: 14, minute: 30);
  /// final later = time.add(Duration(hours: 2)); // 16:30
  /// final wrapped = TimeOfDay(hour: 23).add(Duration(hours: 2), TimeAddOption.startNewDay); // 01:00
  /// ```
  TimeOfDay add(Duration duration, [TimeAddOption mode = TimeAddOption.startNewDay]) {
    var newValue = _value + duration.inMicroseconds;
    if (_isValidValue(newValue)) {
      return TimeOfDay._microseconds(newValue);
    } else {
      switch (mode) {
        case TimeAddOption.fromMidnight:
          return TimeOfDay._microseconds(duration.inMicroseconds);
        case TimeAddOption.startNewDay:
          return TimeOfDay._microseconds(newValue - Duration.microsecondsPerDay);
        case TimeAddOption.throwOnOverflow:
        default:
          throw ArgumentError.value(
              duration, 'duration', 'added duration should not allow time to exceed ${endOfDay.toString()}');
      }
    }
  }

  /// Returns true if this time is after [other].
  ///
  /// If [includeSameMoment] is true (default), returns true when times are equal.
  bool isAfter(TimeOfDay other, {bool includeSameMoment = true}) =>
      includeSameMoment ? _value >= other._value : _value > other._value;

  /// Returns true if this time is before [other].
  ///
  /// If [includeSameMoment] is true (default), returns true when times are equal.
  bool isBefore(TimeOfDay other, {bool includeSameMoment = true}) =>
      includeSameMoment ? _value <= other._value : _value < other._value;

  /// Returns true if this time is between [time1] and [time2] (inclusive by default).
  ///
  /// If [includeSameMoment] is false, returns false when this time equals either boundary.
  bool isBetween(TimeOfDay time1, TimeOfDay time2, {bool includeSameMoment = true}) {
    return isAfter(time1, includeSameMoment: includeSameMoment) &&
        isBefore(time2, includeSameMoment: includeSameMoment);
  }

  /// Compares this time to [other] for sorting.
  ///
  /// Returns a negative value if this < other, 0 if equal, positive if this > other.
  @override
  int compareTo(TimeOfDay other) => _value.compareTo(other._value);

  @override
  List<Object> get props => [_value];

  /// Returns a string representation of this time.
  ///
  /// Format: `h:{hour} m:{minute} s:{second} ms:{millisecond} μs:{microsecond}`
  @override
  String toString() => 'h:$hour m:$minute s:$second ms:$millisecond μs:$microsecond';

  /// Converts time components to total microseconds since midnight.
  static int _getMicroseconds(int hours, int minutes, int seconds, int milliseconds, int microseconds) {
    assert(hours <= 24);
    assert(minutes < 60);
    assert(seconds < 60);
    assert(milliseconds < 1000);
    assert(microseconds < 1000);
    var value = Duration.microsecondsPerHour * hours +
        Duration.microsecondsPerMinute * minutes +
        Duration.microsecondsPerSecond * seconds +
        Duration.microsecondsPerMillisecond * milliseconds +
        microseconds;
    assert(_isValidValue(value));
    return value;
  }

  /// Validates that a microseconds value is within the valid range (0-24 hours).
  static bool _isValidValue(int microseconds) => microseconds <= _maxValue;
}

/// Whether the [TimeOfDay] is before or after noon.
enum DayPeriod {
  /// Ante meridiem (before noon).
  am,

  /// Post meridiem (after noon).
  pm,
}

/// Controls overflow behavior when adding durations to a [TimeOfDay].
///
/// Example:
/// ```dart
/// final time = TimeOfDay(hour: 23);
///
/// // Throws an error
/// time.add(Duration(hours: 2), TimeAddOption.throwOnOverflow); // Error!
///
/// // Wraps around: 23:00 + 2h = 01:00
/// time.add(Duration(hours: 2), TimeAddOption.startNewDay); // 01:00
///
/// // Starts from midnight: 23:00 + 2h = 02:00 (ignores the 23:00 base)
/// time.add(Duration(hours: 2), TimeAddOption.fromMidnight); // 02:00
/// ```
enum TimeAddOption {
  /// Throws [ArgumentError] when the result exceeds 24:00:00.
  ///
  /// This is the safest option and helps catch logic errors.
  throwOnOverflow,

  /// Wraps around to the next day like a clock.
  ///
  /// Example: 23:00 + 2 hours = 01:00 (wraps around midnight)
  startNewDay,

  /// Ignores the base time and applies the duration from midnight.
  ///
  /// Example: 23:00 + 2 hours = 02:00 (uses only the 2-hour duration)
  fromMidnight,
}
