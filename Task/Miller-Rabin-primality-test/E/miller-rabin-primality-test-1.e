def millerRabinPrimalityTest(n :(int > 0), k :int, random) :boolean {
  if (n <=> 2 || n <=> 3) { return true }
  if (n <=> 1 || n %% 2 <=> 0) { return false }
  var d := n - 1
  var s := 0
  while (d %% 2 <=> 0) {
    d //= 2
    s += 1
  }
  for _ in 1..k {
     def nextTrial := __continue
     def a := random.nextInt(n - 3) + 2     # [2, n - 2] = [0, n - 4] + 2 = [0, n - 3) + 2
     var x := a**d %% n                     # Note: Will do optimized modular exponentiation
     if (x <=> 1 || x <=> n - 1) { nextTrial() }
     for _ in 1 .. (s - 1) {
        x := x**2 %% n
        if (x <=> 1) { return false }
        if (x <=> n - 1) { nextTrial() }
     }
     return false
  }
  return true
}
