func lex(n: Int) -> [Int] {
  return stride(from: 1, through: n, by: n.signum()).map({ String($0) }).sorted().compactMap(Int.init)
}

print("13: \(lex(n: 13))")
print("21: \(lex(n: 21))")
print("-22: \(lex(n: -22))")
