package main

import (
    "fmt"
    big "github.com/ncw/gmp"
)

const (
    min = 3
    max = 10
)

var (
    prod       = new(big.Int)
    fact       = new(big.Int)
    factors    = [max]uint64{}
    bigFactors = [max]*big.Int{}
)

func init() {
    for i := 0; i < max; i++ {
        bigFactors[i] = big.NewInt(0)
    }
}

func isPrimePretest(k uint64) bool {
    if k%3 == 0 || k%5 == 0 || k%7 == 0 || k%11 == 0 ||
        k%13 == 0 || k%17 == 0 || k%19 == 0 || k%23 == 0 {
        return k <= 23
    }
    return true
}

func ccFactors(n, m uint64) bool {
    if !isPrimePretest(6*m + 1) {
        return false
    }
    if !isPrimePretest(12*m + 1) {
        return false
    }
    factors[0] = 6*m + 1
    factors[1] = 12*m + 1
    t := 9 * m
    for i := uint64(1); i <= n-2; i++ {
        tt := (t << i) + 1
        if !isPrimePretest(tt) {
            return false
        }
        factors[i+1] = tt
    }

    for i := 0; i < int(n); i++ {
        fact.SetUint64(factors[i])
        if !fact.ProbablyPrime(0) {
            return false
        }
        bigFactors[i].Set(fact)
    }
    return true
}

func prodFactors(n uint64) *big.Int {
    prod.Set(bigFactors[0])
    for i := 1; i < int(n); i++ {
        prod.Mul(prod, bigFactors[i])
    }
    return prod
}

func ccNumbers(start, end uint64) {
    for n := start; n <= end; n++ {
        mult := uint64(1)
        if n > 4 {
            mult = 1 << (n - 4)
        }
        if n > 5 {
            mult *= 5
        }
        m := mult
        for {
            if ccFactors(n, m) {
                num := prodFactors(n)
                fmt.Printf("a(%d) = %d\n", n, num)
                fmt.Printf("m(%d) = %d\n", n, m)
                fmt.Println("Factors:", factors[:n], "\n")
                break
            }
            m += mult
        }
    }
}

func main() {
    ccNumbers(min, max)
}
