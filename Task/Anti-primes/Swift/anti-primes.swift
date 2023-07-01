extension BinaryInteger {
  @inlinable
  public func countDivisors() -> Int {
    var workingN = self
    var count = 1

    while workingN & 1 == 0 {
      workingN >>= 1

      count += 1
    }

    var d = Self(3)

    while d * d <= workingN {
      var (quo, rem) = workingN.quotientAndRemainder(dividingBy: d)

      if rem == 0 {
        var dc = 0

        while rem == 0 {
          dc += count
          workingN = quo

          (quo, rem) = workingN.quotientAndRemainder(dividingBy: d)
        }

        count += dc
      }

      d += 2
    }

    return workingN != 1 ? count * 2 : count
  }
}

var antiPrimes = [Int]()
var maxDivs = 0

for n in 1... {
  guard antiPrimes.count < 20 else {
    break
  }

  let divs = n.countDivisors()

  if maxDivs < divs {
    maxDivs = divs
    antiPrimes.append(n)
  }
}

print("First 20 anti-primes are \(Array(antiPrimes))")
