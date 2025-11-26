import 'package:time_of_day/time_of_day.dart';

void main() {
  print('=== Overflow Handling Examples ===\n');

  final lateNight = TimeOfDay(hour: 23, minute: 0);
  print('Starting time: $lateNight (23:00)\n');

  // Default behavior: wrap around to next day
  print('1. Default (startNewDay) - Wraps around like a clock:');
  final wrapped = lateNight.add(Duration(hours: 2));
  print('   23:00 + 2 hours = $wrapped');
  print('   Result: ${wrapped.hour}:${wrapped.minute.toString().padLeft(2, '0')}\n');

  // Strict mode: throws exception
  print('2. throwOnOverflow - Throws exception for safety:');
  try {
    lateNight.add(Duration(hours: 2), TimeAddOption.throwOnOverflow);
    print('   No exception thrown');
  } catch (e) {
    print('   ✓ Exception caught: $e\n');
  }

  // From midnight: applies duration from 00:00
  print('3. fromMidnight - Applies duration from midnight:');
  final fromMidnight = lateNight.add(Duration(hours: 2), TimeAddOption.fromMidnight);
  print('   23:00 + 2 hours (from midnight) = $fromMidnight');
  print('   Result: ${fromMidnight.hour}:${fromMidnight.minute.toString().padLeft(2, '0')}\n');

  // Practical example: overnight shift
  print('=== Overnight Shift Example ===');
  final shiftStart = TimeOfDay(hour: 22, minute: 0); // 10 PM
  final shiftDuration = Duration(hours: 8);

  final shiftEnd = shiftStart.add(shiftDuration, TimeAddOption.startNewDay);
  print('Shift starts: ${shiftStart.hourOfPeriod}:00 ${shiftStart.period == DayPeriod.am ? "AM" : "PM"}');
  print('Shift ends: ${shiftEnd.hourOfPeriod}:00 ${shiftEnd.period == DayPeriod.am ? "AM" : "PM"}');
  print('(${shiftEnd.hour}:00 in 24-hour format)');
}
