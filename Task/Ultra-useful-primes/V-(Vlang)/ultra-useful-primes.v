import math

fn main() {
	limit := 10 // depending on computer, higher numbers = longer times
	mut num, mut k := i64(0), i64(0)
	println("n   k\n-------")
	for n in 1..limit {
		k = -1
		for n < limit {
			  k = k + 2
			  num = math.powi(2, math.powi(2 , n)) - k
			  if is_prime(num) == true {
				 println("${n}   ${k}")
				 break
			  }
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
