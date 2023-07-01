var res = [(Int, Int, Int)]()

for x in [2, 4, 6] {
  for y in 1...7 where x != y {
    let z = 12 - (x + y)

    guard y != z && 1 <= z && z <= 7 else {
      continue
    }

    res.append((x, y, z))
  }
}

for result in res {
  print(result)
}
