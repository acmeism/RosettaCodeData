import BigInt

func partitions(n: Int) -> BigInt {
  var p = [BigInt(1)]

  for i in 1...n {
    var num = BigInt(0)
    var k = 1

    while true {
      var j = (k * (3 * k - 1)) / 2

      if j > i {
        break
      }

      if k & 1 == 1 {
        num += p[i - j]
      } else {
        num -= p[i - j]
      }

      j += k

      if j > i {
        break
      }

      if k & 1 == 1 {
        num += p[i - j]
      } else {
        num -= p[i - j]
      }

      k += 1
    }

    p.append(num)
  }

  return p[n]
}

print("partitions(6666) = \(partitions(n: 6666))")
