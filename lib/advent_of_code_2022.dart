import 'dart:io';

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

// DAY 2, TASK 1
enum GameOutcome{
  loss(0),
  draw(3),
  win(6);

  const GameOutcome(this.score);
  final int score;
}

enum HandChoice {
  rock(1),
  paper(2),
  scissors(3);

  const HandChoice(this.score);
  final int score;

  factory HandChoice.decode(String code) {
    HandChoice handChoice;

    switch (code) {
      case 'A':
        handChoice = HandChoice.rock;
        break;
      case 'B':
        handChoice = HandChoice.paper;
        break;
      case 'C':
        handChoice = HandChoice.scissors;
        break;
      case 'X':
        handChoice = HandChoice.rock;
        break;
      case 'Y':
        handChoice = HandChoice.paper;
        break;
      case 'Z':
        handChoice = HandChoice.scissors;
        break;
      default:
        throw Exception('Unknown code');
    }

    return(handChoice);
  }

  GameOutcome compare(HandChoice opponent) {
    switch (this) {

      // Caller is a rock
      case HandChoice.rock:
        switch (opponent) {
          case HandChoice.rock:
            return GameOutcome.draw;
          case HandChoice.paper:
            return GameOutcome.loss;
          case HandChoice.scissors:
            return GameOutcome.win;
      }

      // Caller is paper
      case HandChoice.paper:
        switch (opponent) {
          case HandChoice.rock:
            return GameOutcome.win;
          case HandChoice.paper:
            return GameOutcome.draw;
          case HandChoice.scissors:
            return GameOutcome.loss;
        }

        // Caller is scissors
        case HandChoice.scissors:
          switch (opponent) {
            case HandChoice.rock:
              return GameOutcome.loss;
            case HandChoice.paper:
              return GameOutcome.win;
            case HandChoice.scissors:
              return GameOutcome.draw;
          }
    }
  }
}

int task_3() {
  final inputFile = File('input_files/day_2_input.txt');
  final List<String> lines = inputFile.readAsLinesSync();

  var totalScore = 0;

  for (final line in lines) {
    final codes = line.split(' ');
    final HandChoice opponent = HandChoice.decode(codes[0]);
    final HandChoice player = HandChoice.decode(codes[1]);

    final gameOutcome = player.compare(opponent);
    totalScore += gameOutcome.score + player.score;
  }

  return(totalScore);
}

int task_4() {
  final inputFile = File('input_files/day_2_input.txt');
  final List<String> lines = inputFile.readAsLinesSync();

  var totalScore = 0;

  for (var line in lines) {
    final codes = line.split(' ');
    final HandChoice opponent = HandChoice.decode(codes[0]);
    HandChoice player;

    switch (codes[1]) {
      case 'X': // Need to loose
        switch (opponent) {
          case HandChoice.rock:
            player = HandChoice.scissors;
            break;
          case HandChoice.paper:
            player = HandChoice.rock;
            break;
          case HandChoice.scissors:
            player = HandChoice.paper;
            break;
        }
        break;

      case 'Y': // Need to draw
        switch (opponent) {
          case HandChoice.rock:
            player = HandChoice.rock;
            break;
          case HandChoice.paper:
            player = HandChoice.paper;
            break;
          case HandChoice.scissors:
            player = HandChoice.scissors;
            break;
        }
        break;

      case 'Z': // Need to win
        switch (opponent) {
          case HandChoice.rock:
            player = HandChoice.paper;
            break;
          case HandChoice.paper:
            player = HandChoice.scissors;
            break;
          case HandChoice.scissors:
            player = HandChoice.rock;
            break;
        }
        break;

      default:
        throw Exception("Unknown outcome code!");
    }

    final gameOutcome = player.compare(opponent);
    totalScore += gameOutcome.score + player.score;
  }

  return(totalScore);
}

// DAY 3, task 1
class ItemPriority {
  ItemPriority._internal() {
    for(var i = 0x61; i <= 0x7A; i++) {  // a-z
      items[String.fromCharCode(i)] = i - 0x60;
    }

    for(var i = 0x41; i <= 0x5A; i++) {  // A-Z
      items[String.fromCharCode(i)] = i - 0x41 + 27;
    }
  }

  Map<String, int> items = {};
  static final ItemPriority _instance = ItemPriority._internal();
  factory ItemPriority() => _instance;

  int get(String char) {
    if (char.length != 1) throw Exception('Only length 1 chars allowed!');
    final priority = items[char];
    if (priority == null) throw Exception('Unknown item - no priority assigned');
    return(priority);
  }
}

class ElfBackpack {
  final String items;
  Set<int> compartment1 = {};
  Set<int> compartment2 = {};

  ElfBackpack(this.items) {
    final splitPoint = (items.length ~/ 2);
    final compartmentSubstring1 = items.substring(0, splitPoint);
    final compartmentSubstring2 = items.substring(splitPoint);

    for (var element in compartmentSubstring1.codeUnits) {
      compartment1.add(element);
    }

    for (var element in compartmentSubstring2.codeUnits) {
      compartment2.add(element);
    }
  }

  Set<int> get codePointSet => compartment1.union(compartment2);

  Set<String> returnCompDuplicates() {
    final duplicateCodes = compartment1.intersection(compartment2);
    final duplicateChars = _setCodeToString(duplicateCodes);
    return(duplicateChars);
  }

  Set<String> returnPackDuplicates(ElfBackpack comparison) {
    final duplicateCodes = codePointSet.intersection(comparison.codePointSet);
    final duplicateChars = _setCodeToString(duplicateCodes);
    return(duplicateChars);
  }

  Set<String> _setCodeToString(Set<int> codeSet) {
    Set<String> charsSet = {};
    for (var item in codeSet) {
      charsSet.add(String.fromCharCode(item));
    }
    return(charsSet);
  }
}

int task_5() {
  final inputFile = File('input_files/day_3_input.txt');
  final List<String> lines = inputFile.readAsLinesSync();
  final itemPriority = ItemPriority();
  var totalPriorities = 0;

  for (var line in lines) {
    final backpack = ElfBackpack(line);
    final duplicates = backpack.returnCompDuplicates();
    if (duplicates.length != 1) throw Exception("Incorrect duplicate number!");
    final priority = itemPriority.get(duplicates.elementAt(0));
    totalPriorities += priority;
  }

  return(totalPriorities);
}

// DAY 3, task 2
int task_6() {
  final inputFile = File('input_files/day_3_input.txt');
  List<String> lines = inputFile.readAsLinesSync();
  final itemPriority = ItemPriority();
  var totalPriority = 0;

  for (var i = 0; i < lines.length - 2; i += 3) {
    final elf1 = ElfBackpack(lines[i]);
    final elf2 = ElfBackpack(lines[i+1]);
    final elf3 = ElfBackpack(lines[i+2]);

    final packDuplicates1 = elf1.returnPackDuplicates(elf2);
    final packDuplicates2 = elf2.returnPackDuplicates(elf3);
    final commonToAllThree = packDuplicates1.intersection(packDuplicates2);

    if (commonToAllThree.length != 1) throw Exception("Incorrect duplicate num!");
    final priority = itemPriority.get(commonToAllThree.elementAt(0));
    totalPriority += priority;
  }
  return(totalPriority);
}

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
