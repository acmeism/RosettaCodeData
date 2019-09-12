func vanDerCorput(n: Int, base: Int, num: inout Int, denom: inout Int) {
  var n = n, p = 0, q = 1

  while n != 0 {
    p = p * base + (n % base)
    q *= base
    n /= base
  }

  num = p
  denom = q

  while p != 0 {
    n = p
    p = q % p
    q = n
  }

  num /= q
  denom /= q
}

var num = 0
var denom = 0

for base in 2...5 {
  print("base \(base): 0 ", terminator: "")

  for n in 1..<10 {
    vanDerCorput(n: n, base: base, num: &num, denom: &denom)

    print("\(num)/\(denom) ", terminator: "")
  }

  print()
}
