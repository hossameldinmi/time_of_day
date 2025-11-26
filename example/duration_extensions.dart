import 'package:time_of_day/time_of_day.dart';

void main() {
  print('=== Duration Extensions Examples ===\n');

  // Example 1: Normalize overflow durations
  print('1. Normalizing overflow durations:');
  final duration1 = Duration(hours: 25, minutes: 90, seconds: 150);
  print('   Total: 25h 90m 150s');
  print('   Normalized hours: ${duration1.hours} (25 % 24)');
  print('   Normalized minutes: ${duration1.minutes} (90 % 60)');
  print('   Normalized seconds: ${duration1.seconds} (150 % 60)\n');

  // Example 2: Time component extraction
  print('2. Extracting time components:');
  final duration2 = Duration(
    hours: 2,
    minutes: 45,
    seconds: 30,
    milliseconds: 750,
    microseconds: 500,
  );
  print('   Duration: 2h 45m 30s 750ms 500μs');
  print('   Hours: ${duration2.hours}');
  print('   Minutes: ${duration2.minutes}');
  print('   Seconds: ${duration2.seconds}');
  print('   Milliseconds: ${duration2.milliseconds}');
  print('   Microseconds: ${duration2.microseconds}\n');

  // Example 3: Working with time of day
  print('3. Using with TimeOfDay:');
  final time = TimeOfDay(hour: 10, minute: 30);
  final offset = Duration(hours: 5, minutes: 45);

  final result = time.add(offset);
  print('   Start time: ${time.hour}:${time.minute.toString().padLeft(2, '0')}');
  print('   Add: ${offset.hours}h ${offset.minutes}m');
  print('   Result: ${result.hour}:${result.minute.toString().padLeft(2, '0')}\n');

  // Example 4: Multiple day durations
  print('4. Multiple day durations:');
  final threeDays = Duration(days: 3, hours: 5);
  print('   Total duration: 3 days + 5 hours');
  print('   Total hours: ${threeDays.inHours}');
  print('   Hours within day: ${threeDays.hours} (${threeDays.inHours} % 24)\n');

  // Example 5: Precise time calculations
  print('5. Microsecond precision:');
  final precise = Duration(
    milliseconds: 2500,
    microseconds: 3750,
  );
  print('   Total: 2500ms + 3750μs');
  print('   Milliseconds in second: ${precise.milliseconds}');
  print('   Microseconds in millisecond: ${precise.microseconds}');
  print('   Total milliseconds: ${precise.inMilliseconds}');
  print('   Total microseconds: ${precise.inMicroseconds}');
}
