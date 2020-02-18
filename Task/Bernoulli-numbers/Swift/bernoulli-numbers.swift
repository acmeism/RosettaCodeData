import BigInt

public func bernoulli<T: BinaryInteger & SignedNumeric>(n: Int) -> Frac<T> {
  guard n != 0 else {
    return 1
  }

  var arr = [Frac<T>]()

  for m in 0...n {
    arr.append(Frac(numerator: 1, denominator: T(m) + 1))

    for j in stride(from: m, through: 1, by: -1) {
      arr[j-1] = (arr[j-1] - arr[j]) * Frac(numerator: T(j), denominator: 1)
    }
  }

  return arr[0]
}

for n in 0...60 {
  let b = bernoulli(n: n) as Frac<BigInt>

  guard b != 0 else {
    continue
  }

  print("B(\(n)) = \(b)")
}
