func catalan(_ n: Int) -> Int {
  switch n {
  case 0:
    return 1
  case _:
    return catalan(n - 1) * 2 * (2 * n - 1) / (n + 1)
  }
}

for i in 1..<16 {
  print("catalan(\(i)) => \(catalan(i))")
}
