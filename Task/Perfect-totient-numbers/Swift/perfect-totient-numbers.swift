public func totient(n: Int) -> Int {
  var n = n
  var i = 2
  var tot = n

  while i * i <= n {
    if n % i == 0 {
      while n % i == 0 {
        n /= i
      }

      tot -= tot / i
    }

    if i == 2 {
      i = 1
    }

    i += 2
  }

  if n > 1 {
    tot -= tot / n
  }

  return tot
}

public struct PerfectTotients: Sequence, IteratorProtocol {
  private var m = 1

  public init() { }

  public mutating func next() -> Int? {
    while true {
      defer {
        m += 1
      }

      var tot = m
      var sum = 0

      while tot != 1 {
        tot = totient(n: tot)
        sum += tot
      }

      if sum == m {
        return m
      }
    }
  }
}

print("The first 20 perfect totient numbers are:")
print(Array(PerfectTotients().prefix(20)))
