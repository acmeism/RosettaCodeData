fn main() {
	for n := 2; n < 5000; n++ {
		if digit_sum(n) == 25 && is_prime(n) {print("${n}" + " ")}
	}
}

fn digit_sum(pn int) int {
	mut n := pn
	mut sum := (0)
	for n != 0 {
		sum += n % 10
		n /= 10
	}
	return sum
}

fn is_prime(n int) bool {
    if n < 2 {return false}
	else if n % 2 == 0 {return n == 2}
	else if n % 3 == 0 {return n == 3}
	else {
        mut d := 5
        for d * d <= n {
            if n % d == 0 {return false}
            d += 2
            if n % d == 0 {return false}
            d += 4
        }
        return true
    }
}
