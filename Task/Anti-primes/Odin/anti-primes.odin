package antiprimes
import "core:fmt"

main :: proc() {
	AntiPrimeCount, MaxDivisors, Divisors, n: u64
	MaxAntiPrime: u64 = 20
	fmt.print("\nFirst 20 anti-primes\n")
	fmt.println("--------------------")
	for (AntiPrimeCount < MaxAntiPrime) {
		n += 1
		Divisors = DivisorCount(n)
		if Divisors > MaxDivisors {
			fmt.print(n, " ")
			MaxDivisors = Divisors
			AntiPrimeCount += 1
		}
	}
}

DivisorCount :: proc(v: u64) -> u64 {
	total: u64 = 1
	a := v
	if a == 0 {
		return 0
	}
	for a % 2 == 0 {
		total += 1
		a /= 2
	}
	for p: u64 = 3; p * p <= a; p += 2 {
		count: u64 = 1
		for a % p == 0 {
			count += 1
			a /= p
		}
		total *= count
	}
	if a > 1 {
		total *= 2
	}
	return total
}
