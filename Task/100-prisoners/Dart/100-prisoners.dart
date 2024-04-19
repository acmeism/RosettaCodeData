import 'dart:math';

int playRandom(int n) {
  var rnd = Random();
  int pardoned = 0;
  List<int> inDrawer = List<int>.generate(100, (i) => i);
  List<int> sampler = List<int>.generate(100, (i) => i);
  for (int round = 0; round < n; round++) {
    inDrawer.shuffle();
    bool found = false;
    for (int prisoner = 0; prisoner < 100; prisoner++) {
      found = false;
      sampler.shuffle(rnd);
      for (int i = 0; i < 50; i++) {
        int reveal = sampler[i];
        int card = inDrawer[reveal];
        if (card == prisoner) {
          found = true;
          break;
        }
      }
      if (!found) {
        break;
      }
    }
    if (found) {
      pardoned++;
    }
  }
  return (pardoned / n * 100).round();
}

int playOptimal(int n) {
  var rnd = Random();
  int pardoned = 0;
  bool found = false;
  List<int> inDrawer = List<int>.generate(100, (i) => i);
  for (int round = 0; round < n; round++) {
    inDrawer.shuffle(rnd);
    for (int prisoner = 0; prisoner < 100; prisoner++) {
      int reveal = prisoner;
      found = false;
      for (int go = 0; go < 50; go++) {
        int card = inDrawer[reveal];
        if (card == prisoner) {
          found = true;
          break;
        }
        reveal = card;
      }
      if (!found) {
        break;
      }
    }
    if (found) {
      pardoned++;
    }
  }
  return (pardoned / n * 100).round();
}

void main() {
  int n = 100000;
  print(" Simulation count: $n");
  print(" Random play wins: ${playRandom(n).toStringAsFixed(2)}% of simulations");
  print("Optimal play wins: ${playOptimal(n).toStringAsFixed(2)}% of simulations");
}
