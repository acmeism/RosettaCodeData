extension BinaryInteger {
  @inlinable
  public var isNarcissistic: Bool {
    let digits = String(self).map({ Int(String($0))! })
    let m = digits.count

    guard m != 1 else {
      return true
    }

    return digits.map({ $0.power(m) }).reduce(0, +) == self
  }

  @inlinable
  public func power(_ n: Self) -> Self {
    return stride(from: 0, to: n, by: 1).lazy.map({_ in self }).reduce(1, *)
  }

}

let narcs = Array((0...).lazy.filter({ $0.isNarcissistic }).prefix(25))

print("First 25 narcissistic numbers are \(narcs)")
