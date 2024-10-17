package main

import "core:fmt"

main :: proc() {
	const_max :: 120
	fmt.println("\nAttractive numbers up to and including", const_max, "are: ")
	count := 0
	for i in 1 ..= const_max {
		n := countPrimeFactors(i)
		if isPrime(n) {
			fmt.print(i, " ")
			count += 1
			if count % 20 == 0 {
				fmt.println()
			}
		}
	}
	fmt.println()
}
/* definitions */
isPrime :: proc(n: int) -> bool {
	switch {
	case n < 2:
		return false
	case n % 2 == 0:
		return n == 2
	case n % 3 == 0:
		return n == 3
	case:
		d := 5
		for d * d <= n {
			if n % d == 0 {
				return false
			}
			d += 2
			if n % d == 0 {
				return false
			}
			d += 4
		}
		return true
	}
}
countPrimeFactors :: proc(n: int) -> int {
	n := n
	switch {
	case n == 1:
		return 0
	case isPrime(n):
		return 1
	case:
		count, f := 0, 2
		for {
			if n % f == 0 {
				count += 1
				n /= f
				if n == 1 {
					return count
				}
				if isPrime(n) {
					f = n
				}
			} else if f >= 3 {
				f += 2
			} else {
				f = 3
			}
		}
		return count
	}
}
