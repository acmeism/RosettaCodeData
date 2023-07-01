extension Sequence {
  func take(_ n: Int) -> [Element] {
    var res = [Element]()

    for el in self {
      guard res.count != n else {
        return res
      }

      res.append(el)
    }

    return res
  }
}

extension String {
  func isEsthetic(base: Int = 10) -> Bool {
    zip(dropFirst(0), dropFirst())
      .lazy
      .allSatisfy({ abs(Int(String($0.0), radix: base)! - Int(String($0.1), radix: base)!) == 1 })
  }
}

func getEsthetics(from: Int, to: Int, base: Int = 10) -> [String] {
  guard base >= 2, to >= from else {
    return []
  }

  var start = ""
  var end = ""

  repeat {
    if start.count & 1 == 1 {
      start += "0"
    } else {
      start += "1"
    }
  } while Int(start, radix: base)! < from

  let digiMax = String(base - 1, radix: base)
  let lessThanDigiMax = String(base - 2, radix: base)
  var count = 0

  repeat {
    if count != base - 1 {
      end += String(count + 1, radix: base)
      count += 1
    } else {
      if String(end.last!) == digiMax {
        end += lessThanDigiMax
      } else {
        end += digiMax
      }
    }
  } while Int(end, radix: base)! < to

  if Int(start, radix: base)! >= Int(end, radix: base)! {
    return []
  }

  var esthetics = [Int]()

  func shimmer(_ n: Int, _ m: Int, _ i: Int) {
    if (n...m).contains(i) {
      esthetics.append(i)
    } else if i == 0 || i > m {
      return
    }

    let d = i % base
    let i1 = i &* base &+ d &- 1
    let i2 = i1 &+ 2

    if (i1 < i || i2 < i) {
      // overflow
      return
    }

    switch d {
    case 0: shimmer(n, m, i2)
    case base-1: shimmer(n, m, i1)
    case _:
      shimmer(n, m, i1)
      shimmer(n, m, i2)
    }
  }

  for digit in 0..<base {
    shimmer(Int(start, radix: base)!, Int(end, radix: base)!, digit)
  }

  return esthetics.filter({ $0 <= to }).map({ String($0, radix: base) })
}

for base in 2...16 {
  let esthetics = (0...)
    .lazy
    .map({ String($0, radix: base) })
    .filter({ $0.isEsthetic(base: base) })
    .dropFirst(base * 4)
    .take((base * 6) - (base * 4) + 1)

  print("Base \(base) esthetics from \(base * 4) to \(base * 6)")
  print(esthetics)
  print()
}

let base10Esthetics = (1000...9999).filter({ String($0).isEsthetic() })

print("\(base10Esthetics.count) esthetics between 1000 and 9999:")
print(base10Esthetics)
print()

func printSlice(of array: [String]) {
  print(array.take(5))
  print("...")
  print(Array(array.lazy.reversed().take(5).reversed()))
  print("\(array.count) total\n")
}

print("Esthetics between \(Int(1e8)) and \(13 * Int(1e7)):")
printSlice(of: getEsthetics(from: Int(1e8), to: 13 * Int(1e7)))

print("Esthetics between \(Int(1e11)) and \(13 * Int(1e10))")
printSlice(of: getEsthetics(from: Int(1e11), to: 13 * Int(1e10)))

print("Esthetics between \(Int(1e14)) and \(13 * Int(1e13)):")
printSlice(of: getEsthetics(from: Int(1e14), to: 13 * Int(1e13)))

print("Esthetics between \(Int(1e17)) and \(13 * Int(1e16)):")
printSlice(of: getEsthetics(from: Int(1e17), to: 13 * Int(1e16)))
