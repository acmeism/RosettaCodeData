func countJewels(_ stones: String, _ jewels: String) -> Int {
  return stones.map({ jewels.contains($0) ? 1 : 0 }).reduce(0, +)
}

print(countJewels("aAAbbbb", "aA"))
print(countJewels("ZZ", "z"))
