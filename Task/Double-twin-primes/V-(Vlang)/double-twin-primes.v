import math

fn main() {
	limit := 1000
	mut parr := []int{}
	for n in 1..limit {
		if is_prime(n) {parr << n}
	}
	for m in 1..parr.len - 3 {
		if is_prime(parr[m]) && is_prime(parr[m + 1]) && is_prime(parr[m + 2]) && is_prime(parr[m + 3]) {
		   if parr[m + 1] - parr[m] == 2 && parr[m + 2] - parr[m + 1] == 4 && parr[m + 3] - parr[m + 2] == 2 {
			  println("${parr[m]} ${parr[m + 1]} ${parr[m + 2]} ${parr[m + 3]}")
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
