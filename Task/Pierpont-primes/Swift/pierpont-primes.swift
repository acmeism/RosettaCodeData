import BigInt
import Foundation

public func pierpoint(n: Int) -> (first: [BigInt], second: [BigInt]) {
  var primes = (first: [BigInt](repeating: 0, count: n), second: [BigInt](repeating: 0, count: n))

  primes.first[0] = 2

  var count1 = 1, count2 = 0
  var s = [BigInt(1)]
  var i2 = 0, i3 = 0, k = 1
  var n2 = BigInt(0), n3 = BigInt(0), t = BigInt(0)

  while min(count1, count2) < n {
    n2 = s[i2] * 2
    n3 = s[i3] * 3

    if n2 < n3 {
      t = n2
      i2 += 1
    } else {
      t = n3
      i3 += 1
    }

    if t <= s[k - 1] {
      continue
    }

    s.append(t)
    k += 1
    t += 1

    if count1 < n && t.isPrime(rounds: 10) {
      primes.first[count1] = t
      count1 += 1
    }

    t -= 2

    if count2 < n && t.isPrime(rounds: 10) {
      primes.second[count2] = t
      count2 += 1
    }
  }

  return primes
}


let primes = pierpoint(n: 250)

print("First 50 Pierpoint primes of the first kind: \(Array(primes.first.prefix(50)))\n")
print("First 50 Pierpoint primes of the second kind: \(Array(primes.second.prefix(50)))")
print()
print("250th Pierpoint prime of the first kind: \(primes.first[249])")
print("250th Pierpoint prime of the second kind: \(primes.second[249])")
