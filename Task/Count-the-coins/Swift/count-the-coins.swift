import BigInt

func countCoins(amountCents cents: Int, coins: [Int]) -> BigInt {
  let cycle = coins.filter({ $0 <= cents }).map({ $0 + 1 }).max()! * coins.count
  var table = [BigInt](repeating: 0, count: cycle)

  for x in 0..<coins.count {
    table[x] = 1
  }

  var pos = coins.count

  for s in 1..<cents+1 {
    for i in 0..<coins.count {
      if i == 0 && pos >= cycle {
        pos = 0
      }

      if coins[i] <= s {
        let q = pos - coins[i] * coins.count
        table[pos] = q >= 0 ? table[q] : table[q + cycle]
      }

      if i != 0 {
        table[pos] += table[pos - 1]
      }

      pos += 1
    }
  }

  return table[pos - 1]
}

let usCoins = [100, 50, 25, 10, 5, 1]
let euCoins = [200, 100, 50, 20, 10, 5, 2, 1]

for set in [usCoins, euCoins] {
  print(countCoins(amountCents: 100, coins: Array(set.dropFirst(2))))
  print(countCoins(amountCents: 100000, coins: set))
  print(countCoins(amountCents: 1000000, coins: set))
  print(countCoins(amountCents: 10000000, coins: set))
  print()
}
