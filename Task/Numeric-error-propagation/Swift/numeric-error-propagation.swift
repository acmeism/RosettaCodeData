import Foundation

precedencegroup ExponentiationGroup {
  higherThan: MultiplicationPrecedence
}

infix operator ** : ExponentiationGroup
infix operator ±

func ±(_ lhs: Double, _ rhs: Double) -> UncertainDouble { UncertainDouble(value: lhs, error: rhs) }

struct UncertainDouble {
  var value: Double
  var error: Double

  static func +(_ lhs: UncertainDouble, _ rhs: UncertainDouble) -> UncertainDouble {
    return UncertainDouble(value: lhs.value + rhs.value, error: pow(pow(lhs.error, 2) + pow(rhs.error, 2), 0.5))
  }

  static func +(_ lhs: UncertainDouble, _ rhs: Double) -> UncertainDouble {
    return UncertainDouble(value: lhs.value + rhs, error: lhs.error)
  }

  static func -(_ lhs: UncertainDouble, _ rhs: UncertainDouble) -> UncertainDouble {
    return UncertainDouble(value: lhs.value - rhs.value, error: pow(pow(lhs.error, 2) + pow(rhs.error, 2), 0.5))
  }

  static func -(_ lhs: UncertainDouble, _ rhs: Double) -> UncertainDouble {
    return UncertainDouble(value: lhs.value - rhs, error: lhs.error)
  }

  static func *(_ lhs: UncertainDouble, _ rhs: UncertainDouble) -> UncertainDouble {
    let val = lhs.value * rhs.value

    return UncertainDouble(
      value: val,
      error: pow(pow(val, 2) * (pow(lhs.error / lhs.value, 2) + pow(rhs.error / rhs.value, 2)), 0.5)
    )
  }

  static func *(_ lhs: UncertainDouble, _ rhs: Double) -> UncertainDouble {
    return UncertainDouble(value: lhs.value * rhs, error: abs(lhs.error * rhs))
  }

  static func /(_ lhs: UncertainDouble, _ rhs: UncertainDouble) -> UncertainDouble {
    let val = lhs.value / rhs.value

    return UncertainDouble(
      value: val,
      error: pow(val, 2) * (pow(lhs.error / lhs.value, 2) + pow(rhs.error / rhs.value, 2))
    )
  }

  static func /(_ lhs: UncertainDouble, _ rhs: Double) -> UncertainDouble {
    return UncertainDouble(value: lhs.value / rhs, error: abs(lhs.error * rhs))
  }

  static func **(_ lhs: UncertainDouble, _ power: Double) -> UncertainDouble {
    let val = pow(lhs.value, power)

    return UncertainDouble(value: val, error: abs((val * power) * (lhs.error / lhs.value)))
  }
}

extension UncertainDouble: CustomStringConvertible {
  public var description: String { "\(value) ± \(error)" }
}

let (x1, y1) = (100 ± 1.1, 50 ± 1.2)
let (x2, y2) = (200 ± 2.2, 100 ± 2.3)

let d = ((x2 - x1) ** 2 + (y2 - y1) ** 2) ** 0.5

print(d)
