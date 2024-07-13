package main

import (
	"fmt"
	"math/big"
)

func main() {
	n, count := 0, 0

	for count < 10 {
		n++
		f := factorial(n)

		if isPrime(f.Sub(f, big.NewInt(1))) {
			count++
			fmt.Printf("%2d: %2d! - 1 = %s\n", count, n, f.String())
		}

		if isPrime(f.Add(f, big.NewInt(2))) {
			count++
			fmt.Printf("%2d: %2d! + 1 = %s\n", count, n, f.String())
		}
	}
}

func factorial(n int) *big.Int {
	result := big.NewInt(1)

	for i := 2; i <= n; i++ {
		result.Mul(result, big.NewInt(int64(i)))
	}

	return result
}

func isPrime(num *big.Int) bool {
	if num.Cmp(big.NewInt(2)) < 0 {
		return false
	}

	if num.Cmp(big.NewInt(2)) == 0 {
		return true
	}

	if new(big.Int).Mod(num, big.NewInt(2)).Cmp(big.NewInt(0)) == 0 {
		return false
	}

	sqrt := new(big.Int).Sqrt(num)

	for i := big.NewInt(3); i.Cmp(sqrt) <= 0; i.Add(i, big.NewInt(2)) {
		if new(big.Int).Mod(num, i).Cmp(big.NewInt(0)) == 0 {
			return false
		}
	}

	return true
}
