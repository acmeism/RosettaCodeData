import Foundation

public struct Vector {
  public var x = 0.0
  public var y = 0.0
  public var z = 0.0

  public init(x: Double, y: Double, z: Double) {
    (self.x, self.y, self.z) = (x, y, z)
  }

  public func mod() -> Double {
    (x * x + y * y + z * z).squareRoot()
  }

  public static func + (lhs: Vector, rhs: Vector) -> Vector {
    return Vector(
      x: lhs.x + rhs.x,
      y: lhs.y + rhs.y,
      z: lhs.z + rhs.z
    )
  }

  public static func * (lhs: Vector, rhs: Double) -> Vector {
    return Vector(
      x: lhs.x * rhs,
      y: lhs.y * rhs,
      z: lhs.z * rhs
    )
  }

  public static func *= (lhs: inout Vector, rhs: Double) {
    lhs.x *= rhs
    lhs.y *= rhs
    lhs.z *= rhs
  }

  public static func / (lhs: Vector, rhs: Double) -> Vector {
    return lhs * (1 / rhs)
  }

  public static func /= (lhs: inout Vector, rhs: Double) {
    lhs = lhs * (1 / rhs)
  }
}

extension Vector: CustomStringConvertible {
  public var description: String {
    return String(format: "%.6f\t%.6f\t%.6f", x, y, z)
  }
}

private func mulAdd(v1: Vector, x1: Double, v2: Vector, x2: Double) -> Vector {
  return v1 * x1 + v2 * x2
}

private func rotate(_ i: Vector, _ j: Vector, alpha: Double) -> (Vector, Vector) {
  return (
    mulAdd(v1: i, x1: +cos(alpha), v2: j, x2: sin(alpha)),
    mulAdd(v1: i, x1: -sin(alpha), v2: j, x2: cos(alpha))
  )
}

public func orbitalStateVectors(
  semimajorAxis: Double,
  eccentricity: Double,
  inclination: Double,
  longitudeOfAscendingNode: Double,
  argumentOfPeriapsis: Double,
  trueAnomaly: Double
) -> (Vector, Vector) {
  var i = Vector(x: 1.0, y: 0.0, z: 0.0)
  var j = Vector(x: 0.0, y: 1.0, z: 0.0)
  let k = Vector(x: 0.0, y: 0.0, z: 1.0)

  (i, j) = rotate(i, j, alpha: longitudeOfAscendingNode)
  (j, _) = rotate(j, k, alpha: inclination)
  (i, j) = rotate(i, j, alpha: argumentOfPeriapsis)

  let l = eccentricity == 1.0 ? 2.0 : 1.0 - eccentricity * eccentricity
  let c = cos(trueAnomaly)
  let s = sin(trueAnomaly)
  let r = l / (1.0 + eccentricity * c)
  let rPrime = s * r * r / l
  let position = mulAdd(v1: i, x1: c, v2: j, x2: s) * r
  var speed = mulAdd(v1: i, x1: rPrime * c - r * s, v2: j, x2: rPrime * s + r * c)

  speed /= speed.mod()
  speed *= (2.0 / r - 1.0 / semimajorAxis).squareRoot()

  return (position, speed)
}

let (position, speed) = orbitalStateVectors(
  semimajorAxis: 1.0,
  eccentricity: 0.1,
  inclination: 0.0,
  longitudeOfAscendingNode: 355.0 / (113.0 * 6.0),
  argumentOfPeriapsis: 0.0,
  trueAnomaly: 0.0
)

print("Position: \(position); Speed: \(speed)")
