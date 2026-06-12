package main

import (
	"fmt"
	"math"
	"sort"
	"strconv"
	"strings"
)

// Returns the smallest value for `a` of the Erdős-Woods number n, or math.Inf(1) if n is not in the sequence
func erdősWoods(n int) float64 {
	primes := []int{}
	P, k := 1, 1
	for k < n {
		if P%k != 0 {
			primes = append(primes, k)
		}
		P *= k * k
		k++
	}

	divs := make([]int, n)
	for a := 0; a < n; a++ {
		bits := []string{}
		for _, p := range primes {
			if a%p == 0 {
				bits = append(bits, "1")
			} else {
				bits = append(bits, "0")
			}
		}
		// Reverse the bits and convert to binary
		revBits := reverseString(strings.Join(bits, ""))
		val, _ := strconv.ParseInt(revBits, 2, 64)
		divs[a] = int(val)
	}

	np := len(primes)
	partitions := []partition{
		{0, 0, (1 << np) - 1},
	}

	// Create a sorted slice of indices based on the custom key
	indices := make([]int, n-1)
	for i := 1; i < n; i++ {
		indices[i-1] = i
	}
	sort.Slice(indices, func(i, j int) bool {
		a := indices[i]
		b := indices[j]
		aBits := strconv.FormatInt(int64(divs[a]|divs[n-a]), 2)
		bBits := strconv.FormatInt(int64(divs[b]|divs[n-b]), 2)
		aPos := strings.LastIndex(aBits, "1")
		bPos := strings.LastIndex(bBits, "1")
		return aPos > bPos
	})

	for _, i := range indices {
		newPartitions := []partition{}
		factors := divs[i]
		otherFactors := divs[n-i]

		for _, p := range partitions {
			setA, setB, rPrimes := p.setA, p.setB, p.rPrimes
			if (factors&setA != 0) || (otherFactors&setB != 0) {
				newPartitions = append(newPartitions, p)
				continue
			}

			// Process factors & r_primes
			factorsBits := strconv.FormatInt(int64(factors&rPrimes), 2)
			for ix, v := range reverseString(factorsBits) {
				if v == '1' {
					w := 1 << ix
					newPartitions = append(newPartitions, partition{setA ^ w, setB, rPrimes ^ w})
				}
			}

			// Process other_factors & r_primes
			otherBits := strconv.FormatInt(int64(otherFactors&rPrimes), 2)
			for ix, v := range reverseString(otherBits) {
				if v == '1' {
					w := 1 << ix
					newPartitions = append(newPartitions, partition{setA, setB ^ w, rPrimes ^ w})
				}
			}
		}
		partitions = newPartitions
	}

	result := math.Inf(1)
	for _, p := range partitions {
		px, py := p.setA, p.setB
		x, y := 1, 1
		for _, p := range primes {
			if px&1 != 0 {
				x *= p
			}
			if py&1 != 0 {
				y *= p
			}
			px >>= 1
			py >>= 1
		}
		// Calculate modular inverse and the result
		inv := modInverse(x, y)
		val := float64((n*inv)%y*x - n)
		if val < result {
			result = val
		}
	}
	return result
}

type partition struct {
	setA, setB, rPrimes int
}

// Helper function to reverse a string
func reverseString(s string) string {
	runes := []rune(s)
	for i, j := 0, len(runes)-1; i < j; i, j = i+1, j-1 {
		runes[i], runes[j] = runes[j], runes[i]
	}
	return string(runes)
}

// Helper function for modular inverse
func modInverse(a, m int) int {
	a = a % m
	for x := 1; x < m; x++ {
		if (a*x)%m == 1 {
			return x
		}
	}
	return 1
}

func main() {
	K := 3
	COUNT := 0
	fmt.Println("The first 20 Erdős--Woods numbers and their minimum interval start values are:")
	for COUNT < 20 {
		a := erdősWoods(K)
		if a != math.Inf(1) {
			fmt.Printf("%3d -> %.0f\n", K, a)
			COUNT++
		}
		K++
	}
}
