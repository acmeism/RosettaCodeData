extension BinaryInteger {
  @inlinable
  public func power(_ n: Self) -> Self {
    return stride(from: 0, to: n, by: 1).lazy.map({_ in self }).reduce(1, *)
  }
}

func sumOfPowers(maxN: Int = 250) -> (Int, Int, Int, Int, Int) {
  let pow5 = (0..<maxN).map({ $0.power(5) })
  let pow5ToN = {n in pow5.firstIndex(of: n)}

  for x0 in 1..<maxN {
    for x1 in 1..<x0 {
      for x2 in 1..<x1 {
        for x3 in 1..<x2 {
          let powSum = pow5[x0] + pow5[x1] + pow5[x2] + pow5[x3]

          if let idx = pow5ToN(powSum) {
            return (x0, x1, x2, x3, idx)
          }
        }
      }
    }
  }

  fatalError("Did not find solution")
}

let (x0, x1, x2, x3, y) = sumOfPowers()

print("\(x0)^5 + \(x1)^5 + \(x2)^5 \(x3)^5 = \(y)^5")
