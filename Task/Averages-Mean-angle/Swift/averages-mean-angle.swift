import Foundation

@inlinable public func d2r<T: FloatingPoint>(_ f: T) -> T { f * .pi / 180 }
@inlinable public func r2d<T: FloatingPoint>(_ f: T) -> T { f * 180 / .pi }

public func meanOfAngles(_ angles: [Double]) -> Double {
  let cInv = 1 / Double(angles.count)
  let (s, c) =
    angles.lazy
      .map(d2r)
      .map({ (sin($0), cos($0)) })
      .reduce(into: (0.0, 0.0), { $0.0 += $1.0; $0.1 += $1.1 })

  return r2d(atan2(cInv * s, cInv * c))
}

let fmt = { String(format: "%lf", $0) }

print("Mean of angles (350, 10) => \(fmt(meanOfAngles([350, 10])))")
print("Mean of angles (90, 180, 270, 360) => \(fmt(meanOfAngles([90, 180, 270, 360])))")
print("Mean of angles (10, 20, 30) => \(fmt(meanOfAngles([10, 20, 30])))")
