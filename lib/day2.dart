part of 'advent_of_code_2022.dart';

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
    if (this == opponent) return GameOutcome.draw;
    switch (this) {
      case HandChoice.rock:
        if (opponent == HandChoice.scissors) return GameOutcome.win;
        break;
      case HandChoice.paper:
        if (opponent == HandChoice.rock) return GameOutcome.win;
        break;
      case HandChoice.scissors:
        if (opponent == HandChoice.paper) return GameOutcome.win;
        break;
    }
    return GameOutcome.loss;
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
        player = opponent;
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

