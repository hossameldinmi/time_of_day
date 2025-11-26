# Examples

This directory contains practical examples demonstrating the `time_of_day` package features.

## Available Examples

### 1. `basic_usage.dart`
Introduction to core features:
- Creating `TimeOfDay` instances
- Using predefined constants
- Accessing time components
- Basic arithmetic and comparisons

Run: `dart run example/basic_usage.dart`

### 2. `overflow_handling.dart`
Demonstrates the three overflow modes:
- `startNewDay` - Wraps around like a clock (default)
- `throwOnOverflow` - Throws exception for safety
- `fromMidnight` - Applies duration from midnight

Run: `dart run example/overflow_handling.dart`

### 3. `time_sequences.dart`
Generating time sequences:
- Hourly schedules
- Custom interval sequences
- Wrap-around behavior
- Auto-trimming at day boundaries

Run: `dart run example/time_sequences.dart`

### 4. `practical_examples.dart`
Real-world use cases:
- Business hours validation
- Appointment scheduling
- Time until next event
- Lunch break validation
- Shift rotation

Run: `dart run example/practical_examples.dart`

### 5. `duration_extensions.dart`
Working with duration extensions:
- Normalizing overflow durations
- Extracting time components
- Microsecond precision
- Multiple day durations

Run: `dart run example/duration_extensions.dart`

## Running All Examples

To run all examples at once:

```bash
for file in example/*.dart; do
  echo "Running $file..."
  dart run "$file"
  echo ""
done
```

## More Information

- [Package Documentation](../README.md)
- [API Reference](https://pub.dev/documentation/time_of_day/latest/)
- [GitHub Repository](https://github.com/hossameldinmi/time_of_day)
