import Foundation
#if canImport(Numerics)
import Numerics
#endif

struct Vector<T: Numeric> {
  var x: T
  var y: T

  func prettyPrinted(precision: Int = 4) -> String where T: CVarArg & FloatingPoint {
    return String(format: "[%.\(precision)f, %.\(precision)f]", x, y)
  }

  static func +(lhs: Vector, rhs: Vector) -> Vector {
    return Vector(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
  }

  static func -(lhs: Vector, rhs: Vector) -> Vector {
    return Vector(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
  }

  static func *(lhs: Vector, scalar: T) -> Vector {
    return Vector(x: lhs.x * scalar, y: lhs.y * scalar)
  }

  static func /(lhs: Vector, scalar: T) -> Vector where T: FloatingPoint {
    return Vector(x: lhs.x / scalar, y: lhs.y / scalar)
  }

  static func /(lhs: Vector, scalar: T) -> Vector where T: BinaryInteger {
    return Vector(x: lhs.x / scalar, y: lhs.y / scalar)
  }
}

#if canImport(Numerics)
extension Vector where T: ElementaryFunctions {
  static func fromPolar(radians: T, theta: T) -> Vector {
    return Vector(x: radians * T.cos(theta), y: radians * T.sin(theta))
  }
}
#else
extension Vector where T == Double {
  static func fromPolar(radians: Double, theta: Double) -> Vector {
    return Vector(x: radians * cos(theta), y: radians * sin(theta))
  }
}
#endif

print(Vector(x: 4, y: 5))
print(Vector.fromPolar(radians: 3.0, theta: .pi / 3).prettyPrinted())
print((Vector(x: 2, y: 3) + Vector(x: 4, y: 6)))
print((Vector(x: 5.6, y: 1.3) - Vector(x: 4.2, y: 6.1)).prettyPrinted())
print((Vector(x: 3.0, y: 4.2) * 2.3).prettyPrinted())
print((Vector(x: 3.0, y: 4.2) / 2.3).prettyPrinted())
print(Vector(x: 3, y: 4) / 2)
