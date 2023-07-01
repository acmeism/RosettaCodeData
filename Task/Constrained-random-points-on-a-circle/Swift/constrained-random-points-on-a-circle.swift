let nPoints = 100

func generatePoint() -> (Int, Int) {
  while true {
    let x = Int.random(in: -15...16)
    let y = Int.random(in: -15...16)
    let r2 = x * x + y * y

    if r2 >= 100 && r2 <= 225 {
      return (x, y)
    }
  }
}

func filteringMethod() {
  var rows = [[String]](repeating: Array(repeating: " ", count: 62), count: 31)

  for _ in 0..<nPoints {
    let (x, y) = generatePoint()

    rows[y + 15][x + 15 * 2] = "*"
  }

  for row in rows {
    print(row.joined())
  }
}

func precalculatingMethod() {
  var possiblePoints = [(Int, Int)]()

  for y in -15...15 {
    for x in -15...15 {
      let r2 = x * x + y * y

      if r2 >= 100 && r2 <= 225 {
        possiblePoints.append((x, y))
      }
    }
  }

  possiblePoints.shuffle()

  var rows = [[String]](repeating: Array(repeating: " ", count: 62), count: 31)

  for (x, y) in possiblePoints {
    rows[y + 15][x + 15 * 2] = "*"
  }

  for row in rows {
    print(row.joined())
  }
}

print("Filtering method:")
filteringMethod()

print("Precalculating method:")
precalculatingMethod()
