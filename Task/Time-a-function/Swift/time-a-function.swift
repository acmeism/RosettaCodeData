import Foundation

public struct TimeResult {
  public var seconds: Double
  public var nanoSeconds: Double

  public var duration: Double { seconds + (nanoSeconds / 1e9) }

  @usableFromInline
  init(seconds: Double, nanoSeconds: Double) {
    self.seconds = seconds
    self.nanoSeconds = nanoSeconds
  }
}

extension TimeResult: CustomStringConvertible {
  public var description: String {
    return "TimeResult(seconds: \(seconds); nanoSeconds: \(nanoSeconds); duration: \(duration)s)"
  }
}

public struct ClockTimer {
  @inlinable @inline(__always)
  public static func time<T>(_ f: () throws -> T) rethrows -> (T, TimeResult) {
    var tsi = timespec()
    var tsf = timespec()

    clock_gettime(CLOCK_MONOTONIC_RAW, &tsi)
    let res = try f()
    clock_gettime(CLOCK_MONOTONIC_RAW, &tsf)

    let secondsElapsed = difftime(tsf.tv_sec, tsi.tv_sec)
    let nanoSecondsElapsed = Double(tsf.tv_nsec - tsi.tv_nsec)

    return (res, TimeResult(seconds: secondsElapsed, nanoSeconds: nanoSecondsElapsed))
  }
}

func ackermann(m: Int, n: Int) -> Int {
  switch (m, n) {
  case (0, _):
    return n + 1
  case (_, 0):
    return ackermann(m: m - 1, n: 1)
  case (_, _):
    return ackermann(m: m - 1, n: ackermann(m: m, n: n - 1))
  }
}

let (n, t) = ClockTimer.time { ackermann(m: 3, n: 11) }

print("Took \(t.duration)s to calculate ackermann(m: 3, n: 11) = \(n)")

let (n2, t2) = ClockTimer.time { ackermann(m: 4, n: 1) }

print("Took \(t2.duration)s to calculate ackermann(m: 4, n: 1) = \(n2)")
