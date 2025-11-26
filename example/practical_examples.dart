import 'package:time_of_day/time_of_day.dart';

void main() {
  print('=== Practical Use Cases ===\n');

  // Use case 1: Business hours validation
  print('1. Business Hours Validation:');
  bool isBusinessHours(TimeOfDay time) {
    final start = TimeOfDay(hour: 9);
    final end = TimeOfDay(hour: 17);
    return time.isBetween(start, end);
  }

  final testTimes = [
    TimeOfDay(hour: 8, minute: 30),
    TimeOfDay(hour: 9, minute: 0),
    TimeOfDay(hour: 12, minute: 30),
    TimeOfDay(hour: 17, minute: 0),
    TimeOfDay(hour: 18, minute: 30),
  ];

  for (final time in testTimes) {
    final status = isBusinessHours(time) ? '✓ Open' : '✗ Closed';
    print('   ${time.hour}:${time.minute.toString().padLeft(2, '0')} - $status');
  }

  // Use case 2: Appointment scheduling
  print('\n2. Appointment Scheduling:');
  final appointments = <TimeOfDay, String>{
    TimeOfDay(hour: 9, minute: 0): 'Team Meeting',
    TimeOfDay(hour: 11, minute: 30): 'Client Call',
    TimeOfDay(hour: 14, minute: 0): 'Project Review',
  };

  final sortedKeys = appointments.keys.toList()..sort();
  for (final time in sortedKeys) {
    final hour12 = time.hourOfPeriod;
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    print(
        '   ${hour12.toString().padLeft(2, ' ')}:${time.minute.toString().padLeft(2, '0')} $period - ${appointments[time]}');
  }

  // Use case 3: Time until next event
  print('\n3. Time Until Next Event:');
  final currentTime = TimeOfDay(hour: 10, minute: 15);
  final nextMeeting = TimeOfDay(hour: 11, minute: 30);

  // Calculate duration (simplified - in real app use Duration subtraction)
  final hoursUntil = nextMeeting.hour - currentTime.hour;
  final minutesUntil = nextMeeting.minute - currentTime.minute;
  final totalMinutes = hoursUntil * 60 + minutesUntil;

  print('   Current time: ${currentTime.hour}:${currentTime.minute.toString().padLeft(2, '0')}');
  print('   Next meeting: ${nextMeeting.hour}:${nextMeeting.minute.toString().padLeft(2, '0')}');
  print('   Time until meeting: ${totalMinutes} minutes');

  // Use case 4: Lunch break validation
  print('\n4. Lunch Break Validation:');
  bool isLunchTime(TimeOfDay time) {
    final lunchStart = TimeOfDay(hour: 12);
    final lunchEnd = TimeOfDay(hour: 13);
    return time.isBetween(lunchStart, lunchEnd, includeSameMoment: false);
  }

  final checkTimes = [
    TimeOfDay(hour: 11, minute: 55),
    TimeOfDay(hour: 12, minute: 0),
    TimeOfDay(hour: 12, minute: 30),
    TimeOfDay(hour: 13, minute: 0),
    TimeOfDay(hour: 13, minute: 5),
  ];

  for (final time in checkTimes) {
    final status = isLunchTime(time) ? '🍽️  Lunch time' : '💼 Working hours';
    print('   ${time.hour}:${time.minute.toString().padLeft(2, '0')} - $status');
  }

  // Use case 5: Shift rotation
  print('\n5. Shift Rotation:');
  final shifts = {
    'Morning': TimeOfDay(hour: 6),
    'Day': TimeOfDay(hour: 14),
    'Night': TimeOfDay(hour: 22),
  };

  shifts.forEach((name, startTime) {
    final endTime = startTime.add(Duration(hours: 8), TimeAddOption.startNewDay);
    final startHour12 = startTime.hourOfPeriod;
    final endHour12 = endTime.hourOfPeriod;
    final startPeriod = startTime.period == DayPeriod.am ? 'AM' : 'PM';
    final endPeriod = endTime.period == DayPeriod.am ? 'AM' : 'PM';

    print(
        '   $name Shift: ${startHour12.toString().padLeft(2, ' ')}:00 $startPeriod - ${endHour12.toString().padLeft(2, ' ')}:00 $endPeriod');
  });
}
