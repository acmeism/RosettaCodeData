precedencegroup ExponentiationGroup {
  higherThan: MultiplicationPrecedence
}

infix operator ** : ExponentiationGroup

protocol Ring {
  associatedtype RingType: Numeric

  var one: Self { get }

  static func +(_ lhs: Self, _ rhs: Self) -> Self
  static func *(_ lhs: Self, _ rhs: Self) -> Self
  static func **(_ lhs: Self, _ rhs: Int) -> Self
}

extension Ring  {
  static func **(_ lhs: Self, _ rhs: Int) -> Self {
    var ret = lhs.one

    for _ in stride(from: rhs, to: 0, by: -1) {
      ret = ret * lhs
    }

    return ret
  }
}

struct ModInt: Ring {
  typealias RingType = Int

  var value: Int
  var modulo: Int

  var one: ModInt { ModInt(1, modulo: modulo) }

  init(_ value: Int, modulo: Int) {
    self.value = value
    self.modulo = modulo
  }

  static func +(lhs: ModInt, rhs: ModInt) -> ModInt {
    precondition(lhs.modulo == rhs.modulo)

    return ModInt((lhs.value + rhs.value) % lhs.modulo, modulo: lhs.modulo)
  }

  static func *(lhs: ModInt, rhs: ModInt) -> ModInt {
    precondition(lhs.modulo == rhs.modulo)

    return ModInt((lhs.value * rhs.value) % lhs.modulo, modulo: lhs.modulo)
  }
}

func f<T: Ring>(_ x: T) -> T { (x ** 100) + x + x.one }

let x = ModInt(10, modulo: 13)
let y = f(x)

print("x ^ 100 + x + 1 for x = ModInt(10, 13) is \(y)")
