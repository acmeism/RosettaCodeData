struct SimpleMovingAverage {
  var period: Int
  var numbers = [Double]()

  mutating func addNumber(_ n: Double) -> Double {
    numbers.append(n)

    if numbers.count > period {
      numbers.removeFirst()
    }

    guard !numbers.isEmpty else {
      return 0
    }

    return numbers.reduce(0, +) / Double(numbers.count)
  }
}

for period in [3, 5] {
  print("Moving average with period \(period)")

  var averager = SimpleMovingAverage(period: period)

  for n in [1.0, 2, 3, 4, 5, 5, 4, 3, 2, 1] {
    print("n: \(n); average \(averager.addNumber(n))")
  }
}
