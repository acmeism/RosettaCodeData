import BigInt

func factorial<T: BinaryInteger>(_ n: T) -> T {
  guard n != 0 else {
    return 1
  }

  return stride(from: n, to: 0, by: -1).reduce(1, *)
}


func isWilsonPrime<T: BinaryInteger>(_ n: T) -> Bool {
  guard n >= 2 else {
    return false
  }

  return (factorial(n - 1) + 1) % n == 0
}

print((1...100).map({ BigInt($0) }).filter(isWilsonPrime))
