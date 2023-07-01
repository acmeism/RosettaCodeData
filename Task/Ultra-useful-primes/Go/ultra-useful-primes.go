package main

import (
    "fmt"
    big "github.com/ncw/gmp"
)

var two = big.NewInt(2)

func a(n uint) int {
    one := big.NewInt(1)
    p := new(big.Int).Lsh(one, 1 << n)
    p.Sub(p, one)
    for k := 1; ; k += 2 {
        if p.ProbablyPrime(15) {
            return k
        }
        p.Sub(p, two)
    }
}

func main() {
    fmt.Println(" n   k")
    fmt.Println("----------")
    for n := uint(1); n < 14; n++ {
        fmt.Printf("%2d   %d\n", n, a(n))
    }
}
