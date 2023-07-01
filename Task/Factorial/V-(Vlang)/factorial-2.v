const max_size = 10

fn factorial_r(n int) int {
  if n == 0 {
    return 1
  }
  return n * factorial_r(n - 1)
}

fn main() {
  for i := 0; i <= max_size; i++ {
    println('factorial($i) is: ${factorial_r(i)}')
  }
}
