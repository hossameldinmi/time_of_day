<h2 align="center">
  Time of Day
</h2>

<p align="center">
   <a href="https://github.com/hossameldinmi/time_of_day/actions/workflows/build.yml">
    <img src="https://github.com/hossameldinmi/time_of_day/actions/workflows/build.yml/badge.svg?branch=main" alt="Github action">
  </a>
  <a href="https://codecov.io/github/hossameldinmi/time_of_day">
    <img src="https://codecov.io/github/hossameldinmi/time_of_day/graph/badge.svg?token=JzTIIzoQOq" alt="Code Coverage">
  </a>
  <a href="https://pub.dev/packages/time_of_day">
    <img alt="Pub Package" src="https://img.shields.io/pub/v/time_of_day">
  </a>
   <a href="https://pub.dev/packages/time_of_day">
    <img alt="Pub Points" src="https://img.shields.io/pub/points/time_of_day">
  </a>
  <br/>
  <a href="https://opensource.org/licenses/MIT">
    <img alt="MIT License" src="https://img.shields.io/badge/License-MIT-blue.svg">
  </a>
    <img src="https://img.shields.io/badge/platform-Android%20%7C%20iOS%20%7C%20macOS%20%7C%20Windows%20%7C%20Linux%20%7C%20Web-blue" alt="Platforms">
</p>

A type-safe Dart package for representing and manipulating time of day values with microsecond precision, supporting AM/PM periods, time comparisons, and safe arithmetic operations.

## Features

- 🕐 **Microsecond precision** - Accurate time representation down to the microsecond
- 🔢 **Multiple constructors** - Create from hour/minute/second, DateTime, or AM/PM format
- ➕ **Safe arithmetic** - Add durations with overflow protection and multiple handling modes
- ⚖️ **Time comparisons** - Compare times with `isAfter`, `isBefore`, `isBetween`
- 🌓 **AM/PM support** - Work with 12-hour format and day periods
- 📊 **Time generation** - Generate time sequences with custom intervals
- ✅ **Equatable** - Built-in equality and comparison support
- 🧩 **Duration extensions** - Convenient extensions for working with Duration components

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  time_of_day: ^1.0.1
```

Then run:

```bash
dart pub get
```

## Usage

### Creating TimeOfDay instances

```dart
import 'package:time_of_day/time_of_day.dart';

// From hour and minute
final morning = TimeOfDay(hour: 8, minute: 30);

// From current time
final now = TimeOfDay.now();

// From DateTime
final fromDate = TimeOfDay.fromDateTime(DateTime(2024, 1, 1, 14, 30));

// Using AM/PM format
final afternoon = TimeOfDay.dayPeriod(
  periodHour: 2,
  minute: 30,
  period: DayPeriod.pm, // 2:30 PM = 14:30
);

// Predefined values
final midnight = TimeOfDay.midNight; // 00:00:00
final noon = TimeOfDay.noon;         // 12:00:00
final endOfDay = TimeOfDay.endOfDay; // 24:00:00

// With full precision
final precise = TimeOfDay(
  hour: 15,
  minute: 30,
  second: 45,
  millisecond: 500,
  microsecond: 250,
);
```

### Accessing components

```dart
final time = TimeOfDay(hour: 14, minute: 30, second: 45);

print(time.hour);         // 14
print(time.minute);       // 30
print(time.second);       // 45
print(time.period);       // DayPeriod.pm
print(time.hourOfPeriod); // 2 (for 2:30 PM)
```

### Adding durations

```dart
final start = TimeOfDay(hour: 8, minute: 30);

// Default: wraps around to next day
final end = start.add(Duration(hours: 2, minutes: 15));
print(end); // h:10 m:45 s:0 ms:0 μs:0

// Strict mode: throws exception if result exceeds 24:00:00
final strict = TimeOfDay(hour: 23).add(
  Duration(hours: 2),
  TimeAddOption.throwOnOverflow,
); // Throws ArgumentError

// Wrap around mode: wraps like a clock
final wrapped = TimeOfDay(hour: 23).add(
  Duration(hours: 2),
  TimeAddOption.startNewDay,
); // 23:00 + 2h = 01:00

// From midnight mode: uses only the duration from midnight
final fromMidnight = TimeOfDay(hour: 23).add(
  Duration(hours: 2),
  TimeAddOption.fromMidnight,
); // 23:00 + 2h = 02:00 (ignores the 23:00 base)
```

### Comparing times

```dart
final morning = TimeOfDay(hour: 8, minute: 0);
final afternoon = TimeOfDay(hour: 14, minute: 0);
final evening = TimeOfDay(hour: 18, minute: 0);

// Check if one time is after another
print(afternoon.isAfter(morning)); // true

// Check if one time is before another
print(morning.isBefore(afternoon)); // true

// Check if time is between two times
print(afternoon.isBetween(morning, evening)); // true

// Exclude same moment
print(morning.isAfter(morning, orSameMoment: false)); // false

// Compare times
print(afternoon.compareTo(morning)); // positive number
print(morning.compareTo(afternoon)); // negative number
print(morning.compareTo(morning));   // 0
```

### Generating time sequences

```dart
// Generate times every 30 minutes starting from 9:00 AM
final schedule = TimeOfDay.generateByDurations(
  TimeOfDay(hour: 9),
  8, // Generate 8 times
  Duration(minutes: 30),
);
// [9:00, 9:30, 10:00, 10:30, 11:00, 11:30, 12:00, 12:30]

// With wrap around handling
final allDay = TimeOfDay.generateByDurations(
  TimeOfDay(hour: 22),
  10,
  Duration(hours: 1),
  mode: TimeAddOption.startNewDay,
);

// Trim if exception occurs (default mode is throwOnOverflow)
final trimmed = TimeOfDay.generateByDurations(
  TimeOfDay(hour: 20),
  10,
  Duration(hours: 2),
  mode: TimeAddOption.throwOnOverflow,
  trimIfException: true, // Stops generating when 24:00:00 is exceeded
);
```

### Duration extensions

```dart
import 'package:time_of_day/src/duration_extensions.dart';

final duration = Duration(
  hours: 25,
  minutes: 90,
  seconds: 150,
);

// Get normalized components (within their valid ranges)
print(duration.hours);        // 1 (25 % 24)
print(duration.minutes);      // 30 (90 % 60)
print(duration.seconds);      // 30 (150 % 60)
print(duration.milliseconds); // Milliseconds within a second
print(duration.microseconds); // Microseconds within a millisecond
```

### Equality and comparison

```dart
final time1 = TimeOfDay(hour: 10, minute: 30);
final time2 = TimeOfDay(hour: 10, minute: 30);
final time3 = TimeOfDay(hour: 11, minute: 0);

print(time1 == time2); // true (uses Equatable)
print(time1 == time3); // false

// Sorting
final times = [time3, time1, time2];
times.sort(); // [time1, time2, time3] (implements Comparable)
```

## API Reference

### TimeOfDay class

**Constructors:**
- `TimeOfDay({int hour, int minute, int second, int millisecond, int microsecond})` - Create from components
- `TimeOfDay.now()` - Create from current time
- `TimeOfDay.fromDateTime(DateTime)` - Create from DateTime
- `TimeOfDay.dayPeriod({int periodHour, int minute, ..., DayPeriod period})` - Create using AM/PM format

**Static values:**
- `TimeOfDay.midNight` - 00:00:00
- `TimeOfDay.noon` - 12:00:00
- `TimeOfDay.endOfDay` - 24:00:00

**Properties:**
- `int hour` - Hour (0-24)
- `int minute` - Minute (0-59)
- `int second` - Second (0-59)
- `int millisecond` - Millisecond (0-999)
- `int microsecond` - Microsecond (0-999)
- `DayPeriod period` - AM or PM
- `int hourOfPeriod` - Hour in 12-hour format (1-12)

**Methods:**
- `add(Duration, [TimeAddOption])` - Add duration with overflow handling
- `isAfter(TimeOfDay, {bool orSameMoment})` - Check if after another time
- `isBefore(TimeOfDay, {bool orSameMoment})` - Check if before another time
- `isBetween(TimeOfDay, TimeOfDay, {bool includeSameMoment})` - Check if between two times
- `compareTo(TimeOfDay)` - Compare times (implements Comparable)

**Static methods:**
- `generateByDurations(TimeOfDay seed, int length, Duration duration, ...)` - Generate time sequence

### Enums

**DayPeriod:**
- `DayPeriod.am` - Ante meridiem (before noon)
- `DayPeriod.pm` - Post meridiem (after noon)

**TimeAddOption:**
- `TimeAddOption.throwOnOverflow` - Throw exception if result exceeds 24:00:00 (safest)
- `TimeAddOption.startNewDay` - Wrap around to next day like a clock (default)
- `TimeAddOption.fromMidnight` - Apply duration from midnight, ignoring base time

### Duration Extensions

- `hours` - Hours within a day (0-23)
- `minutes` - Minutes within an hour (0-59)
- `seconds` - Seconds within a minute (0-59)
- `milliseconds` - Milliseconds within a second (0-999)
- `microseconds` - Microseconds within a millisecond (0-999)

## Examples

### Scheduling System

```dart
// Create a schedule from 9 AM to 5 PM with 1-hour intervals
final workday = TimeOfDay.generateByDurations(
  TimeOfDay(hour: 9),
  9, // 9 hours
  Duration(hours: 1),
);

print('Work schedule:');
for (final time in workday) {
  print('${time.hourOfPeriod}:${time.minute.toString().padLeft(2, '0')} ${time.period.name.toUpperCase()}');
}
```

### Time Range Validation

```dart
bool isBusinessHours(TimeOfDay time) {
  final start = TimeOfDay(hour: 9);
  final end = TimeOfDay(hour: 17);
  return time.isBetween(start, end);
}

final now = TimeOfDay.now();
print('Open: ${isBusinessHours(now)}');
```

### Shift Management

```dart
final shiftStart = TimeOfDay(hour: 22); // 10 PM
final shiftDuration = Duration(hours: 8);

final shiftEnd = shiftStart.add(
  shiftDuration,
  TimeAddOption.startNewDay,
); // 6 AM next day

print('Shift: ${shiftStart} to ${shiftEnd}');
```

## License

MIT License - see [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Author

Hossam Eldin Mahmoud - [GitHub](https://github.com/hossameldinmi)