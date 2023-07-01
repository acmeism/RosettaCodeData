package main

import (
	"flag"
	"fmt"
	"github.com/jbarham/primegen.go" // Sieve of Atkin implementation
	"math"
)

// primeCache is a simple cache of small prime numbers, it very
// well might be faster to just regenerate them as needed.
type primeCache struct {
	gen    *primegen.Primegen
	primes []uint64
}

func NewPrimeCache() primeCache {
	g := primegen.New()
	return primeCache{gen: g, primes: []uint64{g.Next()}}
}

// upto returns a slice of primes <= n.
// The returned slice is shared with all callers, do not modify it!
func (pc *primeCache) upto(n uint64) []uint64 {
	if p := pc.primes[len(pc.primes)-1]; p <= n {
		for p <= n {
			p = pc.gen.Next()
			pc.primes = append(pc.primes, p)
		}
		return pc.primes[:len(pc.primes)-1]
	}
	for i, p := range pc.primes {
		if p > n {
			return pc.primes[:i]
		}
	}
	panic("not reached")
}

var cache = NewPrimeCache()

func sqrt(x uint64) uint64 { return uint64(math.Sqrt(float64(x))) }

// isprime does a simple test if n is prime.
// See also math/big.ProbablyPrime().
func isprime(n uint64) bool {
	for _, p := range cache.upto(sqrt(n)) {
		if n%p == 0 {
			return false
		}
	}
	return true
}

func reverse(n uint64) (r uint64) {
	for n > 0 {
		r = 10*r + n%10
		n /= 10
	}
	return
}

// isEmirp does a simple test if n is Emirp, n must be prime
func isEmirp(n uint64) bool {
	r := reverse(n)
	return r != n && isprime(r)
}

// EmirpGen is a sequence generator for Emirp primes
type EmirpGen struct {
	pgen     *primegen.Primegen
	nextn    uint64
	r1l, r1h uint64
	r2l, r2h uint64
	r3l, r3h uint64
}

func NewEmirpGen() *EmirpGen {
	e := &EmirpGen{pgen: primegen.New()}
	e.Reset()
	return e
}

func (e *EmirpGen) Reset() {
	e.pgen.Reset()
	e.nextn = 0
	// Primes >7 cannot end in 2,4,5,6,8 (leaving 1,3,7)
	e.r1l, e.r1h = 20, 30
	e.r2l, e.r2h = 40, 70
	e.r3l, e.r3h = 80, 90
}

func (e *EmirpGen) next() (n uint64) {
	for n = e.pgen.Next(); !isEmirp(n); n = e.pgen.Next() {
		// Skip over inpossible ranges
		// Benchmarks show this saves ~20% when generating n upto 1e6
		switch {
		case e.r1l <= n && n < e.r1h:
			e.pgen.SkipTo(e.r1h)
		case e.r2l <= n && n < e.r2h:
			e.pgen.SkipTo(e.r2h)
		case e.r3l <= n && n < e.r3h:
			e.pgen.SkipTo(e.r3h)
		case n > e.r3h:
			e.r1l *= 10
			e.r1h *= 10
			e.r2l *= 10
			e.r2h *= 10
			e.r3l *= 10
			e.r3h *= 10
		}
	}
	return
}

func (e *EmirpGen) Next() (n uint64) {
	if n = e.nextn; n != 0 {
		e.nextn = 0
		return
	}
	return e.next()
}

func (e *EmirpGen) Peek() uint64 {
	if e.nextn == 0 {
		e.nextn = e.next()
	}
	return e.nextn
}

func (e *EmirpGen) SkipTo(nn uint64) {
	e.pgen.SkipTo(nn)
	e.nextn = 0
	return
}

// SequenceGen defines an arbitrary sequence generator.
// Both *primegen.Primegen and *EmirpGen implement this.
type SequenceGen interface {
	Next() uint64
	Peek() uint64
	Reset()
	SkipTo(uint64)
	//Count(uint64) uint64 // not implemented for *EmirpGen
}

func main() {
	var start, end uint64
	var n, skip uint
	var oneline, primes bool
	flag.UintVar(&n, "n", math.MaxUint64, "number of emirps to print")
	flag.UintVar(&skip, "skip", 0, "number of emirps to skip")
	flag.Uint64Var(&start, "start", 0, "start at x>=start")
	flag.Uint64Var(&end, "end", math.MaxUint64, "stop at x<=end")
	flag.BoolVar(&oneline, "oneline", false, "output on a single line")
	flag.BoolVar(&primes, "primes", false, "generate primes rather than emirps")
	flag.Parse()

	sep := "\n"
	if oneline {
		sep = " "
	}

	// Here's where making SequenceGen an interface comes in handy:
	var seq SequenceGen
	if primes {
		seq = primegen.New()
	} else {
		seq = NewEmirpGen()
	}

	for seq.Peek() < start {
		seq.Next()
	}
	for ; skip > 0; skip-- {
		seq.Next()
	}
	for ; n > 0 && seq.Peek() <= end; n-- {
		fmt.Print(seq.Next(), sep)
	}
	if oneline {
		fmt.Println()
	}
}
