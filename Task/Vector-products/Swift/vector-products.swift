import Foundation

infix operator • : MultiplicationPrecedence
infix operator × : MultiplicationPrecedence

public struct Vector {
  public var x = 0.0
  public var y = 0.0
  public var z = 0.0

  public init(x: Double, y: Double, z: Double) {
    (self.x, self.y, self.z) = (x, y, z)
  }

  public static func • (lhs: Vector, rhs: Vector) -> Double {
    return lhs.x * rhs.x + lhs.y * rhs.y + lhs.z * rhs.z
  }

  public static func × (lhs: Vector, rhs: Vector) -> Vector {
    return Vector(
      x: lhs.y * rhs.z - lhs.z * rhs.y,
      y: lhs.z * rhs.x - lhs.x * rhs.z,
      z: lhs.x * rhs.y - lhs.y * rhs.x
    )
  }
}

let a = Vector(x: 3, y: 4, z: 5)
let b = Vector(x: 4, y: 3, z: 5)
let c = Vector(x: -5, y: -12, z: -13)

print("a: \(a)")
print("b: \(b)")
print("c: \(c)")
print()
print("a • b = \(a • b)")
print("a × b = \(a × b)")
print("a • (b × c) = \(a • (b × c))")
print("a × (b × c) = \(a × (b × c))")
