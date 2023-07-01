package main

import (
	"fmt"
	"math"
)

// From http://rosettacode.org/wiki/Entropy#Go
func entropy(s string) float64 {
	m := map[rune]float64{}
	for _, r := range s {
		m[r]++
	}
	hm := 0.
	for _, c := range m {
		hm += c * math.Log2(c)
	}
	l := float64(len(s))
	return math.Log2(l) - hm/l
}

const F_Word1 = "1"
const F_Word2 = "0"

func FibonacciWord(n int) string {
	a, b := F_Word1, F_Word2
	for ; n > 1; n-- {
		a, b = b, b+a
	}
	return a
}

func FibonacciWordGen() <-chan string {
	ch := make(chan string)
	go func() {
		a, b := F_Word1, F_Word2
		for {
			ch <- a
			a, b = b, b+a
		}
	}()
	return ch
}

func main() {
	fibWords := FibonacciWordGen()
	fmt.Printf("%3s %9s  %-18s  %s\n", "N", "Length", "Entropy", "Word")
	n := 1
	for ; n < 10; n++ {
		s := <-fibWords
		// Just to show the function and generator do the same thing:
		if s2 := FibonacciWord(n); s != s2 {
			fmt.Printf("For %d, generator produced %q, function produced %q\n", n, s, s2)
		}
		fmt.Printf("%3d %9d  %.16f  %s\n", n, len(s), entropy(s), s)
	}
	for ; n <= 37; n++ {
		s := <-fibWords
		fmt.Printf("%3d %9d  %.16f\n", n, len(s), entropy(s))
	}
}
