import math

fn main() {
	mut n, mut count := 0, 0
	for count < 10 {
		n++
		f := math.factoriali(n)
		if is_prime(f - 1) {
		   count++
		   println("${count}: ${n}! - 1 = ${f - 1}")
		}
		if is_prime(f + 1) {
		   count++
		   println("${count}: ${n}! + 1 = ${f + 1}")
		}
	}
}

fn is_prime(num i64) bool {
     if num <= 1 {return false}
     if num % 2 == 0 && num != 2 {return false}
	 for idx := 3; idx <= math.floor(num / 2) - 1; idx += 2 {
         if num % idx == 0 {return false}
     }
     return true
}
