import BigNumber

func sylvester(n: Int) -> BInt {
  var a = BInt(2)

  for _ in 0..<n {
    a = a * a - a + 1
  }

  return a
}

var sum = BDouble(0)

for n in 0..<10 {
  let syl = sylvester(n: n)
  sum += BDouble(1) / BDouble(syl)
  print(syl)
}

print("Sum of the reciprocals of first ten in sequence: \(sum)")
