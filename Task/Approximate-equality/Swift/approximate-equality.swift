import Foundation

extension FloatingPoint {
  @inlinable
  public func isAlmostEqual(
    to other: Self,
    tolerance: Self = Self.ulpOfOne.squareRoot()
  ) -> Bool {
    // tolerances outside of [.ulpOfOne,1) yield well-defined but useless results,
    // so this is enforced by an assert rathern than a precondition.
    assert(tolerance >= .ulpOfOne && tolerance < 1, "tolerance should be in [.ulpOfOne, 1).")

    // The simple computation below does not necessarily give sensible
    // results if one of self or other is infinite; we need to rescale
    // the computation in that case.
    guard self.isFinite && other.isFinite else {
      return rescaledAlmostEqual(to: other, tolerance: tolerance)
    }

    // This should eventually be rewritten to use a scaling facility to be
    // defined on FloatingPoint suitable for hypot and scaled sums, but the
    // following is good enough to be useful for now.
    let scale = max(abs(self), abs(other), .leastNormalMagnitude)
    return abs(self - other) < scale*tolerance
  }

  @usableFromInline
  internal func rescaledAlmostEqual(to other: Self, tolerance: Self) -> Bool {
    // NaN is considered to be not approximately equal to anything, not even
    // itself.
    if self.isNaN || other.isNaN { return false }
    if self.isInfinite {
      if other.isInfinite { return self == other }

      // Self is infinite and other is finite. Replace self with the binade
      // of the greatestFiniteMagnitude, and reduce the exponent of other by
      // one to compensate.
      let scaledSelf = Self(sign: self.sign,
        exponent: Self.greatestFiniteMagnitude.exponent,
        significand: 1)
      let scaledOther = Self(sign: .plus,
        exponent: -1,
        significand: other)

      // Now both values are finite, so re-run the naive comparison.
      return scaledSelf.isAlmostEqual(to: scaledOther, tolerance: tolerance)
    }

    // If self is finite and other is infinite, flip order and use scaling
    // defined above, since this relation is symmetric.
    return other.rescaledAlmostEqual(to: self, tolerance: tolerance)
  }
}

let testCases = [
  (100000000000000.01, 100000000000000.011),
  (100.01, 100.011),
  (10000000000000.001 / 10000.0, 1000000000.0000001000),
  (0.001, 0.0010000001),
  (0.000000000000000000000101, 0.0),
  (sqrt(2) * sqrt(2), 2.0),
  (-sqrt(2) * sqrt(2), -2.0),
  (3.14159265358979323846, 3.14159265358979324)
]

for testCase in testCases {
  print("\(testCase.0), \(testCase.1) => \(testCase.0.isAlmostEqual(to: testCase.1))")
}
