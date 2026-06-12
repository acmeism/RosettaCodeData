fn is_prime(n int) bool {
    if n < 2 {return false}
	else if n % 2 == 0 {return n == 2}
	else if n % 3 == 0 {return n == 3}
	else {
        mut d := 5
        for d * d <= n {
            if n % d == 0 {return false}
            d += 2
            if n%d == 0 {return false}
            d += 4
        }
        return true
    }
}

fn main() {
	mut count := 0
	println("Cousin prime pairs whose elements are less than 1,000:")
	for i := 3; i <= 995; i += 2 {
		if is_prime(i) && is_prime(i + 4) == true {
			print("${i:3}:${i + 4:3}  ")
			count++
			if count % 7 == 0 {println("")}
			if i != 3 {i += 4}
			else {i += 2}
		}
	}
	print("\n\n${count} pairs found\n")
}
