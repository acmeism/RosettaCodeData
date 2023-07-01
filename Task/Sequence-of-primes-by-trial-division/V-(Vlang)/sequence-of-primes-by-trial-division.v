import math

fn main() {
	for idx in 1..101 {if is_prime(idx) {println("${idx}")}}
}

fn is_prime(num int) bool {
	if num < 2 {return false}
	if num < 4 {return true}
	if num % 2 == 0 {return false}
	for idx := 3; idx <= math.sqrt(num); idx += 2 {
		if num % idx == 0 {return false}
	}	
	return true
}
