package main

import (
	"fmt"
	"math/big"
)

func main() {

	intMin := func(a, b int) int {
		if a < b {
			return a
		} else {
			return b
		}
	}

	var cache = [][]*big.Int{{big.NewInt(1)}}

	cumu := func(n int) []*big.Int {
		for y := len(cache); y <= n; y++ {
			row := []*big.Int{big.NewInt(0)}
			for x := 1; x <= y; x++ {
				cacheValue := cache[y-x][intMin(x, y-x)]
				row = append(row, big.NewInt(0).Add(row[len(row)-1], cacheValue))
			}
			cache = append(cache, row)
		}
		return cache[n]
	}

	row := func(n int) {
		e := cumu(n)
		for i := 0; i < n; i++ {
			fmt.Printf(" %v ", (big.NewInt(0).Sub(e[i+1], e[i])).Text(10))
		}
		fmt.Println()
	}

	fmt.Println("rows:")
	for x := 1; x < 11; x++ {
		row(x)
	}
	fmt.Println()
	
	fmt.Println("sums:")
	for _, num := range [...]int{23, 123, 1234, 12345} {
		r := cumu(num)
		fmt.Printf("%d %v\n", num, r[len(r)-1].Text(10))
	}
}
