extension BinaryInteger {
  @inlinable
  public func modInv(_ mod: Self) -> Self {
    var (m, n) = (mod, self)
    var (x, y) = (Self(0), Self(1))

    while n != 0 {
      (x, y) = (y, x - (m / n) * y)
      (m, n) = (n, m % n)
    }

    while x < 0 {
      x += mod
    }

    return x
  }
}

print(42.modInv(2017))
