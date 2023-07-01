import Foundation

extension BinaryInteger {
  @inlinable
  public var isZumkeller: Bool {
    let divs = factors(sorted: false)
    let sum = divs.reduce(0, +)

    guard sum & 1 != 1 else {
      return false
    }

    guard self & 1 != 1 else {
      let abundance = sum - 2*self

      return abundance > 0 && abundance & 1 == 0
    }

    return isPartSum(divs: divs[...], sum: sum / 2)
  }

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

@usableFromInline
func isPartSum<T: BinaryInteger>(divs: ArraySlice<T>, sum: T) -> Bool {
  guard sum != 0 else {
    return true
  }

  guard !divs.isEmpty else {
    return false
  }

  let last = divs.last!

  if last > sum {
    return isPartSum(divs: divs.dropLast(), sum: sum)
  }

  return isPartSum(divs: divs.dropLast(), sum: sum) || isPartSum(divs: divs.dropLast(), sum: sum - last)
}

let zums = (2...).lazy.filter({ $0.isZumkeller })
let oddZums = zums.filter({ $0 & 1 == 1 })
let oddZumsWithout5 = oddZums.filter({ String($0).last! != "5" })

print("First 220 zumkeller numbers are \(Array(zums.prefix(220)))")
print("First 40 odd zumkeller numbers are \(Array(oddZums.prefix(40)))")
print("First 40 odd zumkeller numbers that don't end in a 5 are: \(Array(oddZumsWithout5.prefix(40)))")
