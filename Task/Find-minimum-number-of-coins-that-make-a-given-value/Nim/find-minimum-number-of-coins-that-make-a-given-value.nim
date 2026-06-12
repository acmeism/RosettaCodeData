import strformat

const
  Coins = [200, 100, 50, 20, 10, 5, 2, 1]
  Target = 988

echo &"Minimal number of coins to make a value of {Target}:"
var count = 0
var remaining = Target
for coin in Coins:
  let n = remaining div coin
  if n != 0:
    inc count, n
    echo &"coins of {coin:3}: {n}"
    dec remaining, n * coin
    if remaining == 0: break

echo "\nTotal: ", count
