import Foundation

func primes(_ n: Int)
    -> UnfoldSequence<Int, (Int?, Bool)> {
  var sieve = Array<Bool>(repeating: true, count: n + 1)
  let lim = Int(sqrt(Double(n)))

  for i in 2...lim {
    if sieve[i] {
      for notPrime in stride(from: i*i, through: n, by: i) {
        sieve[notPrime] = false
      }
    }
  }

  return sequence(first: 2, next: { (p:Int) -> Int? in
    var np = p + 1
    while np <= n && !sieve[np] { np += 1}
    return np > n ? nil : np
  })
}

let range = 100000000

print("The primes up to 100 are:")
primes(100).forEach { print($0, "", terminator: "") }
print()

print("Found \(primes(1000000).reduce(0) { (a, _) in a + 1 }) primes to 1000000.")

let start = NSDate()
var answr = primes(range).reduce(0) { (a, _) in a + 1 }
let elpsd = -start.timeIntervalSinceNow

print("Found \(answr) primes to \(range).")

print(String(format: "This test took %.3f milliseconds.", elpsd * 1000))
