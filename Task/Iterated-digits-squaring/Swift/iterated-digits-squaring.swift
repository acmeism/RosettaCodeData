import BigInt

func is89(_ n: Int) -> Bool {
  var n = n

  while true {
    var s = 0

    repeat {
      s += (n%10) * (n%10)
      n /= 10
    } while n > 0

    if s == 89 {
      return true
    } else if s == 1 {
      return false
    }

    n = s
  }
}

func iterSquare(upToPower pow: Int) {
  var sums = [BigInt](repeating: 0, count: pow * 81 + 1)
  sums[0] = 1

  for n in 1...pow {
    var i = n * 81

    while i > 0 {
      for j in 1..<10 {
        let s = j * j
        guard s <= i else { break }
        sums[i] += sums[i-s]
      }

      i -= 1
    }

    var count89 = BigInt(0)

    for x in 1..<n*81 + 1 {
      guard is89(x) else { continue }

      count89 += sums[x]
    }

    print("1->10^\(n): \(count89)")
  }
}

iterSquare(upToPower: 8)
