precedencegroup ExponentiationPrecedence {
  associativity: left
  higherThan: MultiplicationPrecedence
}

infix operator ** : ExponentiationPrecedence

@inlinable
public func ** <T: BinaryInteger>(lhs: T, rhs: T) -> T {
  guard lhs != 0 else {
    return 1
  }

  var x = lhs
  var n = rhs
  var y = T(1)

  while n > 1 {
    switch n & 1 {
    case 0:
      n /= 2
    case 1:
      y *= x
      n = (n - 1) / 2
    case _:
      fatalError()
    }

    x *= x
  }

  return x * y
}

print(5 ** 3 ** 2)
print((5 ** 3) ** 2)
print(5 ** (3 ** 2))
