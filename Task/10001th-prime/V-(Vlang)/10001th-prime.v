import math

fn nth_prime(n int) int {
	mut count, mut candidate := 0, 1
	for {
		candidate++
		mut is_prime := true
		for i in 2 .. int(math.sqrt(candidate)) + 1 {
			if candidate % i == 0 {
				is_prime = false
				break
			}
		}
		if is_prime {
			count++
			if count == n {
				return candidate
			}
		}
	}
	return -1
}

fn main() {
	println('The 10001st prime is ${nth_prime(10001)}.')
}
