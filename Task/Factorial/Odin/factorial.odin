package main

factorial :: proc(n: int) -> int {
  return 1 if n == 0 else n * factorial(n - 1)
}

factorial_iterative :: proc(n: int) -> int {
  result := 1
  for i in 2..=n do result *= i
  return result
}

main :: proc() {
  assert(factorial(4) == 24)
  assert(factorial_iterative(4) == 24)
}
