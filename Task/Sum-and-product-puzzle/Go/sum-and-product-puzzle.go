package main

import "fmt"

type pair struct{ x, y int }

func main() {
	//const max = 100
	// Use 1685 (the highest with a unique answer) instead
	// of 100 just to make it work a little harder :).
	const max = 1685
	var all []pair
	for a := 2; a < max; a++ {
		for b := a + 1; b < max-a; b++ {
			all = append(all, pair{a, b})
		}
	}
	fmt.Println("There are", len(all), "pairs where a+b <", max, "(and a<b)")
	products := countProducts(all)

	// Those for which no sum decomposition has unique product to are
	// S mathimatician's possible pairs.
	var sPairs []pair
pairs:
	for _, p := range all {
		s := p.x + p.y
		// foreach a+b=s (a<b)
		for a := 2; a < s/2+s&1; a++ {
			b := s - a
			if products[a*b] == 1 {
				// Excluded because P would have a unique product
				continue pairs
			}
		}
		sPairs = append(sPairs, p)
	}
	fmt.Println("S starts with", len(sPairs), "possible pairs.")
	//fmt.Println("S pairs:", sPairs)
	sProducts := countProducts(sPairs)

	// Look in sPairs for those with a unique product to get
	// P mathimatician's possible pairs.
	var pPairs []pair
	for _, p := range sPairs {
		if sProducts[p.x*p.y] == 1 {
			pPairs = append(pPairs, p)
		}
	}
	fmt.Println("P then has", len(pPairs), "possible pairs.")
	//fmt.Println("P pairs:", pPairs)
	pSums := countSums(pPairs)

	// Finally, look in pPairs for those with a unique sum
	var final []pair
	for _, p := range pPairs {
		if pSums[p.x+p.y] == 1 {
			final = append(final, p)
		}
	}

	// Nicely show any answers.
	switch len(final) {
	case 1:
		fmt.Println("Answer:", final[0].x, "and", final[0].y)
	case 0:
		fmt.Println("No possible answer.")
	default:
		fmt.Println(len(final), "possible answers:", final)
	}
}

func countProducts(list []pair) map[int]int {
	m := make(map[int]int)
	for _, p := range list {
		m[p.x*p.y]++
	}
	return m
}

func countSums(list []pair) map[int]int {
	m := make(map[int]int)
	for _, p := range list {
		m[p.x+p.y]++
	}
	return m
}

// not used, manually inlined above
func decomposeSum(s int) []pair {
	pairs := make([]pair, 0, s/2)
	for a := 2; a < s/2+s&1; a++ {
		pairs = append(pairs, pair{a, s - a})
	}
	return pairs
}
