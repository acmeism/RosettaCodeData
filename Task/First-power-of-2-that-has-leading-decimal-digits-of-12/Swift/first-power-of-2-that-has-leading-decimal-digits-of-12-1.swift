let ld10 = log(2.0) / log(10.0)

func p(L: Int, n: Int) -> Int {
  var l = L
  var digits = 1

  while l >= 10 {
    digits *= 10
    l /= 10
  }

  var count = 0
  var i = 0

  while count < n {
    let rhs = (Double(i) * ld10).truncatingRemainder(dividingBy: 1)
    let e = exp(log(10.0) * rhs)

    if Int(e * Double(digits)) == L {
      count += 1
    }

    i += 1
  }

  return i - 1
}

let cases = [
  (12, 1),
  (12, 2),
  (123, 45),
  (123, 12345),
  (123, 678910)
]

for (l, n) in cases {
  print("p(\(l), \(n)) = \(p(L: l, n: n))")
}
