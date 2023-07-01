List solveKnapsack(items, maxWeight) {
  int MIN_VALUE=-100;
  int N = items.length; // number of items
  int W = maxWeight; // maximum weight of knapsack

  List profit = new List(N+1);
  List weight = new List(N+1);

  // generate random instance, items 1..N
  for(int n = 1; n<=N; n++) {
    profit[n] = items[n-1][2];
    weight[n] = items[n-1][1];

  }

  // opt[n][w] = max profit of packing items 1..n with weight limit w
  // sol[n][w] = does opt solution to pack items 1..n with weight limit w include item n?
  List<List<int>> opt = new List<List<int>>(N+1);
  for (int i=0; i<N+1; i++) {
    opt[i] = new List<int>(W+1);
    for(int j=0; j<W+1; j++) {
      opt[i][j] = MIN_VALUE;
    }
  }

  List<List<bool>> sol = new List<List<bool>>(N+1);
  for (int i=0; i<N+1; i++) {
    sol[i] = new List<bool>(W+1);
    for(int j=0; j<W+1; j++) {
      sol[i][j] = false;
    }
  }

  for(int n=1; n<=N; n++) {
    for (int w=1; w <= W; w++) {
      // don't take item n
      int option1 = opt[n-1][w];

      // take item n
      int option2 = MIN_VALUE;
      if (weight[n] <= w) {
        option2 = profit[n] + opt[n-1][w - weight[n]];
      }

      // select better of two options
      opt[n][w] = Math.max(option1, option2);
      sol[n][w] = (option2 > option1);
    }
  }

  // determine which items to take
  List<List> packItems = new List<List>();
  List<bool> take = new List(N+1);
  for (int n = N, w = W; n > 0; n--) {
    if (sol[n][w]) {
      take[n] = true;
      w = w - weight[n];
      packItems.add(items[n-1]);
    } else {
      take[n] = false;
    }
  }

  return packItems;

}

main() {
  List knapsackItems = [];
  knapsackItems.add(["map", 9, 150]);
  knapsackItems.add(["compass", 13, 35]);
  knapsackItems.add(["water", 153, 200]);
  knapsackItems.add(["sandwich", 50, 160]);
  knapsackItems.add(["glucose", 15, 60]);
  knapsackItems.add(["tin", 68, 45]);
  knapsackItems.add(["banana", 27, 60]);
  knapsackItems.add(["apple", 39, 40]);
  knapsackItems.add(["cheese", 23, 30]);
  knapsackItems.add(["beer", 52, 10]);
  knapsackItems.add(["suntan cream", 11, 70]);
  knapsackItems.add(["camera", 32, 30]);
  knapsackItems.add(["t-shirt", 24, 15]);
  knapsackItems.add(["trousers", 48, 10]);
  knapsackItems.add(["umbrella", 73, 40]);
  knapsackItems.add(["waterproof trousers", 42, 70]);
  knapsackItems.add(["waterproof overclothes", 43, 75]);
  knapsackItems.add(["note-case", 22, 80]);
  knapsackItems.add(["sunglasses", 7, 20]);
  knapsackItems.add(["towel", 18, 12]);
  knapsackItems.add(["socks", 4, 50]);
  knapsackItems.add(["book", 30, 10]);
  int maxWeight = 400;
  Stopwatch sw = new Stopwatch.start();
  List p = solveKnapsack(knapsackItems, maxWeight);
  sw.stop();
  int totalWeight = 0;
  int totalValue = 0;
  print(["item","profit","weight"]);
  p.forEach((var i) { print("${i}"); totalWeight+=i[1]; totalValue+=i[2]; });
  print("Total Value = ${totalValue}");
  print("Total Weight = ${totalWeight}");
  print("Elapsed Time = ${sw.elapsedInMs()}ms");

}
