part of 'advent_of_code_2022.dart';

List<List<int>> treeRowStringToArray(List<String> treeRowsString) {
  List<List<int>> treeRowArray = [];
  for (final line in treeRowsString) {
    List<int> row = [];
    for (var char in line.runes) {
      final treeHeight = char - 0x30;
      row.add(treeHeight);
    }
    treeRowArray.add(row);
  }
  return treeRowArray;
}

bool checkTreeRow(treeRowArray, i, j, size) {
  bool visibleLeft = true;
  for (var x = 0; x < j; x++) {
    if (treeRowArray[i][x] >= size) visibleLeft = false;
  }
  bool visibleRight = true;
  for (var x = j + 1; x < treeRowArray.length; x++) {
    if (treeRowArray[i][x] >= size) visibleRight = false;
  }
  return(visibleLeft || visibleRight);
}

bool checkTreeColum(treeRowArray, i, j, size) {
  bool visibleTop = true;
  for (var x = 0; x < i; x++) {
    if (treeRowArray[x][j] >= size) visibleTop = false;
  }
  bool visibleBottom = true;
  for (var x = i + 1; x < treeRowArray.length; x++) {
    if (treeRowArray[x][j] >= size) visibleBottom = false;
  }
  return(visibleTop || visibleBottom);
}

int countVisibleTrees(final List<String> treeRowsString) {
  final List<List<int>> treeRowArray = treeRowStringToArray(treeRowsString);

  var visibleTrees = 0;
  for (var i = 0; i < treeRowArray.length; i++) {   // rows
    for (var j = 0; j < treeRowArray.length; j++) { // columns
      final size = treeRowArray[i][j];
      if (checkTreeRow(treeRowArray, i, j, size)) {
        visibleTrees += 1;
        continue;
      }
      if (checkTreeColum(treeRowArray, i, j, size)) {
        visibleTrees += 1;
      }
    }
  }

  return visibleTrees;
}

int task_15() {
  final inputFile = File('input_files/day_8_input.txt');
  final List<String> lines = inputFile.readAsLinesSync();
  final visibleTrees = countVisibleTrees(lines);
  return(visibleTrees);
}