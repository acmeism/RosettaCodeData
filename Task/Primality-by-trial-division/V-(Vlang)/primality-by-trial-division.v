import math

const numbers = [5, 3, 14, 19, 25, 59, 88]

fn main() {
	for num in numbers {
		println("${num} is a prime number? " + if is_prime(num) == true {'yes'} else {'no'})
	}
}

fn is_prime(num int) bool {
     if num <= 1 {return false}
     if num % 2 == 0 && num != 2 {return false}
	 for idx := 3; idx <= math.floor(num / 2) - 1; idx += 2 {
         if num % idx == 0 {return false}
     }
     return true
}
