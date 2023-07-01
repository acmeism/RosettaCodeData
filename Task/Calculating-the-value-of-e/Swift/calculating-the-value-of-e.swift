import Foundation


func calculateE(epsilon: Double = 1.0e-15) -> Double {
  var fact: UInt64 = 1
  var e = 2.0, e0 = 0.0
  var n = 2

  repeat {
    e0 = e
    fact *= UInt64(n)
    n += 1
    e += 1.0 / Double(fact)
  } while fabs(e - e0) >= epsilon

  return e
}

print(String(format: "e = %.15f\n", arguments: [calculateE()]))
