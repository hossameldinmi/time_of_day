import 'package:time_of_day/time_of_day.dart';

void main() {
  print('=== Basic Usage Examples ===\n');

  // Creating TimeOfDay instances
  print('1. Creating TimeOfDay instances:');
  final morning = TimeOfDay(hour: 8, minute: 30);
  print('   Morning: $morning');

  final now = TimeOfDay.now();
  print('   Current time: $now');

  final afternoon = TimeOfDay.dayPeriod(
    periodHour: 2,
    minute: 30,
    period: DayPeriod.pm,
  );
  print('   Afternoon (2:30 PM): $afternoon\n');

  // Predefined values
  print('2. Predefined constants:');
  print('   Midnight: ${TimeOfDay.midNight}');
  print('   Noon: ${TimeOfDay.noon}');
  print('   End of day: ${TimeOfDay.endOfDay}\n');

  // Accessing components
  print('3. Accessing time components:');
  final time = TimeOfDay(hour: 14, minute: 30, second: 45);
  print('   Time: $time');
  print('   Hour (24h): ${time.hour}');
  print('   Hour (12h): ${time.hourOfPeriod}');
  print('   Period: ${time.period == DayPeriod.am ? "AM" : "PM"}');
  print('   Minute: ${time.minute}');
  print('   Second: ${time.second}\n');

  // Adding durations
  print('4. Adding durations:');
  final start = TimeOfDay(hour: 9, minute: 0);
  final end = start.add(Duration(hours: 2, minutes: 30));
  print('   Start: $start');
  print('   Add 2h 30m: $end\n');

  // Comparing times
  print('5. Comparing times:');
  final time1 = TimeOfDay(hour: 10, minute: 0);
  final time2 = TimeOfDay(hour: 14, minute: 0);
  print('   10:00 is before 14:00: ${time1.isBefore(time2)}');
  print('   14:00 is after 10:00: ${time2.isAfter(time1)}');
  print('   12:00 is between 10:00 and 14:00: ${TimeOfDay.noon.isBetween(time1, time2)}');
}
