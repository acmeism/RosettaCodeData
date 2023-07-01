package main

import (
	"fmt"
	"strings"
)

func main() {
	p, tests, swaps := Solution()
	fmt.Println(p)
	fmt.Println("Tested", tests, "positions and did", swaps, "swaps.")
}

// Holes A=0, B=1, …, H=7
// With connections:
const conn = `
       A   B
      /|\ /|\
     / | X | \
    /  |/ \|  \
   C - D - E - F
    \  |\ /|  /
     \ | X | /
      \|/ \|/
       G   H`

var connections = []struct{ a, b int }{
	{0, 2}, {0, 3}, {0, 4}, // A to C,D,E
	{1, 3}, {1, 4}, {1, 5}, // B to D,E,F
	{6, 2}, {6, 3}, {6, 4}, // G to C,D,E
	{7, 3}, {7, 4}, {7, 5}, // H to D,E,F
	{2, 3}, {3, 4}, {4, 5}, // C-D, D-E, E-F
}

type pegs [8]int

// Valid checks if the pegs are a valid solution.
// If the absolute difference between any pair of connected pegs is
// greater than one it is a valid solution.
func (p *pegs) Valid() bool {
	for _, c := range connections {
		if absdiff(p[c.a], p[c.b]) <= 1 {
			return false
		}
	}
	return true
}

// Solution is a simple recursive brute force solver,
// it stops at the first found solution.
// It returns the solution, the number of positions tested,
// and the number of pegs swapped.
func Solution() (p *pegs, tests, swaps int) {
	var recurse func(int) bool
	recurse = func(i int) bool {
		if i >= len(p)-1 {
			tests++
			return p.Valid()
		}
		// Try each remain peg from p[i:] in p[i]
		for j := i; j < len(p); j++ {
			swaps++
			p[i], p[j] = p[j], p[i]
			if recurse(i + 1) {
				return true
			}
			p[i], p[j] = p[j], p[i]
		}
		return false
	}
	p = &pegs{1, 2, 3, 4, 5, 6, 7, 8}
	recurse(0)
	return
}

func (p *pegs) String() string {
	return strings.Map(func(r rune) rune {
		if 'A' <= r && r <= 'H' {
			return rune(p[r-'A'] + '0')
		}
		return r
	}, conn)
}

func absdiff(a, b int) int {
	if a > b {
		return a - b
	}
	return b - a
}
