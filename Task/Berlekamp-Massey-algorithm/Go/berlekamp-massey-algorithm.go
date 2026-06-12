package main

import (
	"fmt"
	"math"
	"strconv"
	"strings"
)

func main() {
	source := []int{0, 1, 1, 2, 3, 5, 8, 13, 21}
	bm := NewBerlekampMassey(source, 100)
	bmCoeffs := bm.ComputeCoefficients()
	fmt.Printf("Berlekamp-Massey coefficients: %v (lowest to highest degree)\n", bmCoeffs)
	fmt.Printf("The connection polynomial is %s having degree %d\n\n",
		bm.Polynomial(bmCoeffs), len(bmCoeffs)-1)
	
	fmt.Println("Terms indexed 35 to 40 from the Fibonacci sequence modulo 100:")
	// Result can be checked on www.oeis.net, A000045
	indices := []int{35, 36, 37, 38, 39, 40}
	for _, n := range indices {
		fmt.Printf("%d ", bm.ComputeTerm(bmCoeffs, n))
	}
	fmt.Println()
}

type BerlekampMassey struct {
	source  []int
	modulus int
}

func NewBerlekampMassey(source []int, modulus int) *BerlekampMassey {
	// Create a copy of the source slice
	sourceCopy := make([]int, len(source))
	copy(sourceCopy, source)
	
	return &BerlekampMassey{
		source:  sourceCopy,
		modulus: modulus,
	}
}

func (bm *BerlekampMassey) ComputeCoefficients() []int {
	var result []int
	var previousResult []int
	failIndex := -1
	
	for i := 0; i < len(bm.source); i++ {
		delta := bm.source[i]
		for j := 1; j <= len(result); j++ {
			delta -= result[j-1] * bm.source[i-j]
		}
		
		if delta == 0 {
			continue
		}
		
		if failIndex == -1 {
			result = make([]int, i+1)
			failIndex = i
		} else {
			var previousResultCopy []int
			previousResultCopy = append(previousResultCopy, 1)
			for _, term := range previousResult {
				previousResultCopy = append(previousResultCopy, -term)
			}
			
			termFailIndexPlusOne := 0
			for j := 1; j <= len(previousResultCopy); j++ {
				termFailIndexPlusOne += previousResultCopy[j-1] * bm.source[failIndex+1-j]
			}
			
			coeff := delta / termFailIndexPlusOne
			for k := 0; k < len(previousResultCopy); k++ {
				previousResultCopy[k] *= coeff
			}
			
			// Add zeros at the beginning (equivalent to addFirst)
			for k := 0; k < i-failIndex-1; k++ {
				previousResultCopy = append([]int{0}, previousResultCopy...)
			}
			
			resultCopy := make([]int, len(result))
			copy(resultCopy, result)
			
			// Extend result if needed
			for len(result) < len(previousResultCopy) {
				result = append(result, 0)
			}
			
			for j := 0; j < len(previousResultCopy); j++ {
				result[j] += previousResultCopy[j]
			}
			
			if i-len(resultCopy) > failIndex-len(previousResult) {
				previousResult = make([]int, len(resultCopy))
				copy(previousResult, resultCopy)
				failIndex = i
			}
		}
	}
	
	return result
}

func (bm *BerlekampMassey) ComputeTerm(bmCoeffs []int, index int) int {
	if len(bmCoeffs) == 0 {
		return 0
	}
	
	if index < len(bm.source) {
		return (bm.source[index] + bm.modulus) % bm.modulus
	}
	
	var coeffs []int
	coeffs = append(coeffs, bm.modulus-1)
	coeffs = append(coeffs, bmCoeffs...)
	
	bmCoeffsSize := len(bmCoeffs)
	f := make([]int, bmCoeffsSize)
	g := make([]int, bmCoeffsSize)
	
	f[0] = 1
	
	if bmCoeffsSize == 1 {
		g[0] = coeffs[1]
	} else {
		g[1] = 1
	}
	
	power := index - 1
	for power > 0 {
		if (power & 1) == 1 {
			f = bm.polynomialMultiply(f, g, bmCoeffsSize, coeffs)
		}
		g = bm.polynomialMultiply(g, g, bmCoeffsSize, coeffs)
		power >>= 1
	}
	
	result := 0
	for i := 0; i < bmCoeffsSize; i++ {
		if i+1 < len(bm.source) {
			result = (result + bm.source[i+1]*f[i]) % bm.modulus
		}
	}
	
	return (result + bm.modulus) % bm.modulus
}

func (bm *BerlekampMassey) Polynomial(bmCoeffs []int) string {
	degree := len(bmCoeffs) - 1
	if degree == 0 {
		return strconv.Itoa(bmCoeffs[0])
	}
	
	var text strings.Builder
	for i := degree; i >= 0; i-- {
		coeff := bmCoeffs[i]
		if coeff == 0 {
			continue
		}
		
		var sign string
		if coeff < 0 && i == degree {
			sign = "-"
		} else if coeff < 0 {
			sign = " - "
		} else if i < degree {
			sign = " + "
		} else {
			sign = ""
		}
		text.WriteString(sign)
		
		coeffAbs := int(math.Abs(float64(coeff)))
		if coeffAbs > 1 {
			text.WriteString(strconv.Itoa(coeffAbs))
		}
		
		var term string
		if i > 1 {
			term = "x^" + strconv.Itoa(i)
		} else if i == 1 {
			term = "x"
		} else if coeffAbs == 1 {
			term = "1"
		} else {
			term = ""
		}
		text.WriteString(term)
	}
	
	return text.String()
}

func (bm *BerlekampMassey) polynomialMultiply(a, b []int, degree int, coeffs []int) []int {
	result := make([]int, 2*degree)
	
	for i := 0; i < degree; i++ {
		if a[i] == 0 {
			continue
		}
		for j := 0; j < degree; j++ {
			result[i+j] = (result[i+j] + a[i]*b[j]) % bm.modulus
		}
	}
	
	for i := 2*degree - 1; i > degree-1; i-- {
		if result[i] == 0 {
			continue
		}
		term := result[i]
		result[i] = 0
		for j := 0; j <= degree; j++ {
			index := i - j
			if index >= 0 {
				result[index] = (result[index] + term*coeffs[j]) % bm.modulus
			}
		}
	}
	
	return result[:degree]
}
