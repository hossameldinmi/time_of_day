/// A type-safe package for representing and manipulating time of day values.
///
/// This library provides the [TimeOfDay] class for working with times within
/// a single day (00:00:00 to 24:00:00) with microsecond precision, independent
/// of any specific date.
///
/// Features:
/// - Microsecond precision time representation
/// - Multiple constructor options (hour/minute, DateTime, AM/PM format)
/// - Safe arithmetic operations with overflow handling
/// - Rich comparison operations
/// - Time sequence generation
/// - Duration extensions for normalized time components
///
/// Example:
/// ```dart
/// import 'package:time_of_day/time_of_day.dart';
///
/// final morning = TimeOfDay(hour: 9, minute: 30);
/// final afternoon = morning.add(Duration(hours: 5));
/// print(afternoon.hour); // 14
/// ```
library time_of_day;

export 'src/time_of_day.dart';
export 'src/duration_extensions.dart';
