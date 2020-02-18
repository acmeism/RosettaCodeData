typealias F1 = (Int) -> [(Int, Int, Int)]
typealias F2 = (Int) -> Bool

func pythagoreanTriples(n: Int) -> [(Int, Int, Int)] {
  (1...n).flatMap({x in
    (x...n).flatMap({y in
      (y...n).filter({z in
        x * x + y * y == z * z
      } as F2).map({ (x, y, $0) })
    } as F1)
  } as F1)
}

print(pythagoreanTriples(n: 20))
