package main

import (
	"fmt"
	"math"
	"strconv"
	"strings"
)

// PAdicSquareRoot represents a p-adic square root number
type PAdicSquareRoot struct {
	prime     int64
	precision int
	digits    []int64
	order     int
}

const orderMax = 1000

// NewPAdicSquareRoot creates a p-adic square root number from a rational number
func NewPAdicSquareRoot(prime int64, precision int, numerator int64, denominator int64) (*PAdicSquareRoot, error) {
	if denominator == 0 {
		return nil, fmt.Errorf("denominator cannot be zero")
	}

	digitsSize := precision + 5
	order := 0

	// Process rational zero
	if numerator == 0 {
		return &PAdicSquareRoot{
			prime:     prime,
			precision: precision,
			digits:    make([]int64, digitsSize),
			order:     orderMax,
		}, nil
	}

	// Remove multiples of 'prime' and adjust the order accordingly
	for modulo(numerator, prime) == 0 {
		numerator /= prime
		order++
	}

	for modulo(denominator, prime) == 0 {
		denominator /= prime
		order--
	}

	if (order & 1) != 0 {
		return nil, fmt.Errorf("number does not have a square root in %d-adic", prime)
	}
	order >>= 1

	result := &PAdicSquareRoot{
		prime:     prime,
		precision: precision,
		digits:    []int64{},
		order:     order,
	}

	var err error
	if prime == 2 {
		err = result.squareRootEvenPrime(numerator, denominator)
	} else {
		err = result.squareRootOddPrime(numerator, denominator)
	}

	if err != nil {
		return nil, err
	}

	// Ensure we have the right number of digits
	for len(result.digits) < digitsSize {
		result.digits = append(result.digits, 0)
	}
	if len(result.digits) > digitsSize {
		result.digits = result.digits[:digitsSize]
	}

	return result, nil
}

// Clone returns a copy of the PAdicSquareRoot
func (p *PAdicSquareRoot) Clone() *PAdicSquareRoot {
	digitsCopy := make([]int64, len(p.digits))
	copy(digitsCopy, p.digits)
	
	return &PAdicSquareRoot{
		prime:     p.prime,
		precision: p.precision,
		digits:    digitsCopy,
		order:     p.order,
	}
}

// Negate returns the additive inverse of this p-adic square root number
func (p *PAdicSquareRoot) Negate() *PAdicSquareRoot {
	if len(p.digits) == 0 {
		return p.Clone()
	}

	result := p.Clone()
	negateDigits(result.digits, p.prime)
	return result
}

// Multiply returns the product of this p-adic square root number and another
func (p *PAdicSquareRoot) Multiply(other *PAdicSquareRoot) (*PAdicSquareRoot, error) {
	if p.prime != other.prime {
		return nil, fmt.Errorf("cannot multiply p-adic's with different primes")
	}

	if len(p.digits) == 0 || len(other.digits) == 0 {
		return NewPAdicSquareRoot(p.prime, p.precision, 0, 1)
	}

	digitsSize := p.precision + 5
	product := multiplyDigits(p.digits, other.digits, p.prime, digitsSize)

	return &PAdicSquareRoot{
		prime:     p.prime,
		precision: p.precision,
		digits:    product,
		order:     p.order + other.order,
	}, nil
}

// ConvertToRational returns a string representation of this p-adic square root as a rational number
func (p *PAdicSquareRoot) ConvertToRational() (string, error) {
	if len(p.digits) == 0 {
		return "0 / 1", nil
	}

	// Lagrange lattice basis reduction in two dimensions
	seriesSum := p.digits[0]
	maximumPrime := int64(1)

	for i := 1; i < p.precision; i++ {
		maximumPrime *= p.prime
		seriesSum += p.digits[i] * maximumPrime
	}

	one := []int64{maximumPrime, seriesSum}
	two := []int64{0, 1}

	previousNorm := seriesSum*seriesSum + 1
	currentNorm := previousNorm + 1
	i := 0
	j := 1

	for previousNorm < currentNorm {
		numerator := one[i]*one[j] + two[i]*two[j]
		denominator := previousNorm
		currentNorm = int64(math.Floor(float64(numerator)/float64(denominator) + 0.5))
		one[i] -= currentNorm * one[j]
		two[i] -= currentNorm * two[j]

		currentNorm = previousNorm
		previousNorm = one[i]*one[i] + two[i]*two[i]

		if previousNorm < currentNorm {
			one[i], one[j] = one[j], one[i]
			two[i], two[j] = two[j], two[i]
		}
	}

	x := one[j]
	y := two[j]
	if y < 0 {
		y = -y
		x = -x
	}

	if math.Abs(float64(one[i]*y-x*two[i])) != float64(maximumPrime) {
		return "", fmt.Errorf("rational reconstruction failed")
	}

	for k := p.order; k < 0; k++ {
		y *= p.prime
	}

	for k := 0; k < p.order; k++ {
		x *= p.prime
	}

	return fmt.Sprintf("%d / %d", x, y), nil
}

// String returns a string representation of this p-adic square root
func (p *PAdicSquareRoot) String() string {
	digits := make([]int64, len(p.digits))
	copy(digits, p.digits)

	// Pad with zeros if needed
	for len(digits) < p.precision+5 {
		digits = append(digits, 0)
	}

	var result strings.Builder
	for i := len(digits) - 1; i >= 0; i-- {
		result.WriteString(strconv.FormatInt(digits[i], 10))
	}

	resultStr := result.String()
	
	if p.order >= 0 {
		for i := 0; i < p.order; i++ {
			resultStr += "0"
		}
		resultStr += ".0"
	} else {
		insertPos := len(resultStr) + p.order
		if insertPos >= 0 {
			resultStr = resultStr[:insertPos] + "." + resultStr[insertPos:]
		} else {
			// If we need to insert before the start, pad with zeros
			zerosNeeded := -insertPos
			resultStr = "0." + strings.Repeat("0", zerosNeeded) + resultStr
		}

		// Remove trailing zeros
		for strings.HasSuffix(resultStr, "0") {
			resultStr = resultStr[:len(resultStr)-1]
		}
	}

	// Return with ellipsis at the beginning
	startPos := 0
	if len(resultStr) > p.precision+1 {
		startPos = len(resultStr) - p.precision - 1
	}
	return " ..." + resultStr[startPos:]
}

// squareRootEvenPrime creates a 2-adic number which is the square root of the rational numerator/denominator
func (p *PAdicSquareRoot) squareRootEvenPrime(numerator, denominator int64) error {
	if modulo(numerator*denominator, 8) != 1 {
		return fmt.Errorf("number does not have a square root in 2-adic")
	}

	// First digit
	sum := int64(1)
	p.digits = append(p.digits, 1)

	// Further digits
	digitsSize := p.precision + 5
	for len(p.digits) < digitsSize {
		factor := denominator*sum*sum - numerator
		valuation := 0
		factorTemp := factor
		for modulo(factorTemp, 2) == 0 {
			factorTemp /= 2
			valuation++
		}

		sum += int64(math.Pow(2, float64(valuation-1)))

		for len(p.digits) < valuation-1 {
			p.digits = append(p.digits, 0)
		}
		p.digits = append(p.digits, 1)
	}

	return nil
}

// squareRootOddPrime creates a p-adic number, with an odd prime number, which is the p-adic square root
func (p *PAdicSquareRoot) squareRootOddPrime(numerator, denominator int64) error {
	// First digit
	firstDigit := int64(0)
	for i := int64(1); i < p.prime && firstDigit == 0; i++ {
		if modulo(denominator*i*i-numerator, p.prime) == 0 {
			firstDigit = i
		}
	}

	if firstDigit == 0 {
		return fmt.Errorf("number does not have a square root in %d-adic", p.prime)
	}

	p.digits = append(p.digits, firstDigit)

	// Further digits
	coefficient := moduloInverse(modulo(2*denominator*firstDigit, p.prime), p.prime)
	sum := firstDigit
	digitsSize := p.precision + 5

	for i := 2; i < digitsSize; i++ {
		nextSum := sum - int64(coefficient)*(denominator*sum*sum-numerator)
		nextSum = modulo(nextSum, int64(math.Pow(float64(p.prime), float64(i))))
		nextSum -= sum
		sum += nextSum

		digit := nextSum / int64(math.Pow(float64(p.prime), float64(i-1)))
		p.digits = append(p.digits, digit)
	}

	return nil
}

// negateDigits transforms the given vector of digits representing a p-adic number
// into a vector which represents the negation of the p-adic number
func negateDigits(numbers []int64, prime int64) {
	if len(numbers) > 0 {
		numbers[0] = modulo(prime-numbers[0], prime)
		for i := 1; i < len(numbers); i++ {
			numbers[i] = prime - 1 - numbers[i]
		}
	}
}

// multiplyDigits returns the list obtained by multiplying the digits of the given two lists
func multiplyDigits(one, two []int64, prime int64, maxSize int) []int64 {
	product := make([]int64, len(one)+len(two))

	for b := 0; b < len(two); b++ {
		carry := int64(0)
		for a := 0; a < len(one); a++ {
			product[a+b] += one[a]*two[b] + carry
			carry = product[a+b] / prime
			product[a+b] %= prime
		}
		if b+len(one) < len(product) {
			product[b+len(one)] = carry
		}
	}

	// Truncate to maxSize
	if len(product) > maxSize {
		product = product[:maxSize]
	}
	return product
}

// moduloInverse returns the multiplicative inverse of the given number modulo 'prime'
func moduloInverse(number, prime int64) int64 {
	inverse := int64(1)
	for modulo(inverse*number, prime) != 1 {
		inverse++
	}
	return inverse
}

// modulo returns the given number modulo 'prime' in the range 0..'prime' - 1
func modulo(number, modulus int64) int64 {
	div := number % modulus
	if div >= 0 {
		return div
	}
	return div + modulus
}

func main() {
	tests := [][]int64{
		{2, 20, 497, 10496},
		{5, 14, 86, 25},
		{7, 10, -19, 1},
	}

	for _, test := range tests {
		fmt.Printf("Number: %d / %d in %d-adic\n", test[2], test[3], test[0])

		squareRoot, err := NewPAdicSquareRoot(test[0], int(test[1]), test[2], test[3])
		if err != nil {
			fmt.Printf("Error: %v\n\n", err)
			continue
		}

		fmt.Println("The two square roots are:")
		fmt.Printf("    %s\n", squareRoot.String())
		fmt.Printf("    %s\n", squareRoot.Negate().String())

		square, err := squareRoot.Multiply(squareRoot)
		if err != nil {
			fmt.Printf("Error calculating square: %v\n\n", err)
			continue
		}

		fmt.Printf("The p-adic value is %s\n", square.String())
		rational, err := square.ConvertToRational()
		if err != nil {
			fmt.Printf("Error converting to rational: %v\n\n", err)
			continue
		}
		fmt.Printf("The rational value is %s\n\n", rational)
	}
}
