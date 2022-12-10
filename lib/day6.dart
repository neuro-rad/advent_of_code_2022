part of 'advent_of_code_2022.dart';

// DAY 6
int findMarker(String signal, int groupLength) {
  for (var i = groupLength - 1; i < signal.length; i++) {
    Set<String> group = {};
    for (var j = i - groupLength + 1; j <= i; j++) {
      group.add(signal[j]);
    }
    if (group.length == groupLength) {
      return i + 1;
    }
  }
  return 0;
}

int task_11() {
  final inputFile = File('input_files/day_6_input.txt');
  final String signal = inputFile.readAsStringSync();
  return findMarker(signal, 4);
}

int task_12() {
  final inputFile = File('input_files/day_6_input.txt');
  final String signal = inputFile.readAsStringSync();
  return findMarker(signal, 14);
}

