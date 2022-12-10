part of 'advent_of_code_2022.dart';

// DAY 7

class MockFile {
  String name;
  int size;

  MockFile(this.name, this.size);

  @override
  String toString() {
    return('$size $name');
  }
}

class MockDirectory {
  String name;
  late List<String> path;
  int size = 0;
  Map<String, MockFile> files = {};
  Map<String, MockDirectory> directories = {};

  MockDirectory(this.name, List<String> parentPath) {
    path = [...parentPath, name];
  }

  void updateSize() {
    size = 0;
    for (var dir in directories.values) {
      dir.updateSize();
      size += dir.size;
    }
    for (var file in files.values) {
      size += file.size;
    }
  }

  void addFile(String name, int size) {
    if (files[name] != null) throw Exception("File already exists!");
    MockFile newFile = MockFile(name, size);
    files[name] = newFile;
  }

  void addDirectory(String name) {
    if (directories[name] != null) throw Exception("Dir already exists!");
    MockDirectory newDir = MockDirectory(name, path);
    directories[name] = newDir;
  }

  @override
  String toString() {
    return('dir $name');
  }

  void ls(bool recursive, {int recursionDepth = 1}) {
    switch (recursive) {
      case false:
        print('ls for: $path');
        for (var file in files.values) {
          print(file);
        }
        for (var dir in directories.values) {
          print(dir);
        }
        break;
      case true:
        String leader = "-" * recursionDepth;
        print('$leader $this');
        for (var file in files.values) {
          print('$leader - $file');
        }
        for (var dir in directories.values) {
          dir.ls(true, recursionDepth: recursionDepth + 2);
        }
    }

  }

  Map<List<String>, int> returnDirsOverSize(int minSize) {
    Map<List<String>, int> dirsToReturn = {};
    for (var dir in directories.values) {
      if (dir.size >= minSize) {
        dirsToReturn[dir.path] = dir.size;
        var subDirectories = dir.returnDirsOverSize(minSize);
        dirsToReturn.addAll(subDirectories);
      }
    }
    return(dirsToReturn);
  }

  Map<List<String>, int> returnDirsUnderSize(final int maxSize) {
    Map<List<String>, int> dirsToReturn = {};
    for (var dir in directories.values) {
      if (dir.size <= maxSize) {
        dirsToReturn[dir.path] = dir.size;
      }
      var subDirectories = dir.returnDirsUnderSize(maxSize);
      dirsToReturn.addAll(subDirectories);
    }
    return(dirsToReturn);
  }
}

class FileSystem {
  MockDirectory root = MockDirectory("/", []);
  List<String> currentPath = ["/"];
  late MockDirectory current;

  mockDirectory() {
    current = root;
  }

  parseLine(String line) {
    List<String> instructions = line.split(" ");
    if (instructions[0] == "\$") {
      _parseCmd(instructions);
    } else {
      _addFileOrDirectory(instructions);
    }
    // Debug parsing prints:
    // print('Command: $line');
    // current.ls();
    // print('');
  }

  void _parseCmd(List<String> instructions) {
    switch (instructions[1]) {
      case "ls":
        break;
      case "cd":
        switch (instructions[2]) {
          case "/":
            current = root;
            break;
          case "..":
            _stepBackOneDir(currentPath);
            break;
          default:
            _stepForwardOneDirectory(instructions[2]);
            break;
        }
    }
  }

  void _stepForwardOneDirectory(String name) {
    MockDirectory? newDir = current.directories[name];
    if (newDir == null) {
      print('Current path: $currentPath');
      throw Exception("$name not found!");
    } else {
      current = newDir;
      currentPath.add(newDir.name);
    }
  }

  void _stepBackOneDir(List<String> currentPath) {
    currentPath.removeLast();
    current = root;
    this.currentPath = ["/"];
    for (var dir in currentPath) {
      if (dir == "/") continue;
      _stepForwardOneDirectory(dir);
    }
  }

  void _addFileOrDirectory(List<String> instructions) {
    if (instructions[0] == "dir") {
      current.addDirectory(instructions[1]);
    } else {
      current.addFile(instructions[1], int.parse(instructions[0]));
    }
  }

  int updateSize() {
    root.updateSize();
    return(root.size);
  }

  Map<List<String>, int> returnDirsOverSize(int minSize) {
    Map<List<String>, int> dirsToReturn = {};

    if (root.size >= minSize) {
      dirsToReturn[root.path] = root.size;
    } else {
      return {};
    }

    final subDirectories = root.returnDirsOverSize(minSize);
    dirsToReturn.addAll(subDirectories);
    return(dirsToReturn);
  }

  Map<List<String>, int> returnDirsUnderSize(final int maxSize) {
    Map<List<String>, int> dirsToReturn = {};

    if (root.size <= maxSize) {
      dirsToReturn[root.path] = root.size;
    }

    final subDirectories = root.returnDirsUnderSize(maxSize);
    dirsToReturn.addAll(subDirectories);
    return(dirsToReturn);
  }
}

int task_13() {
  final inputFile = File('input_files/day_7_input.txt');
  final List<String> lines = inputFile.readAsLinesSync();
  FileSystem fileSystem = FileSystem();

  for (var line in lines) {
    fileSystem.parseLine(line);
  }
  fileSystem.updateSize();

  int totalToReturn = 0;
  final dirsUnderSize = fileSystem.returnDirsUnderSize(100000);
  for (final dirSize in dirsUnderSize.values) {
    totalToReturn += dirSize;
  }
  return totalToReturn;
}

int task_14() {
  final inputFile = File('input_files/day_7_input.txt');
  final List<String> lines = inputFile.readAsLinesSync();

  const int totalDiscSize = 70000000;
  const int requiredDiscSize = 30000000;

  FileSystem fileSystem = FileSystem();
  for (var line in lines) {
    fileSystem.parseLine(line);
  }
  fileSystem.updateSize();

  final minSizeToDelete =
      requiredDiscSize - (totalDiscSize - fileSystem.root.size);
  final possibleDirsToDelete = fileSystem.returnDirsOverSize(minSizeToDelete);
  final minValue = possibleDirsToDelete.values
      .reduce((value, element) => (element < value) ? element : value);

  return(minValue);
}
