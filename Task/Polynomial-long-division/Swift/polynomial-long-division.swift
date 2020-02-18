protocol Dividable {
  static func / (lhs: Self, rhs: Self) -> Self
}

extension Int: Dividable { }

struct Solution<T> {
  var quotient: [T]
  var remainder: [T]
}

func polyDegree<T: SignedNumeric>(_ p: [T]) -> Int {
  for i in stride(from: p.count - 1, through: 0, by: -1) where p[i] != 0 {
    return i
  }

  return Int.min
}

func polyShiftRight<T: SignedNumeric>(p: [T], places: Int) -> [T] {
  guard places > 0 else {
    return p
  }

  let deg = polyDegree(p)

  assert(deg + places < p.count, "Number of places to shift too large")

  var res = p

  for i in stride(from: deg, through: 0, by: -1) {
    res[i + places] = res[i]
    res[i] = 0
  }

  return res
}

func polyMul<T: SignedNumeric>(_ p: inout [T], by: T) {
  for i in 0..<p.count {
    p[i] *= by
  }
}

func polySub<T: SignedNumeric>(_ p: inout [T], by: [T]) {
  for i in 0..<p.count {
    p[i] -= by[i]
  }
}

func polyLongDiv<T: SignedNumeric & Dividable>(numerator n: [T], denominator d: [T]) -> Solution<T>? {
  guard n.count == d.count else {
    return nil
  }

  var nDeg = polyDegree(n)
  let dDeg = polyDegree(d)

  guard dDeg >= 0, nDeg >= dDeg else {
    return nil
  }

  var n2 = n
  var quo = [T](repeating: 0, count: n.count)

  while nDeg >= dDeg {
    let i = nDeg - dDeg
    var d2 = polyShiftRight(p: d, places: i)

    quo[i] = n2[nDeg] / d2[nDeg]

    polyMul(&d2, by: quo[i])
    polySub(&n2, by: d2)

    nDeg = polyDegree(n2)
  }

  return Solution(quotient: quo, remainder: n2)
}

func polyPrint<T: SignedNumeric & Comparable>(_ p: [T]) {
  let deg = polyDegree(p)

  for i in stride(from: deg, through: 0, by: -1) where p[i] != 0 {
    let coeff = p[i]

    switch coeff {
    case 1 where i < deg:
      print(" + ", terminator: "")
    case 1:
      print("", terminator: "")
    case -1 where i < deg:
      print(" - ", terminator: "")
    case -1:
      print("-", terminator: "")
    case _ where coeff < 0 && i < deg:
      print(" - \(-coeff)", terminator: "")
    case _ where i < deg:
      print(" + \(coeff)", terminator: "")
    case _:
      print("\(coeff)", terminator: "")
    }

    if i > 1 {
      print("x^\(i)", terminator: "")
    } else if i == 1 {
      print("x", terminator: "")
    }
  }

  print()
}

let n = [-42, 0, -12, 1]
let d = [-3, 1, 0, 0]

print("Numerator: ", terminator: "")
polyPrint(n)
print("Denominator: ", terminator: "")
polyPrint(d)

guard let sol = polyLongDiv(numerator: n, denominator: d) else {
  fatalError()
}

print("----------")
print("Quotient: ", terminator: "")
polyPrint(sol.quotient)
print("Remainder: ", terminator: "")
polyPrint(sol.remainder)
