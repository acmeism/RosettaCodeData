package main

import (
	"fmt"
	"math"
	"strconv"
	"strings"
)

func riceEncode(n int, k int, extended bool) string {
	if extended {
		if n < 0 {
			n = -2*n - 1
		} else {
			n = 2 * n
		}
	}
	
	if n < 0 {
		panic("n must be non-negative")
	}
	
	m := int(math.Pow(2, float64(k)))
	q := n / m
	r := n % m
	
	// Create q ones
	ones := strings.Repeat("1", q)
	
	// Format r as binary with k+1 bits
	rBinary := fmt.Sprintf("%0*b", k+1, r)
	
	return ones + rBinary
}

func riceDecode(a string, k int, extended bool) int {
	m := int(math.Pow(2, float64(k)))
	
	// Find the first '0'
	q := strings.Index(a, "0")
	
	// Parse the remainder
	r, err := strconv.ParseInt(a[q:], 2, 64)
	if err != nil {
		panic(err)
	}
	
	i := q*m + int(r)
	
	if extended {
		if i%2 != 0 {
			i = -(i + 1) / 2
		} else {
			i = i / 2
		}
	}
	
	return i
}

func main() {
	fmt.Println("Base Rice Coding:")
	for n := 0; n <= 10; n++ {
		s := riceEncode(n, 2, false)
		fmt.Printf("%d -> %s -> %d\n", n, s, riceDecode(s, 2, false))
	}
	
	fmt.Println("Extended Rice Coding:")
	for n := -10; n <= 10; n++ {
		s := riceEncode(n, 2, true)
		fmt.Printf("%d -> %s -> %d\n", n, s, riceDecode(s, 2, true))
	}
}
