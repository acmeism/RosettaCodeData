func F(n: Int) -> Int {
  return n == 0 ? 1 : n - M(F(n-1))
}

func M(n: Int) -> Int {
  return n == 0 ? 0 : n - F(M(n-1))
}

for i in 0..20 {
  print("\(F(i)) ")
}
println()
for i in 0..20 {
  print("\(M(i)) ")
}
println()
