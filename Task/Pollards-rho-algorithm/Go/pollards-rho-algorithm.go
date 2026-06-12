package main

import (
	"crypto/rand"
	"fmt"
	"math/big"
	"time"
)

func main() {
	// Create test numbers
	tests := []*big.Int{}
	
	n1, _ := new(big.Int).SetString("4294967213", 10)
	n2, _ := new(big.Int).SetString("9759463979", 10)
	n3, _ := new(big.Int).SetString("34225158206557151", 10)
	n4, _ := new(big.Int).SetString("763218146048580636353", 10)
	n5, _ := new(big.Int).SetString("13", 10)
	
	tests = append(tests, n1, n2, n3, n4, n5)

	// Test each number
	for _, test := range tests {
		divisorOne := pollardsRho(test)
		divisorTwo := new(big.Int).Div(test, divisorOne)
		fmt.Printf("%s = %s * %s\n", test, divisorOne, divisorTwo)
	}
}

func pollardsRho(aNumber *big.Int) *big.Int {
	// Check if even
	if new(big.Int).Mod(aNumber, big.NewInt(2)).Cmp(big.NewInt(0)) == 0 {
		return big.NewInt(2)
	}

	// Generate random numbers in the appropriate range
	bitLength := aNumber.BitLen()
	constant := randomBigInt(bitLength)
	constant.Mod(constant, aNumber)

	x := randomBigInt(bitLength)
	x.Mod(x, aNumber)
	
	y := new(big.Int).Set(x)
	divisor := big.NewInt(1)

	for divisor.Cmp(big.NewInt(1)) == 0 {
		// x = (x*x + constant) % aNumber
		x.Mul(x, x)
		x.Add(x, constant)
		x.Mod(x, aNumber)

		// y = (y*y + constant) % aNumber, applied twice
		y.Mul(y, y)
		y.Add(y, constant)
		y.Mod(y, aNumber)
		y.Mul(y, y)
		y.Add(y, constant)
		y.Mod(y, aNumber)

		// Calculate difference and find GCD
		diff := new(big.Int).Sub(x, y)
		if diff.Sign() < 0 {
			diff.Neg(diff)
		}
		divisor.GCD(nil, nil, diff, aNumber)
	}

	return divisor
}

func randomBigInt(bitLength int) *big.Int {
	// Create a new big.Int with random bits
	max := new(big.Int).Lsh(big.NewInt(1), uint(bitLength))
	n, err := rand.Int(rand.Reader, max)
	if err != nil {
		// Fallback to a simpler method if crypto/rand fails
		r := new(big.Int)
		// This is not cryptographically secure but works as a fallback
		r.SetInt64(time.Now().UnixNano())
		return r.Mod(r, max)
	}
	return n
}
