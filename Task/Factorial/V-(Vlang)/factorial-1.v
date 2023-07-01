const max_size = 10

fn factorial_i() {
  mut facs := [0].repeat(max_size + 1)
  facs[0] = 1
  println('The 0-th Factorial number is: 1')
  for i := 1; i <= max_size; i++ {
    facs[i] = i * facs[i - 1]
    num := facs[i]
    println('The $i-th Factorial number is: $num')
  }
}

fn main() {
	factorial_i()
}
