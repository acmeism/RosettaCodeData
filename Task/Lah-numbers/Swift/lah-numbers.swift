import BigInt
import Foundation

@inlinable
public func factorial<T: BinaryInteger>(_ n: T) -> T {
  guard n != 0 else {
    return 1
  }

  return stride(from: n, to: 0, by: -1).reduce(1, *)
}

@inlinable
public func lah<T: BinaryInteger>(n: T, k: T) -> T {
  if k == 1 {
    return factorial(n)
  } else if k == n {
    return 1
  } else if k > n {
    return 0
  } else if k < 1 || n < 1 {
    return 0
  } else {
    let a = (factorial(n) * factorial(n - 1))
    let b = (factorial(k) * factorial(k - 1))
    let c = factorial(n - k)

    return a / b / c
  }
}

print("Unsigned Lah numbers: L(n, k):")
print("n\\k", terminator: "")

for i in 0...12 {
  print(String(format: "%10d", i), terminator: " ")
}

print()

for row in 0...12 {
  print(String(format: "%-2d", row), terminator: "")

  for i in 0...row {
    lah(n: BigInt(row), k: BigInt(i)).description.withCString {str in
      print(String(format: "%11s", str), terminator: "")
    }
  }

  print()
}

let maxLah = (0...100).map({ lah(n: BigInt(100), k: BigInt($0)) }).max()!

print("Maximum value from the L(100, *) row: \(maxLah)")
