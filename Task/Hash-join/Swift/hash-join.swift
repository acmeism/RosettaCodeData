func hashJoin<A, B, K: Hashable>(_ first: [(K, A)], _ second: [(K, B)]) -> [(A, K, B)] {
  var map = [K: [B]]()

  for (key, val) in second {
    map[key, default: []].append(val)
  }

  var res = [(A, K, B)]()

  for (key, val) in first {
    guard let vals = map[key] else {
      continue
    }

    res += vals.map({ (val, key, $0) })
  }

  return res
}

let t1 = [
  ("Jonah", 27),
  ("Alan", 18),
  ("Glory", 28),
  ("Popeye", 18),
  ("Alan", 28)
]

let t2 = [
  ("Jonah", "Whales"),
  ("Jonah", "Spiders"),
  ("Alan", "Ghosts"),
  ("Alan", "Zombies"),
  ("Glory", "Buffy")
]

print("Age | Character Name | Nemesis")
print("----|----------------|--------")

for (age, name, nemesis) in hashJoin(t1, t2) {
  print("\(age) | \(name) | \(nemesis)")
}
