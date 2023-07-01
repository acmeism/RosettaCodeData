package main

import (
    "fmt"
    "github.com/jbarham/primegen"
    big "github.com/ncw/gmp"
    "time"
)

func vecprod(primes []uint64) *big.Int {
    if len(primes) == 0 {
        return big.NewInt(1)
    }
    s := make([]*big.Int, len(primes))
    le := len(s)
    for i := 0; i < le; i++ {
        s[i] = new(big.Int).SetUint64(primes[i])
    }
    for le > 1 {
        for i := 0; i < le/2; i++ {
            s[i].Mul(s[i], s[le-i-1])
        }
        c := le / 2
        if le&1 == 1 {
            c++
        }
        s = s[0:c]
        le = c
    }
    return s[0]
}

func main() {
    start := time.Now()
    pg := primegen.New()
    var primes []uint64
    for i := uint64(0); i < 1e6; i++ {
        primes = append(primes, pg.Next())
    }
    for i := 0; i < 10; i++ {
        fmt.Printf("primorial(%d) = %d\n", i, vecprod(primes[0:i]))
    }
    fmt.Println()
    for _, i := range []uint64{1e1, 1e2, 1e3, 1e4, 1e5, 1e6} {
        fmt.Printf("primorial(%d) has length %d\n", i, len(vecprod(primes[0:i]).String()))
    }
    fmt.Printf("\nTook %s\n", time.Since(start))
}
