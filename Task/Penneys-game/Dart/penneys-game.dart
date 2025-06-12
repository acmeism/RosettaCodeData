import 'dart:math';
import 'dart:io';

class Penney {
  int pW = 0;
  int cW = 0;
  String playerChoice = '';
  String computerChoice = '';
  String sequence = '';
  final Random _random = Random();

  void gameLoop() {
    String a;
    while (true) {
      playerChoice = '';
      computerChoice = '';
      if (_random.nextInt(2) == 1) {
        computer();
        player();
      } else {
        player();
        computer();
      }

      play();

      stdout.write("[Y] to play again ");
      a = stdin.readLineSync() ?? ''; // Read input from the console

      if (a.isNotEmpty && a[0].toUpperCase() != 'Y') {
        print("Computer won $cW times.");
        print("Player won $pW times.");
        break;
      }
      print('\n\n');
    }
  }

  void computer() {
    if (playerChoice.isEmpty) {
      for (int x = 0; x < 3; x++) {
        computerChoice += (_random.nextInt(2) == 0) ? "H" : "T";
      }
    } else {
      computerChoice += (playerChoice[1] == 'T') ? "H" : "T";
      computerChoice += playerChoice.substring(0, 2);
    }
    print("Computer's sequence of three is: $computerChoice");
  }

  void player() {
    stdout.write("Enter your sequence of three (H/T) ");
    playerChoice = stdin.readLineSync() ?? ''; // Read input from the console
  }

  void play() {
    sequence = '';
    while (true) {
      sequence += (_random.nextInt(2) == 0) ? "H" : "T";
      if (sequence.contains(playerChoice)) {
        showWinner(1);
        break;
      } else if (sequence.contains(computerChoice)) {
        showWinner(0);
        break;
      }
    }
  }

  void showWinner(int i) {
    String s;
    if (i == 1) {
      s = "Player wins!";
      pW++;
    } else {
      s = "Computer wins!";
      cW++;
    }
    print("Tossed sequence: $sequence");
    print(s);
    print('\n');
  }
}

void main() {
  // Dart does not need srand, Random() creates a new seeded random number generator.
  final game = Penney();
  game.gameLoop();
}
