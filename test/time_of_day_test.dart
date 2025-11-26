import 'package:test/test.dart';
import 'package:time_of_day/src/time_of_day.dart';
import 'package:clock/clock.dart';

void main() {
  group('Constructor', () {
    group('Default Constructor', () {
      test('Expected run normally with valid values', () {
        expect(() => TimeOfDay(), returnsNormally);
        expect(() => TimeOfDay(hour: 23), returnsNormally);
        expect(() => TimeOfDay(hour: 23, minute: 24), returnsNormally);
        expect(() => TimeOfDay(hour: 23, second: 24), returnsNormally);
        expect(() => TimeOfDay(hour: 23, millisecond: 24), returnsNormally);
        expect(() => TimeOfDay(hour: 23, millisecond: 999), returnsNormally);
        expect(() => TimeOfDay(hour: 23, microsecond: 24), returnsNormally);
        expect(() => TimeOfDay(hour: 23, microsecond: 999), returnsNormally);
      });

      test('Expected hour = 24 for endOfDay', () {
        final time = TimeOfDay(hour: 24);
        expect(time, TimeOfDay.endOfDay);
      });
      test('Expected AssertionError when initialize with invalid values', () {
        expect(() => TimeOfDay(hour: 24, minute: 60), throwsA(isA<AssertionError>()));
        expect(() => TimeOfDay(hour: 23, minute: 60), throwsA(isA<AssertionError>()));
        expect(() => TimeOfDay(hour: 23, second: 60), throwsA(isA<AssertionError>()));
        expect(() => TimeOfDay(hour: 23, millisecond: 1000), throwsA(isA<AssertionError>()));
        expect(() => TimeOfDay(hour: 23, microsecond: 1000), throwsA(isA<AssertionError>()));
        expect(() => TimeOfDay(hour: 24, second: 60), throwsA(isA<AssertionError>()));
        expect(() => TimeOfDay(hour: 24, millisecond: 1000), throwsA(isA<AssertionError>()));
        expect(() => TimeOfDay(hour: 24, microsecond: 1), throwsA(isA<AssertionError>()));
      });
    });
    group('TimeOfDay.now()', () {
      test('Expected run normaly when Initialize Time with now()', () {
        final now = DateTime(2024, 5, 20, 0, 0, 0, 0, 0);
        withClock(Clock.fixed(now), () {
          expect(
            TimeOfDay.now(),
            TimeOfDay(
              hour: now.hour,
              minute: now.minute,
              second: now.second,
              millisecond: now.millisecond,
              microsecond: now.microsecond,
            ),
          );
        });
      });
    });
    group('dayPeriod', () {
      test('Expected correct hour conversion for AM/PM periods', () {
        // Midnight cases (12 AM = 0:00)
        expect(TimeOfDay.dayPeriod(), TimeOfDay.midNight);
        expect(TimeOfDay.dayPeriod(periodHour: 12, period: DayPeriod.am), TimeOfDay.midNight);

        // Noon cases (12 PM = 12:00)
        expect(TimeOfDay.dayPeriod(periodHour: 12, period: DayPeriod.pm), TimeOfDay.noon);
        expect(TimeOfDay.dayPeriod(periodHour: 12, period: DayPeriod.pm).hour, 12);

        // PM conversion (6 PM = 18:00)
        expect(TimeOfDay.dayPeriod(periodHour: 6, period: DayPeriod.pm).hour, 18);
      });

      test('Expected AssertionError when Initialize Time with hour > 12', () {
        expect(() => TimeOfDay.dayPeriod(periodHour: 13), throwsA(isA<AssertionError>()));
      });
    });

    group('fromDateTime', () {
      test('expected exact time', () {
        expect(
            TimeOfDay.fromDateTime(DateTime(2020, 1, 4, 5, 7, 8, 124, 566)),
            TimeOfDay(
              hour: 5,
              minute: 7,
              second: 8,
              millisecond: 124,
              microsecond: 566,
            ));
      });
    });
  });

  group('hour', () {
    test('expected hour=1 if time is exactly 1 hour', () {
      final time = TimeOfDay(hour: 1);
      expect(time.hour, 1);
    });
    test('expected exact hour if time has extra minutes,seconds,milliseconds and microseconds', () {
      final hour = 3;
      final time = TimeOfDay(hour: hour, minute: 30);
      final time2 = TimeOfDay(hour: hour, minute: 49);
      final time3 = TimeOfDay(hour: hour, minute: 30, second: 20);
      final time4 = TimeOfDay(hour: hour, minute: 49, second: 50);
      final time5 = TimeOfDay(hour: hour, minute: 49, second: 59, millisecond: 45);
      final time6 = TimeOfDay(hour: hour, minute: 49, second: 59, millisecond: 1);
      final time7 = TimeOfDay(hour: hour, minute: 49, second: 59, millisecond: 59, microsecond: 5);
      final time8 = TimeOfDay(hour: hour, minute: 49, second: 59, millisecond: 59, microsecond: 59);
      final time9 = TimeOfDay.endOfDay;
      expect(time.hour, hour);
      expect(time2.hour, hour);
      expect(time3.hour, hour);
      expect(time4.hour, hour);
      expect(time5.hour, hour);
      expect(time6.hour, hour);
      expect(time7.hour, hour);
      expect(time8.hour, hour);
      expect(time8.hour, hour);
      expect(time9.hour, 24);
    });
  });

  group('hourOfPeriod', () {
    test('expected exact hourOfPeriod if time has extra minutes,seconds,milliseconds and microseconds', () {
      final time = TimeOfDay(hour: 1, minute: 30);
      final time2 = TimeOfDay(hour: 12, minute: 49);
      final time3 = TimeOfDay(hour: 16, minute: 30, second: 20);
      final time4 = TimeOfDay(hour: 23, minute: 49, second: 50);
      final time5 = TimeOfDay(hour: 0, minute: 49, second: 50);
      final time6 = TimeOfDay.endOfDay;

      expect(time.hourOfPeriod, 1);
      expect(time2.hourOfPeriod, 12);
      expect(time3.hourOfPeriod, 4);
      expect(time4.hourOfPeriod, 11);
      expect(time5.hourOfPeriod, 12);
      expect(time6.hourOfPeriod, 12);
    });
  });

  group('period', () {
    test('expected exact dayPeriod', () {
      final time = TimeOfDay(hour: 1, minute: 30);
      final time2 = TimeOfDay(hour: 12, minute: 49);
      final time3 = TimeOfDay(hour: 16, minute: 30, second: 20);
      final time4 = TimeOfDay(hour: 23, minute: 49, second: 50);
      final time5 = TimeOfDay(hour: 0, minute: 49, second: 50);
      final time6 = TimeOfDay.endOfDay;

      expect(time.period, DayPeriod.am);
      expect(time2.period, DayPeriod.pm);
      expect(time3.period, DayPeriod.pm);
      expect(time4.period, DayPeriod.pm);
      expect(time5.period, DayPeriod.am);
      expect(time6.period, DayPeriod.am);
    });
  });
  group('minute', () {
    test('expected exact minute', () {
      final time = TimeOfDay(hour: 1, minute: 30);
      final time2 = TimeOfDay(hour: 2, minute: 49);
      final time3 = TimeOfDay(hour: 23, minute: 59, second: 20);
      final time4 = TimeOfDay(hour: 10, minute: 0, second: 50);
      final time5 = TimeOfDay(hour: 12, minute: 20, second: 59, millisecond: 45);
      final time6 = TimeOfDay(hour: 15, minute: 54, second: 59, millisecond: 1);
      final time7 = TimeOfDay(
        minute: 1,
        second: 50,
        millisecond: 59,
        microsecond: 5,
      );
      final time8 = TimeOfDay(
        hour: 6,
        minute: 30,
        second: 30,
        millisecond: 59,
        microsecond: 59,
      );
      expect(time.minute, 30);
      expect(time2.minute, 49);
      expect(time3.minute, 59);
      expect(time4.minute, 0);
      expect(time5.minute, 20);
      expect(time6.minute, 54);
      expect(time7.minute, 1);
      expect(time8.minute, 30);
    });
  });

  group('second', () {
    test('expected exact second', () {
      final time = TimeOfDay(hour: 1, minute: 30);
      final time2 = TimeOfDay(hour: 2, second: 49);
      final time3 = TimeOfDay(hour: 23, minute: 59, second: 20);
      final time4 = TimeOfDay(hour: 10, minute: 0, second: 50);
      final time5 = TimeOfDay(hour: 12, minute: 20, second: 59, millisecond: 45);
      final time6 = TimeOfDay(hour: 15, minute: 54, second: 59, millisecond: 1);
      final time7 = TimeOfDay(
        minute: 1,
        second: 1,
        millisecond: 59,
        microsecond: 5,
      );
      final time8 = TimeOfDay(
        hour: 6,
        minute: 30,
        millisecond: 59,
        microsecond: 59,
      );
      expect(time.second, 0);
      expect(time2.second, 49);
      expect(time3.second, 20);
      expect(time4.second, 50);
      expect(time5.second, 59);
      expect(time6.second, 59);
      expect(time7.second, 1);
      expect(time8.second, 0);
    });
  });

  group('millisecond', () {
    test('expected exact millisecond', () {
      final time = TimeOfDay(hour: 1, minute: 30);
      final time2 = TimeOfDay(hour: 2, minute: 30, second: 49, millisecond: 49);
      final time3 = TimeOfDay(hour: 23, second: 59, millisecond: 20);
      final time4 = TimeOfDay(hour: 10, minute: 0, millisecond: 50);
      final time5 = TimeOfDay(hour: 12, minute: 20, second: 59, millisecond: 999);
      final time6 = TimeOfDay(hour: 15, minute: 54, second: 59, millisecond: 1);
      final time7 = TimeOfDay(
        hour: 20,
        minute: 1,
        second: 1,
        microsecond: 500,
      );
      final time8 = TimeOfDay(
        hour: 6,
        minute: 30,
        millisecond: 500,
        microsecond: 999,
      );
      expect(time.millisecond, 0);
      expect(time2.millisecond, 49);
      expect(time3.millisecond, 20);
      expect(time4.millisecond, 50);
      expect(time5.millisecond, 999);
      expect(time6.millisecond, 1);
      expect(time7.millisecond, 0);
      expect(time8.millisecond, 500);
    });
  });

  group('generateByDurations', () {
    test('expected exact Time List for 24 and 25 hours', () {
      final list24 = TimeOfDay.generateByDurations(TimeOfDay.midNight, 24, const Duration(hours: 1));
      expect(list24.length, 24);
      expect(list24.first, TimeOfDay.midNight);
      expect(list24.last, TimeOfDay(hour: 23));

      final list25 = TimeOfDay.generateByDurations(TimeOfDay.midNight, 25, const Duration(hours: 1));
      expect(list25.length, 25);
      expect(list25.first, TimeOfDay.midNight);
      expect(list25.last, TimeOfDay.endOfDay);
      expect(list25[12], TimeOfDay.noon);
    });
    test('expected list with only 1 Time if length = 1', () {
      final list = TimeOfDay.generateByDurations(TimeOfDay.midNight, 1, const Duration(hours: 1));
      expect(list, [
        TimeOfDay.midNight,
      ]);
    });
    test('expected trimed List if time exceded the day Time', () {
      final list = TimeOfDay.generateByDurations(TimeOfDay.noon, 24, const Duration(hours: 1));
      expect(list, [
        TimeOfDay(hour: 12),
        TimeOfDay(hour: 13),
        TimeOfDay(hour: 14),
        TimeOfDay(hour: 15),
        TimeOfDay(hour: 16),
        TimeOfDay(hour: 17),
        TimeOfDay(hour: 18),
        TimeOfDay(hour: 19),
        TimeOfDay(hour: 20),
        TimeOfDay(hour: 21),
        TimeOfDay(hour: 22),
        TimeOfDay(hour: 23),
        TimeOfDay(hour: 24),
      ]);
    });

    test('expected exception if time exceded the day Time', () {
      expect(() => TimeOfDay.generateByDurations(TimeOfDay.noon, 24, const Duration(hours: 1), trimIfException: false),
          throwsArgumentError);
    });
  });

  group('isAfter', () {
    test('expected correct comparison results', () {
      expect(TimeOfDay.noon.isAfter(TimeOfDay.midNight), true);
      expect(TimeOfDay.midNight.isAfter(TimeOfDay.midNight), true);
      expect(TimeOfDay.midNight.isAfter(TimeOfDay.midNight, includeSameMoment: false), false);
    });
  });

  group('isBefore', () {
    test('expected correct comparison results', () {
      expect(TimeOfDay.noon.isBefore(TimeOfDay(hour: 23)), true);
      expect(TimeOfDay.noon.isBefore(TimeOfDay(hour: 23), includeSameMoment: false), true);
      expect(TimeOfDay.noon.isBefore(TimeOfDay.noon), true);
      expect(TimeOfDay.noon.isBefore(TimeOfDay.noon, includeSameMoment: false), false);
    });
  });

  group('isBetween', () {
    test('expected correct comparison results', () {
      // Time is between two times
      expect(TimeOfDay.noon.isBetween(TimeOfDay.midNight, TimeOfDay.endOfDay), true);
      expect(TimeOfDay.noon.isBetween(TimeOfDay.midNight, TimeOfDay.endOfDay, includeSameMoment: false), true);

      // Time equals one of the boundaries
      expect(TimeOfDay.noon.isBetween(TimeOfDay.noon, TimeOfDay.endOfDay), true);
      expect(TimeOfDay.noon.isBetween(TimeOfDay.midNight, TimeOfDay.noon), true);
      expect(TimeOfDay.noon.isBetween(TimeOfDay.noon, TimeOfDay.endOfDay, includeSameMoment: false), false);
      expect(TimeOfDay.noon.isBetween(TimeOfDay.midNight, TimeOfDay.noon, includeSameMoment: false), false);

      // Time is NOT between two times
      expect(TimeOfDay.midNight.isBetween(TimeOfDay.noon, TimeOfDay.endOfDay), false);
      expect(TimeOfDay.midNight.isBetween(TimeOfDay.noon, TimeOfDay.endOfDay, includeSameMoment: false), false);
    });
  });

  group('add', () {
    test('expected correct behavior for all TimeAddOption modes', () {
      // Normal addition within day
      expect(TimeOfDay.noon.add(const Duration(hours: 1)), TimeOfDay(hour: 13));
      expect(TimeOfDay(hour: 23).add(const Duration(hours: 1)), TimeOfDay.endOfDay);

      // Exception mode (default) - throws when exceeding 24:00
      expect(
          () => TimeOfDay(hour: 23).add(const Duration(hours: 2), TimeAddOption.throwOnOverflow), throwsArgumentError);
      expect(
          () => TimeOfDay.endOfDay.add(const Duration(hours: 2), TimeAddOption.throwOnOverflow), throwsArgumentError);

      // ResetToZero mode - starts from 00:00
      expect(TimeOfDay(hour: 23).add(const Duration(hours: 2), TimeAddOption.fromMidnight), TimeOfDay(hour: 2));

      // Overflow mode - wraps to next day
      expect(TimeOfDay(hour: 23).add(const Duration(hours: 2), TimeAddOption.startNewDay), TimeOfDay(hour: 1));
    });
  });

  group('compare', () {
    test('sort list with and without duplicates', () {
      // Test sorting without duplicates
      final list = [
        TimeOfDay(hour: 1),
        TimeOfDay.midNight,
        TimeOfDay(hour: 2),
        TimeOfDay(hour: 5),
        TimeOfDay(hour: 3),
        TimeOfDay(hour: 22),
        TimeOfDay(hour: 21),
        TimeOfDay.endOfDay,
      ];
      list.sort();
      expect(list.first, TimeOfDay.midNight);
      expect(list.last, TimeOfDay.endOfDay);
      expect(list[1], TimeOfDay(hour: 1));
      expect(list[2], TimeOfDay(hour: 2));

      // Test sorting with duplicates
      final listWithDupes = [
        TimeOfDay(hour: 1),
        TimeOfDay(hour: 1),
        TimeOfDay.midNight,
        TimeOfDay(hour: 5),
        TimeOfDay(hour: 5),
      ];
      listWithDupes.sort();
      expect(listWithDupes, [
        TimeOfDay.midNight,
        TimeOfDay(hour: 1),
        TimeOfDay(hour: 1),
        TimeOfDay(hour: 5),
        TimeOfDay(hour: 5),
      ]);
    });
  });
}
