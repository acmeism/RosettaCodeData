import BigInt

func largestLeftTruncatablePrime(_ base: Int) -> BigInt {
  var radix = 0
  var candidates = [BigInt(0)]

  while true {
    let multiplier = BigInt(base).power(radix)
    var newCandidates = [BigInt]()

    for i in 1..<BigInt(base) {
      newCandidates += candidates.map({ ($0+i*multiplier, ($0+i*multiplier).isPrime(rounds: 30)) })
                                 .filter({ $0.1 })
                                 .map({ $0.0 })
    }

    if newCandidates.count == 0 {
      return candidates.max()!
    }

    candidates = newCandidates
    radix += 1
  }
}

for i in 3..<18 {
  print("\(i): \(largestLeftTruncatablePrime(i))")
}
