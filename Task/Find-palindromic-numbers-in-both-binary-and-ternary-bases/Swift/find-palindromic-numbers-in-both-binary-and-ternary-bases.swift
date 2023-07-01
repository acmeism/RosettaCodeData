import Foundation

func isPalin2(n: Int) -> Bool {
  var x = 0
  var n = n

  guard n & 1 != 0 else {
    return n == 0
  }

  while x < n {
    x = x << 1 | n & 1
    n >>= 1
  }

  return n == x || n == x >> 1
}

func reverse3(n: Int) -> Int {
  var x = 0
  var n = n

  while n > 0 {
    x = x * 3 + (n % 3)
    n /= 3
  }

  return x
}

func printN(_ n: Int, base: Int) {
  var n = n

  print(" ", terminator: "")

  repeat {
    print("\(n % base)", terminator: "")

    n /= base
  } while n > 0

  print("(\(base))", terminator: "")
}

func show(n: Int) {
  print(n, terminator: "")
  printN(n, base: 2)
  printN(n, base: 3)
  print()
}

private var count = 0
private var lo = 0
private var (hi, pow2, pow3) = (1, 1, 1)

show(n: 0)

while true {
  var n: Int

  for i in lo..<hi {
    n = (i * 3 + 1) * pow3 + reverse3(n: i)

    guard isPalin2(n: n) else {
      continue
    }

    show(n: n)
    count += 1

    guard count < 7 else {
      exit(0)
    }
  }

  if hi == pow3 {
    pow3 *= 3
  } else {
    pow2 *= 4
  }

  while true {
    while pow2 <= pow3 {
      pow2 *= 4
    }

    let lo2 = (pow2 / pow3 - 1) / 3
    let hi2 = (pow2 * 2 / pow3 - 1) / 3 + 1
    let lo3 = pow3 / 3
    let hi3 = pow3

    if lo2 >= hi3 {
      pow3 *= 3
    } else if lo3 >= hi2 {
      pow2 *= 4
    } else {
      lo = max(lo2, lo3)
      hi = min(hi2, hi3)
      break
    }
  }
}
