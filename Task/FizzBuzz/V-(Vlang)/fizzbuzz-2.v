fn main() {
	mut i := 1
	for i <= 100 {
		match true {
			i % 15 == 0 { println('FizzBuzz') }
			i % 3 == 0  { println('Fizz') }
			i % 5 == 0  { println('Buzz') }
			else { println(i) }
		}
		i++
	}
}
