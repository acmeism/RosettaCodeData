package main

import (
    "fmt"
    "log"
    "math/big"
)

var (
    primes      []*big.Int
    smallPrimes []int
)

// cache all primes up to 521
func init() {
    two := big.NewInt(2)
    three := big.NewInt(3)
    p521 := big.NewInt(521)
    p29 := big.NewInt(29)
    primes = append(primes, two)
    smallPrimes = append(smallPrimes, 2)
    for i := three; i.Cmp(p521) <= 0; i.Add(i, two) {
        if i.ProbablyPrime(0) {
            primes = append(primes, new(big.Int).Set(i))
            if i.Cmp(p29) <= 0 {
                smallPrimes = append(smallPrimes, int(i.Int64()))
            }
        }
    }
}

func min(bs []*big.Int) *big.Int {
    if len(bs) == 0 {
        log.Fatal("slice must have at least one element")
    }
    res := bs[0]
    for _, i := range bs[1:] {
        if i.Cmp(res) < 0 {
            res = i
        }
    }
    return res
}

func nSmooth(n, size int) []*big.Int {
    if n < 2 || n > 521 {
        log.Fatal("n must be between 2 and 521")
    }
    if size < 1 {
        log.Fatal("size must be at least 1")
    }
    bn := big.NewInt(int64(n))
    ok := false
    for _, prime := range primes {
        if bn.Cmp(prime) == 0 {
            ok = true
            break
        }
    }
    if !ok {
        log.Fatal("n must be a prime number")
    }

    ns := make([]*big.Int, size)
    ns[0] = big.NewInt(1)
    var next []*big.Int
    for i := 0; i < len(primes); i++ {
        if primes[i].Cmp(bn) > 0 {
            break
        }
        next = append(next, new(big.Int).Set(primes[i]))
    }
    indices := make([]int, len(next))
    for m := 1; m < size; m++ {
        ns[m] = new(big.Int).Set(min(next))
        for i := 0; i < len(indices); i++ {
            if ns[m].Cmp(next[i]) == 0 {
                indices[i]++
                next[i].Mul(primes[i], ns[indices[i]])
            }
        }
    }
    return ns
}

func main() {
    for _, i := range smallPrimes {
        fmt.Printf("The first 25 %d-smooth numbers are:\n", i)
        fmt.Println(nSmooth(i, 25), "\n")
    }
    for _, i := range smallPrimes[1:] {
        fmt.Printf("The 3,000th to 3,202nd %d-smooth numbers are:\n", i)
        fmt.Println(nSmooth(i, 3002)[2999:], "\n")
    }
    for _, i := range []int{503, 509, 521} {
        fmt.Printf("The 30,000th to 30,019th %d-smooth numbers are:\n", i)
        fmt.Println(nSmooth(i, 30019)[29999:], "\n")
    }
}
