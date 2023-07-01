package main

import (
	"flag"
	"fmt"
	"math"
	"math/big"
	"os"
)

var maxRev = big.NewInt(math.MaxUint64 / 10) // approximate
var ten = big.NewInt(10)

// Reverse sets `result` to the value of the base ten digits of `v` in
// reverse order and returns `result`.
// Only handles positive integers.
func reverseInt(v *big.Int, result *big.Int) *big.Int {
	if v.Cmp(maxRev) <= 0 {
		// optimize small values that fit within uint64
		result.SetUint64(reverseUint64(v.Uint64()))
	} else {
		if true {
			// Reverse the string representation
			s := reverseString(v.String())
			result.SetString(s, 10)
		} else {
			// This has fewer allocations but is slower:
			// Use a copy of `v` since we mutate it.
			v := new(big.Int).Set(v)
			digit := new(big.Int)
			result.SetUint64(0)
			for v.BitLen() > 0 {
				v.QuoRem(v, ten, digit)
				result.Mul(result, ten)
				result.Add(result, digit)
			}
		}
	}
	return result
}

func reverseUint64(v uint64) uint64 {
	var r uint64
	for v > 0 {
		r *= 10
		r += v % 10
		v /= 10
	}
	return r
}

func reverseString(s string) string {
	b := make([]byte, len(s))
	for i, j := 0, len(s)-1; j >= 0; i, j = i+1, j-1 {
		b[i] = s[j]
	}
	return string(b)
}

var known = make(map[string]bool)

func Lychrel(n uint64, iter uint) (isLychrel, isSeed bool) {
	v, r := new(big.Int).SetUint64(n), new(big.Int)
	reverseInt(v, r)
	seen := make(map[string]bool)
	isLychrel = true
	isSeed = true
	for i := iter; i > 0; i-- {
		str := v.String()
		if seen[str] {
			//log.Println("found a loop with", n, "at", str)
			isLychrel = true
			break
		}
		if ans, ok := known[str]; ok {
			//log.Println("already know:", str, ans)
			isLychrel = ans
			isSeed = false
			break
		}
		seen[str] = true

		v = v.Add(v, r)
		//log.Printf("%v + %v = %v\n", str, r, v)
		reverseInt(v, r)
		if v.Cmp(r) == 0 {
			//log.Println(v, "is a palindrome,", n, "is not a Lychrel number")
			isLychrel = false
			isSeed = false
			break
		}
	}
	for k := range seen {
		known[k] = isLychrel
	}
	//if isLychrel { log.Printf("%v may be a Lychrel number\n", n) }
	return isLychrel, isSeed
}

func main() {
	max := flag.Uint64("max", 10000, "search in the range 1..`N` inclusive")
	iter := flag.Uint("iter", 500, "limit palindrome search to `N` iterations")
	flag.Parse()
	if flag.NArg() != 0 {
		flag.Usage()
		os.Exit(2)
	}

	fmt.Printf("Calculating using n = 1..%v and %v iterations:\n", *max, *iter)
	var seeds []uint64
	var related int
	var pals []uint64
	for i := uint64(1); i <= *max; i++ {
		if l, s := Lychrel(i, *iter); l {
			if s {
				seeds = append(seeds, i)
			} else {
				related++
			}
			if i == reverseUint64(i) {
				pals = append(pals, i)
			}
		}
	}

	fmt.Println("      Number of Lychrel seeds:", len(seeds))
	fmt.Println("                Lychrel seeds:", seeds)
	fmt.Println("            Number of related:", related)
	fmt.Println("Number of Lychrel palindromes:", len(pals))
	fmt.Println("          Lychrel palindromes:", pals)
}
