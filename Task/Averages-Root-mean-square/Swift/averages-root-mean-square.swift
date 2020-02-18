extension Collection where Element: FloatingPoint {
  @inlinable
  public func rms() -> Element {
    return (lazy.map({ $0 * $0 }).reduce(0, +) / Element(count)).squareRoot()
  }
}

print("RMS of 1...10: \((1...10).map(Double.init).rms())")
