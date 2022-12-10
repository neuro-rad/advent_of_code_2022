part of 'advent_of_code_2022.dart';

// DAY 4, task 1
int task_7() {
  final inputFile = File('input_files/day_4_input.txt');
  List<String> lines = inputFile.readAsLinesSync();

  var total = 0;

  for (var line in lines) {
    final ranges = line.split(',');
    final elf1 = ranges[0].split('-');
    final elf2 = ranges[1].split('-');

    final elf1Set =
    {for(var i = int.parse(elf1[0]); i <= int.parse(elf1[1]); i++) i};
    final elf2Set =
    {for(var i = int.parse(elf2[0]); i <= int.parse(elf2[1]); i++) i};

    if (elf1Set.containsAll(elf2Set) || elf2Set.containsAll(elf1Set)) {
      total += 1;
    }
  }

  return(total);
}

// DAY 4, task 2
int task_8() {
  final inputFile = File('input_files/day_4_input.txt');
  final List<String> lines = inputFile.readAsLinesSync();

  var total = 0;

  for (var line in lines) {
    final ranges = line.split(',');
    final elf1 = ranges[0].split('-');
    final elf2 = ranges[1].split('-');

    final elf1Set =
    {for(var i = int.parse(elf1[0]); i <= int.parse(elf1[1]); i++) i};
    final elf2Set =
    {for(var i = int.parse(elf2[0]); i <= int.parse(elf2[1]); i++) i};

    if (elf1Set.intersection(elf2Set).isNotEmpty) {
      total += 1;
    }
  }

  return(total);
}

