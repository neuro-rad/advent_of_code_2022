import 'package:advent_of_code_2022/advent_of_code_2022.dart';
import 'package:test/test.dart';
import 'dart:io';

void main() {
  group('Day 8', () {
    final inputFile = File('input_files/day_8_simple.txt');
    final List<String> lines = inputFile.readAsLinesSync();

    test('- Returns known visible trees on example data', () {
      final visibleTrees = countVisibleTrees(lines);
      expect(visibleTrees, equals(21));
    });
  });
}
