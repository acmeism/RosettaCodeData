extension BinaryInteger {
  @inlinable
  public func factors(sorted: Bool = true) -> [Self] {
    let maxN = Self(Double(self).squareRoot())
    var res = Set<Self>()

    for factor in stride(from: 1, through: maxN, by: 1) where self % factor == 0 {
      res.insert(factor)
      res.insert(self / factor)
    }

    return sorted ? res.sorted() : Array(res)
  }
}

@inlinable
public func isAbundant<T: BinaryInteger>(n: T) -> (Bool, [T]) {
  let divs = n.factors().dropLast()

  return (divs.reduce(0, +) > n, Array(divs))
}

let oddAbundant = (0...).lazy.filter({ $0 & 1 == 1 }).map({ ($0, isAbundant(n: $0)) }).filter({ $1.0 })

for (n, (_, factors)) in oddAbundant.prefix(25) {
  print("n: \(n); sigma: \(factors.reduce(0, +))")
}

let (bigA, (_, bigFactors)) =
  (1_000_000_000...)
    .lazy
    .filter({ $0 & 1 == 1 })
    .map({ ($0, isAbundant(n: $0)) })
    .first(where: { $1.0 })!

print("first odd abundant number over 1 billion: \(bigA), sigma: \(bigFactors.reduce(0, +))")
