part of 'advent_of_code_2022.dart';

// DAY 1, Task 1
// Top elf calories, listed by food item in day_1_input.txt with elfs
// seperarted by lines
int task_1() {
  final inputFile = File('input_files/day_1_input.txt');
  final List<String> lines = inputFile.readAsLinesSync();
  int elfTotal = 0;
  int currentLargest = 0;

  for (var line in lines) {
    if (line == '') {
      if (elfTotal > currentLargest) {
        currentLargest = elfTotal;
      }
      elfTotal = 0;
    } else {
      elfTotal += int.parse(line);
    }
  }
  return(currentLargest);
}

// DAY 1, Task 2
// Find top 3 elfs by calory
class TopElf {
  int elf1 = 0;
  int elf2 = 0;
  int elf3 = 0;

  @override
  String toString() {
    return('Top 3 elf calories: $elf1, $elf2, $elf3');
  }

  int total() {
    return(elf1 + elf2 + elf3);
  }

  void update(int calories) {
    if (calories >= elf1) {
      elf3 = elf2;
      elf2 = elf1;
      elf1 = calories;
    } else if (calories >= elf2){
      elf3 = elf2;
      elf2 = calories;
    } else if (calories > elf3) {
      elf3 = calories;
    }
  }
}

int task_2() {
  final inputFile = File('input_files/day_1_input.txt');
  final List<String> lines = inputFile.readAsLinesSync();
  var topElf = TopElf();
  int elfTotal = 0;

  for (var line in lines) {
    if (line == '') {
      topElf.update(elfTotal);
      elfTotal = 0;
    } else {
      elfTotal += int.parse(line);
    }
  }

  return(topElf.total());
}
