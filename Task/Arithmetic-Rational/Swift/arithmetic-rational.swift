import Foundation

extension BinaryInteger {
  @inlinable
  public func gcd(with other: Self) -> Self {
    var gcd = self
    var b = other

    while b != 0 {
      (gcd, b) = (b, gcd % b)
    }

    return gcd
  }

  @inlinable
  public func lcm(with other: Self) -> Self {
    let g = gcd(with: other)

    return self / g * other
  }
}

public struct Frac<NumType: BinaryInteger & SignedNumeric>: Equatable {
  @usableFromInline
  var _num: NumType

  @usableFromInline
  var _dom: NumType

  @usableFromInline
  init(_num: NumType, _dom: NumType) {
    self._num = _num
    self._dom = _dom
  }

  @inlinable
  public init(numerator: NumType, denominator: NumType) {
    let divisor = numerator.gcd(with: denominator)

    self._num = numerator / divisor
    self._dom = denominator / divisor
  }

  @inlinable
  public static func + (lhs: Frac, rhs: Frac) -> Frac {
    let multiplier = lhs._dom.lcm(with: rhs.denominator)

    return Frac(
      numerator: lhs._num * multiplier / lhs._dom + rhs._num * multiplier / rhs._dom,
      denominator: multiplier
    )
  }

  @inlinable
  public static func += (lhs: inout Frac, rhs: Frac) {
    lhs = lhs + rhs
  }

  @inlinable
  public static func - (lhs: Frac, rhs: Frac) -> Frac {
    return lhs + -rhs
  }

  @inlinable
  public static func -= (lhs: inout Frac, rhs: Frac) {
    lhs = lhs + -rhs
  }

  @inlinable
  public static func * (lhs: Frac, rhs: Frac) -> Frac {
    return Frac(numerator: lhs._num * rhs._num, denominator: lhs._dom * rhs._dom)
  }

  @inlinable
  public static func *= (lhs: inout Frac, rhs: Frac) {
    lhs = lhs * rhs
  }

  @inlinable
  public static func / (lhs: Frac, rhs: Frac) -> Frac {
    return lhs * Frac(_num: rhs._dom, _dom: rhs._num)
  }

  @inlinable
  public static func /= (lhs: inout Frac, rhs: Frac) {
    lhs = lhs / rhs
  }

  @inlinable
  prefix static func - (rhs: Frac) -> Frac {
    return Frac(_num: -rhs._num, _dom: rhs._dom)
  }
}

extension Frac {
  @inlinable
  public var numerator: NumType {
    get { _num }
    set {
      let divisor = newValue.gcd(with: denominator)

      _num = newValue / divisor
      _dom = denominator / divisor
    }
  }

  @inlinable
  public var denominator: NumType {
    get { _dom }
    set {
      let divisor = newValue.gcd(with: numerator)

      _num = numerator / divisor
      _dom = newValue / divisor
    }
  }
}

extension Frac: CustomStringConvertible {
  public var description: String {
    let neg = numerator < 0 || denominator < 0

    return "Frac(\(neg ? "-" : "")\(abs(numerator)) / \(abs(denominator)))"
  }
}

extension Frac: Comparable {
  @inlinable
  public static func <(lhs: Frac, rhs: Frac) -> Bool {
    return lhs._num * rhs._dom < lhs._dom * rhs._num
  }
}

extension Frac: ExpressibleByIntegerLiteral {
  public init(integerLiteral value: Int) {
    self._num = NumType(value)
    self._dom = 1
  }
}


for candidate in 2..<1<<19 {
  var sum = Frac(numerator: 1, denominator: candidate)

  let m = Int(ceil(Double(candidate).squareRoot()))

  for factor in 2..<m where candidate % factor == 0 {
    sum += Frac(numerator: 1, denominator: factor)
    sum += Frac(numerator: 1, denominator: candidate / factor)
  }

  if sum == 1 {
    print("\(candidate) is perfect")
  }
}
