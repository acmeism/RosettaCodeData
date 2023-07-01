package main

import (
	"fmt"
	"sort"
)

func sieve(limit uint64) []bool {
	limit++
	// True denotes composite, false denotes prime.
	// We don't bother filling in the even composites.
	c := make([]bool, limit)
	c[0] = true
	c[1] = true
	p := uint64(3) // Start from 3.
	for {
		p2 := p * p
		if p2 >= limit {
			break
		}
		for i := p2; i < limit; i += 2 * p {
			c[i] = true
		}
		for {
			p += 2
			if !c[p] {
				break
			}
		}
	}
	return c
}

func main() {
	// sieve up to the 100 millionth prime
	sieved := sieve(2038074743)

	transMap := make(map[int]int, 19)
	i := 2            // last digit of first prime
	p := int64(3 - 2) // next prime, -2 since we +=2 first
	n := 1
	for _, num := range [...]int{1e4, 1e6, 1e8} {
		for ; n < num; n++ {
			// Set p to next prime by skipping composites.
			p += 2
			for sieved[p] {
				p += 2
			}
			// Count transition of i -> j.
			j := int(p % 10)
			transMap[i*10+j]++
			i = j
		}
		reportTransitions(transMap, n)
	}
}

func reportTransitions(transMap map[int]int, num int) {
	keys := make([]int, 0, len(transMap))
	for k := range transMap {
		keys = append(keys, k)
	}
	sort.Ints(keys)
	fmt.Println("First", num, "primes. Transitions prime % 10 -> next-prime % 10.")
	for _, key := range keys {
		count := transMap[key]
		freq := float64(count) / float64(num) * 100
		fmt.Printf("%d -> %d  count: %7d", key/10, key%10, count)
		fmt.Printf("  frequency: %4.2f%%\n", freq)
	}
	fmt.Println()
}
