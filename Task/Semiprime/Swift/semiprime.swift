import Foundation

func primes(n: Int) -> AnyGenerator<Int> {

  var (seive, i) = ([Int](0..<n), 1)
  let lim = Int(sqrt(Double(n)))

  return anyGenerator {
    while ++i < n {
      if seive[i] != 0 {
        if i <= lim {
          for notPrime in stride(from: i*i, to: n, by: i) {
            seive[notPrime] = 0
          }
        }
        return i
      }
    }
    return nil
  }
}

func isSemiPrime(n: Int) -> Bool {
  let g = primes(n)
  while let first = g.next() {
    if n % first == 0 {
      if first * first == n {
        return true
      } else {
        while let second = g.next() {
          if first * second == n { return true }
        }
      }
    }
  }
  return false
}
