part of 'advent_of_code_2022.dart';

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

