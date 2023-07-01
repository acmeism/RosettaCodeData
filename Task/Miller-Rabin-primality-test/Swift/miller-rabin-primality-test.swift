import BigInt

private let numTrails = 5

func isPrime(_ n: BigInt) -> Bool {
  guard n >= 2 else { fatalError() }
  guard n != 2 else { return true }
  guard n % 2 != 0 else { return false }

  var s = 0
  var d = n - 1

  while true {
    let (quo, rem) = (d / 2, d % 2)

    guard rem != 1 else { break }

    s += 1
    d = quo
  }

  func tryComposite(_ a: BigInt) -> Bool {
    guard a.power(d, modulus: n) != 1 else { return false }

    for i in 0..<s where a.power((2 as BigInt).power(i) * d, modulus: n) == n - 1 {
      return false
    }

    return true
  }

  for _ in 0..<numTrails where tryComposite(BigInt(BigUInt.randomInteger(lessThan: BigUInt(n)))) {
    return false
  }

  return true
}
