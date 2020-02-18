import Foundation

@inlinable public func d2r<T: FloatingPoint>(_ f: T) -> T { f * .pi / 180 }
@inlinable public func r2d<T: FloatingPoint>(_ f: T) -> T { f * 180 / .pi }

public func meanOfAngles(_ angles: [Double]) -> Double {
  let cInv = 1 / Double(angles.count)
  let (y, x) =
    angles.lazy
      .map(d2r)
      .map({ (sin($0), cos($0)) })
      .reduce(into: (0.0, 0.0), { $0.0 += $1.0; $0.1 += $1.1 })

  return r2d(atan2(cInv * y, cInv * x))
}

struct DigitTime {
  var hour: Int
  var minute: Int
  var second: Int

  init?(fromString str: String) {
    let split = str.components(separatedBy: ":").compactMap(Int.init)

    guard split.count == 3 else {
      return nil
    }

    (hour, minute, second) = (split[0], split[1], split[2])
  }

  init(fromDegrees angle: Double) {
    let totalSeconds = 24 * 60 * 60 * angle / 360

    second = Int(totalSeconds.truncatingRemainder(dividingBy: 60))
    minute = Int((totalSeconds.truncatingRemainder(dividingBy: 3600) - Double(second)) / 60)
    hour = Int(totalSeconds / 3600)
  }

  func toDegrees() -> Double {
    return 360 * Double(hour) / 24.0 + 360 * Double(minute) / (24 * 60.0) + 360 * Double(second) / (24 * 3600.0)
  }
}

extension DigitTime: CustomStringConvertible {
  var description: String { String(format: "%02i:%02i:%02i", hour, minute, second) }
}

let times = ["23:00:17", "23:40:20", "00:12:45", "00:17:19"].compactMap(DigitTime.init(fromString:))

guard times.count == 4 else {
  fatalError()
}

let meanTime = DigitTime(fromDegrees: 360 + meanOfAngles(times.map({ $0.toDegrees() })))

print("Given times \(times), the mean time is \(meanTime)")
