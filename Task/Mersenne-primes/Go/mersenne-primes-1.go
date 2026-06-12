package main

import (
	"fmt"
	"time"

	// Use one or the other of these:
	"math/big"
	//big "github.com/ncw/gmp"
)

func main() {
	start := time.Now()
	one := big.NewInt(1)
	mp := big.NewInt(0)
	bp := big.NewInt(0)
	const max = 22
	for count, p := 0, uint(2); count < max; {
		mp.Lsh(one, p)
		mp.Sub(mp, one)
		if mp.ProbablyPrime(0) {
			elapsed := time.Since(start).Seconds()
			if elapsed >= 0.01 {
				fmt.Printf("2 ^ %-4d - 1 took %6.2f secs\n", p, elapsed)
			} else {
				fmt.Printf("2 ^ %-4d - 1\n", p)
			}
			count++
		}
		for {
			if p > 2 {
				p += 2
			} else {
				p = 3
			}
			bp.SetUint64(uint64(p))
			if bp.ProbablyPrime(0) {
				break
			}
		}
	}
}
