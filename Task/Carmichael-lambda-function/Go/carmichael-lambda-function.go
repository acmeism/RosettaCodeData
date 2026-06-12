package main

import (
	"fmt"
	"math"
)

// PrimePower represents a prime number and its power
type PrimePower struct {
	prime int
	power int
}

func main() {
	fmt.Println(" n   carmichael(n) iterations(n)")
	fmt.Println("--------------------------------")
	for i := 1; i <= 25; i++ {
		fmt.Printf("%2d%10d%14d\n", i, carmichaelLambda(i), countIterationsToOne(i))
	}
	fmt.Println()

	fmt.Println("Iterations to 1     n     lambda(n)")
	fmt.Println("-----------------------------------")
	n := 1
	for i := 0; i <= 15; i++ {
		for countIterationsToOne(n) != i {
			n++
		}
		fmt.Printf("%2d%19d%13d\n", i, n, carmichaelLambda(n))
	}
}

func countIterationsToOne(n int) int {
	if n <= 1 {
		return 0
	}
	return countIterationsToOne(carmichaelLambda(n)) + 1
}

func carmichaelLambda(number int) int {
	if number == 1 {
		return 1
	}

	powers := primePowers(number)
	result := 1

	for _, primePower := range powers {
		car := (primePower.prime - 1) * int(math.Pow(float64(primePower.prime), float64(primePower.power-1)))
		if primePower.prime == 2 && primePower.power >= 3 {
			car /= 2
		}
		result = lcm(result, car)
	}

	return result
}

func primePowers(number int) []PrimePower {
	var powers []PrimePower

	for i := 2; i <= int(math.Sqrt(float64(number))); i++ {
		if number%i == 0 {
			powers = append(powers, PrimePower{i, 0})
			for number%i == 0 {
				// Update the last element's power
				powers[len(powers)-1].power++
				number /= i
			}
		}
	}

	if number > 1 {
		powers = append(powers, PrimePower{number, 1})
	}

	return powers
}

func lcm(a, b int) int {
	return a / gcd(a, b) * b
}

func gcd(a, b int) int {
	if b == 0 {
		return a
	}
	return gcd(b, a%b)
}
