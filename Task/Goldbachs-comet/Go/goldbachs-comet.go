package main

import (
	"fmt"
	"math"
)

var primes []bool

func initialisePrimes(limit int) {
	primes = make([]bool, limit)
	for i := 2; i < limit; i++ {
		primes[i] = true
	}

	sqrtLimit := int(math.Sqrt(float64(limit)))
	for n := 2; n < sqrtLimit; n++ {
		if primes[n] {
			for k := n * n; k < limit; k += n {
				primes[k] = false
			}
		}
	}
}

func goldbachFunction(number int) (int, error) {
	if number <= 2 || number%2 == 1 {
		return 0, fmt.Errorf("argument must be even and greater than 2: %d", number)
	}

	result := 0
	for i := 1; i <= number/2; i++ {
		if primes[i] && primes[number-i] {
			result++
		}
	}
	return result, nil
}

func main() {
	initialisePrimes(2000000)

	fmt.Println("The first 100 Goldbach numbers:")
	for n := 2; n < 102; n++ {
		value, err := goldbachFunction(2 * n)
		if err != nil {
			fmt.Printf("Error: %v\n", err)
			continue
		}
		fmt.Printf("%3d", value)
		if n%10 == 1 {
			fmt.Println()
		}
	}

	fmt.Println("\nThe 1,000,000th Goldbach number =", func() string {
		value, err := goldbachFunction(1000000)
		if err != nil {
			return fmt.Sprintf("Error: %v", err)
		}
		return fmt.Sprintf("%d", value)
	}())
}
