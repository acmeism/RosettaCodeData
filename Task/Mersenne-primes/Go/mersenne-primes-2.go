package main

import (
	"fmt"
	"runtime"
	"time"

	// Use one or the other of these:
	"math/big"
	//big "github.com/ncw/gmp"
)

func main() {
	start := time.Now()

	nworkers := runtime.GOMAXPROCS(0)
	fmt.Println("Using", nworkers, "workers.")
	workC := make(chan uint, 1)
	resultC := make(chan uint, nworkers)

	// Generate possible Mersenne exponents and send them to workC.
	go func() {
		workC <- 2
		bp := big.NewInt(0)
		for p := uint(3); ; p += 2 {
			// Possible exponents must be prime.
			bp.SetUint64(uint64(p))
			if bp.ProbablyPrime(0) {
				workC <- p
			}
		}
	}()

	// Start up worker go routines, each takes
	// possible Mersenne exponents from workC as `p`
	// and if 2^p-1 is prime sends `p` to resultC.
	one := big.NewInt(1)
	for i := 0; i < nworkers; i++ {
		go func() {
			mp := big.NewInt(0)
			for p := range workC {
				mp.Lsh(one, p)
				mp.Sub(mp, one)
				if mp.ProbablyPrime(0) {
					resultC <- p
				}
			}
		}()
	}

	// Receive some maximum number of Mersenne prime exponents
	// from resultC and show the Mersenne primes.
	const max = 24
	for count := 0; count < max; count++ {
		// Note: these could come back out of order, although usually
		// only the first few. If that is an issue, correcting it is
		// left as an excercise to the reader :).
		p := <-resultC
		elapsed := time.Since(start).Seconds()
		if elapsed >= 0.01 {
			fmt.Printf("2 ^ %-5d - 1 took %6.2f secs\n", p, elapsed)
		} else {
			fmt.Printf("2 ^ %-5d - 1\n", p)
		}
	}
}
