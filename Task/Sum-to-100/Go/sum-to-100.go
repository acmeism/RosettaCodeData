package main

import (
	"fmt"
	"sort"
)

const pow3_8 = 3 * 3 * 3 * 3 * 3 * 3 * 3 * 3 // 3^8
const pow3_9 = 3 * pow3_8                    // 3^9
const maxExprs = 2 * pow3_8                  // not 3^9 since first op can't be Join

type op uint8

const (
	Add  op = iota // insert a "+"
	Sub            //     or a "-"
	Join           //     or just join together
)

// code is an encoding of [9]op, the nine "operations"
// we do on each each digit. The op for 1 is in
// the highest bits, the op for 9 in the lowest.
type code uint16

// evaluate 123456789 with + - or "" prepended to each as indicated by `c`.
func (c code) evaluate() (sum int) {
	num, pow := 0, 1
	for k := 9; k >= 1; k-- {
		num += pow * k
		switch op(c % 3) {
		case Add:
			sum += num
			num, pow = 0, 1
		case Sub:
			sum -= num
			num, pow = 0, 1
		case Join:
			pow *= 10
		}
		c /= 3
	}
	return sum
}

func (c code) String() string {
	buf := make([]byte, 0, 18)
	a, b := code(pow3_9), code(pow3_8)
	for k := 1; k <= 9; k++ {
		switch op((c % a) / b) {
		case Add:
			if k > 1 {
				buf = append(buf, '+')
			}
		case Sub:
			buf = append(buf, '-')
		}
		buf = append(buf, '0'+byte(k))
		a, b = b, b/3
	}
	return string(buf)
}

type sumCode struct {
	sum  int
	code code
}
type sumCodes []sumCode

type sumCount struct {
	sum   int
	count int
}
type sumCounts []sumCount

// For sorting (could also use sort.Slice with just Less).
func (p sumCodes) Len() int            { return len(p) }
func (p sumCodes) Swap(i, j int)       { p[i], p[j] = p[j], p[i] }
func (p sumCodes) Less(i, j int) bool  { return p[i].sum < p[j].sum }
func (p sumCounts) Len() int           { return len(p) }
func (p sumCounts) Swap(i, j int)      { p[i], p[j] = p[j], p[i] }
func (p sumCounts) Less(i, j int) bool { return p[i].count > p[j].count }

// For printing.
func (sc sumCode) String() string {
	return fmt.Sprintf("% 10d = %v", sc.sum, sc.code)
}
func (sc sumCount) String() string {
	return fmt.Sprintf("% 10d has %d solutions", sc.sum, sc.count)
}

func main() {
	// Evaluate all expressions.
	expressions := make(sumCodes, 0, maxExprs/2)
	counts := make(sumCounts, 0, 1715)
	for c := code(0); c < maxExprs; c++ {
		// All negative sums are exactly like their positive
		// counterpart with all +/- switched, we don't need to
		// keep track of them.
		sum := c.evaluate()
		if sum >= 0 {
			expressions = append(expressions, sumCode{sum, c})
		}
	}
	sort.Sort(expressions)

	// Count all unique sums
	sc := sumCount{expressions[0].sum, 1}
	for _, e := range expressions[1:] {
		if e.sum == sc.sum {
			sc.count++
		} else {
			counts = append(counts, sc)
			sc = sumCount{e.sum, 1}
		}
	}
	counts = append(counts, sc)
	sort.Sort(counts)

	// Extract required results

	fmt.Println("All solutions that sum to 100:")
	i := sort.Search(len(expressions), func(i int) bool {
		return expressions[i].sum >= 100
	})
	for _, e := range expressions[i:] {
		if e.sum != 100 {
			break
		}
		fmt.Println(e)
	}

	fmt.Println("\nThe positive sum with maximum number of solutions:")
	fmt.Println(counts[0])

	fmt.Println("\nThe lowest positive number that can't be expressed:")
	s := 1
	for _, e := range expressions {
		if e.sum == s {
			s++
		} else if e.sum > s {
			fmt.Printf("% 10d\n", s)
			break
		}
	}

	fmt.Println("\nThe ten highest numbers that can be expressed:")
	for _, e := range expressions[len(expressions)-10:] {
		fmt.Println(e)
	}
}
