package main

import (
	"fmt"
	"math"
)

func primesOdds(top uint) func() uint {
	topndx := int((top - 3) / 2)
	topsqrtndx := (int(math.Sqrt(float64(top))) - 3) / 2
	cmpsts := make([]uint, (topndx/32)+1)
	for i := 0; i <= topsqrtndx; i++ {
		if cmpsts[i>>5]&(uint(1)<<(uint(i)&0x1F)) == 0 {
			p := (i << 1) + 3
			for j := (p*p - 3) >> 1; j <= topndx; j += p {
				cmpsts[j>>5] |= 1 << (uint(j) & 0x1F)
			}
		}
	}
	i := -1
	return func() uint {
		oi := i
		if i <= topndx {
			i++
		}
		for i <= topndx && cmpsts[i>>5]&(1<<(uint(i)&0x1F)) != 0 {
			i++
		}
		if oi < 0 {
			return 2
		} else {
			return (uint(oi) << 1) + 3
		}
	}
}

func main() {
	iter := primesOdds(100)
	for v := iter(); v <= 100; v = iter() {
		print(v, " ")
	}
	iter = primesOdds(1000000)
	count := 0
	for v := iter(); v <= 1000000; v = iter() {
		count++
	}
	fmt.Printf("\r\n%v\r\n", count)
}
