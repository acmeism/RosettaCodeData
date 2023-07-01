extension BinaryInteger {
  @inlinable
  public func egyptianDivide(by divisor: Self) -> (quo: Self, rem: Self) {
    let table =
      (0...).lazy
        .map({i -> (Self, Self) in
          let power = Self(2).power(Self(i))

          return (power, power * divisor)
        })
        .prefix(while: { $0.1 <= self })
        .reversed()

    let (answer, acc) = table.reduce((Self(0), Self(0)), {cur, row in
      let ((ans, acc), (power, doubling)) = (cur, row)

      return acc + doubling <= self ? (ans + power, doubling + acc) : cur
    })

    return (answer, Self((acc - self).magnitude))
  }

  @inlinable
  public func power(_ n: Self) -> Self {
    return stride(from: 0, to: n, by: 1).lazy.map({_ in self }).reduce(1, *)
  }
}

let dividend = 580
let divisor = 34
let (quo, rem) = dividend.egyptianDivide(by: divisor)

print("\(dividend) divided by \(divisor) = \(quo) rem \(rem)")
