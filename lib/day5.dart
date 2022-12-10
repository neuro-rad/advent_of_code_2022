part of 'advent_of_code_2022.dart';

class Crane {
  List<List<String>> cols = [
    ['T', 'P', 'Z', 'C', 'S', 'L', 'Q', 'N'],
    ['L', 'P', 'T', 'V', 'H', 'C', 'G'],
    ['D', 'C', 'Z', 'F'],
    ['G', 'W', 'T', 'D', 'L', 'M', 'V', 'C'],
    ['P', 'W', 'C'],
    ['P', 'F', 'J', 'D', 'C', 'T', 'S', 'Z'],
    ['V', 'W', 'G', 'B', 'D'],
    ['N', 'J', 'S', 'Q', 'H', 'W'],
    ['R', 'C', 'Q', 'F', 'S', 'L', 'V'],
  ];

  @override
  String toString() {
    var string = '';
    for (final col in cols) {
      string += col.last;
    }
    return(string);
  }

  void moveSingle(int from, int to, {int number = 1}) {
    from -= 1; to -= 1; // Correct for array index
    for(var i = 1; i <= number; i++) {
      cols[to].add(cols[from].removeLast());
    }
  }

  void moveBlock(int from, int to, int number) {
    from -= 1; to -= 1; // Correct for array index
    cols[to] = [
      ...cols[to],
      ...cols[from].getRange(cols[from].length - number, cols[from].length),
    ];
    cols[from].removeRange(cols[from].length - number, cols[from].length);
  }

  int processMoveFromToLine(String line, {String mode = "single"}) {
    final instructions = _processFromToLine(line);
    if (instructions == null) return(1);
    final fromCol = instructions[0];
    final toCol = instructions[1];
    final numToMove = instructions[2];

    switch (mode) {
      case "single":
        moveSingle(fromCol, toCol, number: numToMove);
        break;
      case "block":
        moveBlock(fromCol, toCol, numToMove);
        break;
      default:
        throw Exception("Unknown mode!");
    }

    return(0);
  }

  List<int>? _processFromToLine(String line) {
    final pattern = RegExp(r'^move ([0-9]+) from ([0-9]+) to ([0-9]+)$');
    RegExpMatch? match = pattern.firstMatch(line);
    if (match == null) return(null);
    final numToMove = int.parse(match[1]!);
    final fromCol = int.parse(match[2]!);
    final toCol = int.parse(match[3]!);
    return [fromCol, toCol, numToMove];
  }
}

// DAY 5, task 1
String task_9() {
  var crane = Crane();
  final inputFile = File('input_files/day_5_input.txt');
  final List<String> lines = inputFile.readAsLinesSync();

  for (var line in lines) {
    crane.processMoveFromToLine(line);
  }

  return('$crane');
}

String task_10() {
  var crane = Crane();
  final inputFile = File('input_files/day_5_input.txt');
  final List<String> lines = inputFile.readAsLinesSync();

  for (var line in lines) {
    crane.processMoveFromToLine(line, mode: "block");
  }

  return('$crane');
}

