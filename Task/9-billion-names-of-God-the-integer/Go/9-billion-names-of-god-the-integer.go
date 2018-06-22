package main

import (
	f "fmt"
	"math"
	m "math/big"
)

func main() {
	var cache = make([][]m.Int, 0)
	cache = append(cache, append([]m.Int{}, *m.NewInt(1)))

	cumu := func(n int) []m.Int {
		for l := len(cache); l <= n; l++ {
			r := make([]m.Int, 0)
			r = append(r, *m.NewInt(0))
			for x := 1; x <= l; x++ {
				cacheValue := &cache[l-x][int(math.Min(float64(x), float64(l-x)))]
				r = append(r, *m.NewInt(0).Add(&r[len(r)-1], cacheValue))
			}
			cache = append(cache, r)
		}
		return cache[n]
	}

	row := func(n int) {
		e := cumu(n)
		for i := 0; i < n; i++ {
			f.Printf(" %v ", (*m.NewInt(0).Sub(&e[i+1], &e[i])).Text(10))
		}
		f.Print("\n")
	}

	f.Print("rows:\n")
	for x := 1; x < 11; x++ {
		row(x)
	}
	f.Print("\n sums:\n")
	nums := []int{23, 123, 1234,12345}
	for _, num := range nums {
		r := cumu(num)
		f.Printf("%d %v \n", num, r[len(r)-1].Text(10))
	}

}
