func lucasLehmer(_ p: Int) -> Bool {
  let m = BigInt(2).power(p) - 1
  var s = BigInt(4)

  for _ in 0..<p-2 {
    s = ((s * s) - 2) % m
  }

  return s == 0
}

for prime in Eratosthenes(upTo: 70) where lucasLehmer(prime) {
  let m = Int(pow(2, Double(prime))) - 1

  print("2^\(prime) - 1 = \(m) is prime")
}
