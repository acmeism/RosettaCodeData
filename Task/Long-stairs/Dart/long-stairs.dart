import 'dart:math';

void main() {
  int secsTot = 0,
      stepsTot = 0; // keep track of time and steps over all the trials
  Random rand = new Random();

  print("Seconds    steps behind    steps ahead");

  for (int trial = 1; trial <= 10000; trial++) {
    // 10000 attempts for the runner
    int sbeh = 0, slen = 100, secs = 0; // initialise this trial

    while (sbeh < slen) {
      // as long as the runner is still on the stairs
      sbeh += 1; // runner climbs a step

      for (int wiz = 1; wiz <= 5; wiz++) {
        // evil wizard conjures five new steps
        if (rand.nextInt(slen) < sbeh)
          sbeh += 1; // maybe a new step is behind us
        slen += 1; // either way, the staircase is longer
      }

      secs += 1; // one second has passed

      if (trial == 1 && 599 < secs && secs < 610)
        print("$secs        $sbeh            ${slen - sbeh}");
    }

    secsTot += secs;
    stepsTot += slen;
  }

  print("Average secs taken: ${secsTot / 10000.0}");
  print("Average final length of staircase: ${stepsTot / 10000.0}");
}
