BigInt changes(int amount, List<int> coins) {
  final ways = List<BigInt>.filled(amount + 1, BigInt.zero)..[0] = BigInt.one;
  for (final coin in coins) {
    for (int j = coin; j <= amount; j++) {
      ways[j] += ways[j - coin];
    }
  }
  return ways[amount];
}

void main() {
  print(changes(100, [25, 10, 5, 1]));
  print(changes(100000, [100, 50, 25, 10, 5, 1]));
}
