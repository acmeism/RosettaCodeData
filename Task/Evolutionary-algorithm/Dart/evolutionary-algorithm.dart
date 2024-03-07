import 'dart:math';

class EvoAlgo {
  static final String target = "METHINKS IT IS LIKE A WEASEL";
  static final List<String> possibilities = "ABCDEFGHIJKLMNOPQRSTUVWXYZ ".split('');
  static int c = 100; // Number of spawn per generation
  static double minMutateRate = 0.09;
  static int perfectFitness = target.length;
  static String parent = '';
  static Random rand = Random();

  static int fitness(String trial) {
    int retVal = 0;
    for (int i = 0; i < trial.length; i++) {
      if (trial[i] == target[i]) retVal++;
    }
    return retVal;
  }

  static double newMutateRate() {
    return (((perfectFitness - fitness(parent)) / perfectFitness) * (1 - minMutateRate));
  }

  static String mutate(String parent, double rate) {
    String retVal = '';
    for (int i = 0; i < parent.length; i++) {
      retVal += (rand.nextDouble() <= rate)
          ? possibilities[rand.nextInt(possibilities.length)]
          : parent[i];
    }
    return retVal;
  }

  static void main() {
    parent = mutate(target, 1);
    int iter = 0;
    while (parent != target) {
      double rate = newMutateRate();
      iter++;
      if (iter % 100 == 0) {
        print('$iter: $parent, fitness: ${fitness(parent)}, rate: $rate');
      }
      String bestSpawn;
      int bestFit = 0;
      for (int i = 0; i < c; i++) {
        String spawn = mutate(parent, rate);
        int fit = fitness(spawn);
        if (fit > bestFit) {
          bestSpawn = spawn;
          bestFit = fit;
        }
      }
      if (bestFit > fitness(parent)) {
        parent = bestSpawn;
      }
    }
    print('$parent, $iter');
  }
}

void main() {
  EvoAlgo.main();
}
