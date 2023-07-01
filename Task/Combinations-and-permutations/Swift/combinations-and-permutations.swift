import BigInt

func permutations(n: Int, k: Int) -> BigInt {
  let l = n - k + 1

  guard l <= n else {
    return 1
  }

  return (l...n).reduce(BigInt(1), { $0 * BigInt($1) })
}

func combinations(n: Int, k: Int) -> BigInt {
  let fact = {() -> BigInt in
    guard k > 1 else {
      return 1
    }

    return (2...k).map({ BigInt($0) }).reduce(1, *)
  }()

  return permutations(n: n, k: k) / fact
}

print("Sample of permutations from 1 to 12")

for i in 1...12 {
  print("\(i) P \(i / 3) = \(permutations(n: i, k: i / 3))")
}

print("\nSample of combinations from 10 to 60")

for i in stride(from: 10, through: 60, by: 10) {
  print("\(i) C \(i / 3) = \(combinations(n: i, k: i / 3))")
}

print("\nSample of permutations from 5 to 15,000")

for i in [5, 50, 500, 1000, 5000, 15000] {
  let k = i / 3
  let res = permutations(n: i, k: k).description
  let extra = res.count > 40 ? "... (\(res.count - 40) more digits)" : ""

  print("\(i) P \(k) = \(res.prefix(40))\(extra)")
}

print("\nSample of combinations from 100 to 1000")

for i in stride(from: 100, through: 1000, by: 100) {
  let k = i / 3
  let res = combinations(n: i, k: k).description
  let extra = res.count > 40 ? "... (\(res.count - 40) more digits)" : ""

  print("\(i) C \(k) = \(res.prefix(40))\(extra)")
}
