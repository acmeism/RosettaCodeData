proc changes(amount, coins): int =
  var ways = @[1]
  ways.setLen(amount+1)
  for coin in coins:
    for j in coin..amount:
      ways[j] += ways[j-coin]
  ways[amount]

echo changes(100, [1, 5, 10, 25])
echo changes(100000, [1, 5, 10, 25, 50, 100])
