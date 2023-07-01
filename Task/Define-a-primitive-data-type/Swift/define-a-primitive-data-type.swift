struct SmallInt {
  var value: Int

  init(value: Int) {
    guard value >= 1 && value <= 10 else {
      fatalError("SmallInts must be in the range [1, 10]")
    }

    self.value = value
  }

  static func +(_ lhs: SmallInt, _ rhs: SmallInt) -> SmallInt { SmallInt(value: lhs.value + rhs.value) }
  static func -(_ lhs: SmallInt, _ rhs: SmallInt) -> SmallInt { SmallInt(value: lhs.value - rhs.value) }
  static func *(_ lhs: SmallInt, _ rhs: SmallInt) -> SmallInt { SmallInt(value: lhs.value * rhs.value) }
  static func /(_ lhs: SmallInt, _ rhs: SmallInt) -> SmallInt { SmallInt(value: lhs.value / rhs.value) }
}

extension SmallInt: ExpressibleByIntegerLiteral {
  public init(integerLiteral value: Int) { self.init(value: value) }
}

extension SmallInt: CustomStringConvertible {
  public var description: String { "\(value)" }
}

let a: SmallInt = 1
let b: SmallInt = 9
let c: SmallInt = 10
let d: SmallInt = 2

print(a + b)
print(c - b)
print(a * c)
print(c / d)
print(a + c)
