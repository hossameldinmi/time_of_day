import 'package:time_of_day/time_of_day.dart';

void main() {
  print('=== Time Sequence Generation Examples ===\n');

  // Generate hourly schedule
  print('1. Hourly schedule (9 AM - 5 PM):');
  final workHours = TimeOfDay.generateByDurations(
    TimeOfDay(hour: 9),
    9, // 9 hours
    Duration(hours: 1),
  );

  for (final time in workHours) {
    final hour12 = time.hourOfPeriod;
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    print('   ${hour12.toString().padLeft(2, ' ')}:00 $period');
  }

  // Generate times every 30 minutes
  print('\n2. Meeting schedule (every 30 minutes from 9:00):');
  final meetings = TimeOfDay.generateByDurations(
    TimeOfDay(hour: 9),
    8, // 8 slots
    Duration(minutes: 30),
  );

  for (var i = 0; i < meetings.length; i++) {
    final time = meetings[i];
    print('   Slot ${i + 1}: ${time.hour}:${time.minute.toString().padLeft(2, '0')}');
  }

  // Generate with wrap-around
  print('\n3. Night shift schedule (with wrap-around):');
  final nightShift = TimeOfDay.generateByDurations(
    TimeOfDay(hour: 22),
    10,
    Duration(hours: 1),
    mode: TimeAddOption.startNewDay,
  );

  for (final time in nightShift) {
    final hour12 = time.hourOfPeriod;
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    print('   ${hour12.toString().padLeft(2, ' ')}:00 $period (${time.hour}:00)');
  }

  // Generate with automatic trimming
  print('\n4. Limited schedule (auto-trim when exceeding 24:00):');
  final limited = TimeOfDay.generateByDurations(
    TimeOfDay(hour: 20),
    10,
    Duration(hours: 1),
    mode: TimeAddOption.throwOnOverflow,
    trimIfException: true,
  );

  print('   Generated ${limited.length} time slots (stopped at 24:00):');
  for (final time in limited) {
    print('   ${time.hour}:00');
  }
}
