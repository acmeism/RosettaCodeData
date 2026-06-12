import Foundation

struct Quaternion {
  var a, b, c, d: Double

  static let i = Quaternion(a: 0, b: 1, c: 0, d: 0)
  static let j = Quaternion(a: 0, b: 0, c: 1, d: 0)
  static let k = Quaternion(a: 0, b: 0, c: 0, d: 1)
}
extension Quaternion: Equatable {
  static func ==(lhs: Quaternion, rhs: Quaternion) -> Bool {
    return (lhs.a, lhs.b, lhs.c, lhs.d) == (rhs.a, rhs.b, rhs.c, rhs.d)
  }
}
extension Quaternion: ExpressibleByIntegerLiteral {
  init(integerLiteral: Double) {
    a = integerLiteral
    b = 0
    c = 0
    d = 0
  }
}
extension Quaternion: Numeric {
  var magnitude: Double {
    return norm
  }
  init?<T>(exactly: T) { // stub to satisfy protocol requirements
    return nil
  }
  public static func + (lhs: Quaternion, rhs: Quaternion) -> Quaternion {
    return Quaternion(
      a: lhs.a + rhs.a,
      b: lhs.b + rhs.b,
      c: lhs.c + rhs.c,
      d: lhs.d + rhs.d
    )
  }
  public static func - (lhs: Quaternion, rhs: Quaternion) -> Quaternion {
    return Quaternion(
      a: lhs.a - rhs.a,
      b: lhs.b - rhs.b,
      c: lhs.c - rhs.c,
      d: lhs.d - rhs.d
    )
  }
  public static func * (lhs: Quaternion, rhs: Quaternion) -> Quaternion {
    return Quaternion(
      a: lhs.a*rhs.a - lhs.b*rhs.b - lhs.c*rhs.c - lhs.d*rhs.d,
      b: lhs.a*rhs.b + lhs.b*rhs.a + lhs.c*rhs.d - lhs.d*rhs.c,
      c: lhs.a*rhs.c - lhs.b*rhs.d + lhs.c*rhs.a + lhs.d*rhs.b,
      d: lhs.a*rhs.d + lhs.b*rhs.c - lhs.c*rhs.b + lhs.d*rhs.a
    )
  }
  public static func += (lhs: inout Quaternion, rhs: Quaternion) {
    lhs = Quaternion(
      a: lhs.a + rhs.a,
      b: lhs.b + rhs.b,
      c: lhs.c + rhs.c,
      d: lhs.d + rhs.d
    )
  }
  public static func -= (lhs: inout Quaternion, rhs: Quaternion) {
    lhs = Quaternion(
      a: lhs.a - rhs.a,
      b: lhs.b - rhs.b,
      c: lhs.c - rhs.c,
      d: lhs.d - rhs.d
    )
  }
  public static func *= (lhs: inout Quaternion, rhs: Quaternion) {
    lhs = Quaternion(
      a: lhs.a*rhs.a - lhs.b*rhs.b - lhs.c*rhs.c - lhs.d*rhs.d,
      b: lhs.a*rhs.b + lhs.b*rhs.a + lhs.c*rhs.d - lhs.d*rhs.c,
      c: lhs.a*rhs.c - lhs.b*rhs.d + lhs.c*rhs.a + lhs.d*rhs.b,
      d: lhs.a*rhs.d + lhs.b*rhs.c - lhs.c*rhs.b + lhs.d*rhs.a
    )
  }
}
extension Quaternion: CustomStringConvertible {
  var description: String {
    let formatter = NumberFormatter()
    formatter.positivePrefix = "+"
    let f: (Double) -> String = { formatter.string(from: $0 as NSNumber)! }
    return [f(a), f(b), "i", f(c), "j", f(d), "k"].joined()
  }
}
extension Quaternion {
  var norm: Double {
    return sqrt(a*a + b*b + c*c + d*d)
  }
  var conjugate: Quaternion {
    return Quaternion(a: a, b: -b, c: -c, d: -d)
  }
  public static func + (lhs: Double, rhs: Quaternion) -> Quaternion {
    var result = rhs
    result.a += lhs
    return result
  }
  public static func + (lhs: Quaternion, rhs: Double) -> Quaternion {
    var result = lhs
    result.a += rhs
    return result
  }
  public static func * (lhs: Double, rhs: Quaternion) -> Quaternion {
    return Quaternion(a: lhs*rhs.a, b: lhs*rhs.b, c: lhs*rhs.c, d: lhs*rhs.d)
  }
  public static func * (lhs: Quaternion, rhs: Double) -> Quaternion {
    return Quaternion(a: lhs.a*rhs, b: lhs.b*rhs, c: lhs.c*rhs, d: lhs.d*rhs)
  }
  public static prefix func - (x: Quaternion) -> Quaternion {
    return Quaternion(a: -x.a, b: -x.b, c: -x.c, d: -x.d)
  }
}

let q:  Quaternion = 1 + 2 * .i + 3 * .j + 4 * .k // 1+2i+3j+4k
let q1: Quaternion = 2 + 3 * .i + 4 * .j + 5 * .k // 2+3i+4j+5k
let q2: Quaternion = 3 + 4 * .i + 5 * .j + 6 * .k // 3+4i+5j+6k
let r: Double = 7

print("""
  q  = \(q)
  q1 = \(q1)
  q2 = \(q2)
  r = \(r)
  -q = \(-q)
  ‖q‖ = \(q.norm)
  conjugate of q = \(q.conjugate)
  r + q = q + r = \(r+q) = \(q+r)
  q₁ + q₂ = \(q1 + q2) = \(q2 + q1)
  qr = rq = \(q*r) = \(r*q)
  q₁q₂ = \(q1 * q2)
  q₂q₁ = \(q2 * q1)
  q₁q₂ ≠ q₂q₁ is \(q1*q2 != q2*q1)
""")
