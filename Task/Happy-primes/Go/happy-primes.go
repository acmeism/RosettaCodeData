package main

import (
	"fmt"
	"math"
)

func isPrime(n int) bool {
	if n <= 1 {
		return false
	}

	for i := 2; i < int(math.Sqrt(float64(n)))+1; i++ {
		if n%i == 0 {
			return false
		}
	}

	return true
}

func isHappy(n int) bool {
	visited := make(map[int]bool)

	for {
		sum := 0

		for n > 0 {
			tmp := math.Pow(float64(n%10), 2)
			sum += int(tmp)
			n /= 10
		}

		if sum == 1 {
			return true
		}

		_, ok := visited[sum]

		if ok {
			break
		}

		visited[sum] = true
		n = sum
	}
	return false
}
func main() {
	happyPrimes := make([]int, 0)
	primeStart := 2

	for len(happyPrimes) < 50 {
		if isPrime(primeStart) && isHappy(primeStart) {
			happyPrimes = append(happyPrimes, primeStart)
		}
		primeStart++
	}

	fmt.Println("The first fifty happy primes:")

	for i := range 50 {
		if i%10 == 0 && i != 0 {
			fmt.Println()
		}
		fmt.Printf("%4d ", happyPrimes[i])
	}

	fmt.Println()

	startNum := 1
	primeCount := 0.0
	happyCount := 0.0
	denominator := 2.0

	fmt.Println()
	fmt.Println("Prime")
	fmt.Println("fraction  Index Value")

	for denominator <= 15 {
		if isHappy(startNum) {
			happyCount++

			if isPrime(startNum) {
				primeCount++
			}

			if primeCount/happyCount <= 1.0/denominator {
				fmt.Printf("1 / %2d %6d %7d\n", int(denominator), int(happyCount), startNum)
				denominator++
			}
		}

		startNum++
	}
}
