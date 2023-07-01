const max_size = 10

fn factorial_tail(n int) int {
	sum := 1
	return factorial_r(n, sum)
}

fn factorial_r(n int, sum int) int {
  if n == 0 {
    return sum
  }
  return factorial_r(n - 1, n * sum )
}

fn main() {
  for i := 0; i <= max_size; i++ {
    println('factorial($i) is: ${factorial_tail(i)}')
  }
}
