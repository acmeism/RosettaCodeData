import Foundation

func jacobi(a: Int, n: Int) -> Int {
  var a = a % n
  var n = n
  var res = 1

  while a != 0 {
    while a & 1 == 0 {
      a >>= 1

      if n % 8 == 3 || n % 8 == 5 {
        res = -res
      }
    }

    (a, n) = (n, a)

    if a % 4 == 3 && n % 4 == 3 {
      res = -res
    }

    a %= n
  }

  return n == 1 ? res : 0
}

print("n/a  0  1  2  3  4  5  6  7  8  9")
print("---------------------------------")

for n in stride(from: 1, through: 17, by: 2) {
  print(String(format: "%2d", n), terminator: "")

  for a in 0..<10 {
    print(String(format: " % d", jacobi(a: a, n: n)), terminator: "")
  }

  print()
}
