extension FloatingPoint where Self: ExpressibleByFloatLiteral {
  @inlinable
  public func power(_ e: Int) -> Self {
    var res = Self(1)

    for _ in 0..<e {
      res *= self
    }

    return res
  }

  @inlinable
  public func root(n: Int, epsilon: Self = 2.220446049250313e-16) -> Self {
    var d = Self(0)
    var res = Self(1)

    guard self != 0 else {
      return 0
    }

    guard n >= 1 else {
      return .nan
    }

    repeat {
      d = (self / res.power(n - 1) - res) / Self(n)
      res += d
    } while d >= epsilon * 10 || d <= -epsilon * 10

    return res
  }
}

print(81.root(n: 4))
print(13.root(n: 5))
