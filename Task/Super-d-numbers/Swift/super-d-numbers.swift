import BigInt
import Foundation

let rd = ["22", "333", "4444", "55555", "666666", "7777777", "88888888", "999999999"]

for d in 2...9 {
  print("First 10 super-\(d) numbers:")

  var count = 0
  var n = BigInt(3)
  var k = BigInt(0)

  while true {
    k = n.power(d)
    k *= BigInt(d)

    if let _ = String(k).range(of: rd[d - 2]) {
      count += 1

      print(n, terminator: " ")
      fflush(stdout)

      guard count < 10 else {
        break
      }
    }

    n += 1
  }

  print()
  print()
}
