package main

import (
	"fmt"
	"math/big"
)

func smallest_prime(n int) string {
	if n == 1 {
		return "2"
	}

	num := make([]byte, n)
	for i := 0; i < n; i++ {
		num[i] = '1'
	}

	for {
		if num[n-1] == '1' {
			str := string(num)
			b := new(big.Int)
			b.SetString(str, 10)
			if b.ProbablyPrime(10) {
				return str
			}
		}

		num[n-1]++
		for i := n - 1; i >= 0; i-- {
			if num[i] == '3' {
				num[i] = '1'
				num[i-1]++
			} else {
				break
			}
		}
	}

	return ""
}

func main() {
	for i := 1; i <= 20; i++ {
		fmt.Printf("%4d: %s\n", i, smallest_prime(i))
	}
	for i := 100; i <= 2000; i += 100 {
		prime := smallest_prime(i)
		ones := 0
		for j := 0; j < i; j++ {
			if prime[j] == '2' {
				break
			}
			ones++
		}
		fmt.Printf("%4d: (1 x %4d) %s\n", i, ones, prime[ones:])
	}
}
