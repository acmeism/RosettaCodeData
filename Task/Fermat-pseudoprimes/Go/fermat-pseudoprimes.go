package main

import (
	"fmt"
)

func modpow(base, exp, mod int) int {
	if mod == 1 {
		return 0
	}
	result := 1
	base %= mod
	for ; exp > 0; exp >>= 1 {
		if (exp & 1) == 1 {
			result = (result * base) % mod
		}
		base = (base * base) % mod
	}
	return result
}

func is_prime(n int) bool {
	if n < 2 {
		return false
	}
	if n%2 == 0 {
		return n == 2
	}
	if n%3 == 0 {
		return n == 3
	}
	for p := 5; p*p <= n; p += 2 {
		if n%p == 0 {
			return false
		}
	}
	return true
}

func is_fermat_pseudoprime(a, x int) bool {
	return !is_prime(x) && modpow(a, x-1, x) == 1
}

func main() {
	fmt.Println("First 20 Fermat pseudoprimes")
	for a := 1; a <= 20; a++ {
		fmt.Printf("Base %2d: ", a)
		count := 0
		for x := 4; count < 20; x++ {
			if is_fermat_pseudoprime(a, x) {
				count++
				fmt.Printf("%5d ", x)
			}
		}
		fmt.Println()
	}

	limits := []int{12000, 25000, 50000, 100000}
	fmt.Print("\nCount <= ")
	for _, limit := range limits {
		fmt.Printf("%6d ", limit)
	}
	fmt.Println("\n------------------------------------")
	for a := 1; a <= 20; a++ {
		fmt.Printf("Base %2d: ", a)

		count := 0
		x := 4
		for _, limit := range limits {
			for ; x <= limit; x++ {
				if is_fermat_pseudoprime(a, x) {
					count++
				}
			}
			fmt.Printf("%6d ", count)
		}
		fmt.Println()
	}
}
