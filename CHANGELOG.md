# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-11-26

### Added
- Initial release of the `time_of_day` package
- **TimeOfDay** class for representing and manipulating time within a day
  - Microsecond precision (0-24 hours)
  - Multiple constructors:
    - `TimeOfDay({hour, minute, second, millisecond, microsecond})` - Create from components
    - `TimeOfDay.now()` - Create from current time
    - `TimeOfDay.fromDateTime(DateTime)` - Create from DateTime
    - `TimeOfDay.dayPeriod({periodHour, minute, ..., DayPeriod})` - Create using AM/PM format
  - Static constants: `midNight`, `noon`, `endOfDay`
  - Properties: `hour`, `minute`, `second`, `millisecond`, `microsecond`, `period`, `hourOfPeriod`
- **Duration arithmetic** with overflow handling
  - `add(Duration, [TimeAddOption])` - Add duration with three modes:
    - `TimeAddOption.throwOnOverflow` - Throw error if exceeding 24:00:00 (safest)
    - `TimeAddOption.startNewDay` - Wrap around to next day like a clock (default)
    - `TimeAddOption.fromMidnight` - Apply duration from midnight, ignoring base time
- **Time comparisons**
  - `isAfter(TimeOfDay, {bool orSameMoment})` - Check if after another time
  - `isBefore(TimeOfDay, {bool orSameMoment})` - Check if before another time
  - `isBetween(TimeOfDay, TimeOfDay, {bool includeSameMoment})` - Check if between two times
  - `compareTo(TimeOfDay)` - Implements `Comparable<TimeOfDay>`
- **Time sequence generation**
  - `generateByDurations(TimeOfDay seed, int length, Duration duration, ...)` - Generate time sequences
  - Support for overflow handling and automatic trimming
- **DayPeriod enum** - AM/PM support
  - `DayPeriod.am` - Ante meridiem (before noon)
  - `DayPeriod.pm` - Post meridiem (after noon)
- **Duration extensions** (`duration_extensions.dart`)
  - `hours` - Hours within a day (0-23)
  - `minutes` - Minutes within an hour (0-59)
  - `seconds` - Seconds within a minute (0-59)
  - `milliseconds` - Milliseconds within a second (0-999)
  - `microseconds` - Microseconds within a millisecond (0-999)
- **Equatable support**
  - Built-in equality comparison
  - Hash code support for use in collections
- Comprehensive documentation
  - Complete API reference in README.md
  - Usage examples for all features
  - Real-world examples (scheduling, time validation, shift management)
  - Migration guide and best practices
- Test coverage
  - Comprehensive unit tests covering all functionality
  - 100% code coverage

### Features
- 🕐 Microsecond precision time representation
- 🔢 Multiple constructor options for flexibility
- ➕ Safe arithmetic with overflow protection
- ⚖️ Rich comparison operations
- 🌓 AM/PM (12-hour) format support
- 📊 Time sequence generation
- ✅ Equatable and Comparable implementations
- 🧩 Duration extensions for convenient time calculations
- 📖 Comprehensive documentation with examples
- 🧪 Fully tested with 100% coverage
- 🎯 Type-safe API
- 💪 Zero dependencies (except `equatable` and `clock`)


[1.0.0]: https://github.com/hossameldinmi/time_of_day/releases/tag/v1.0.0

