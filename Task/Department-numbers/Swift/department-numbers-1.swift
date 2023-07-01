let res = [2, 4, 6].map({x in
  return (1...7)
      .filter({ $0 != x })
      .map({y -> (Int, Int, Int)? in
        let z = 12 - (x + y)

        guard y != z && 1 <= z && z <= 7 else {
          return nil
        }

        return (x, y, z)
      }).compactMap({ $0 })
}).flatMap({ $0 })

for result in res {
  print(result)
}
