package main

import (
    "fmt"
    "log"
    //"math/big"
    big "github.com/ncw/gmp"
    "rcu"
)

var zero = new(big.Int)
var one = big.NewInt(1)
var two = big.NewInt(2)

func juggler(n int64) (int, int, *big.Int, int) {
    if n < 1 {
        log.Fatal("Starting value must be a positive integer.")
    }
    count := 0
    maxCount := 0
    a := big.NewInt(n)
    max := big.NewInt(n)
    tmp := new(big.Int)
    for a.Cmp(one) != 0 {
        if tmp.Rem(a, two).Cmp(zero) == 0 {
            a.Sqrt(a)
        } else {
            tmp.Mul(a, a)
            tmp.Mul(tmp, a)
            a.Sqrt(tmp)
        }
        count++
        if a.Cmp(max) > 0 {
            max.Set(a)
            maxCount = count
        }
    }
    return count, maxCount, max, len(max.String())
}

func main() {
    fmt.Println("n    l[n]  i[n]  h[n]")
    fmt.Println("-----------------------------------")
    for n := int64(20); n < 40; n++ {
        count, maxCount, max, _ := juggler(n)
        cmax := rcu.Commatize(int(max.Int64()))
        fmt.Printf("%2d    %2d   %2d    %s\n", n, count, maxCount, cmax)
    }
    fmt.Println()
    nums := []int64{
        113, 173, 193, 2183, 11229, 15065, 15845, 30817, 48443, 275485, 1267909,
        2264915, 5812827, 7110201, 56261531, 92502777, 172376627, 604398963,
    }
    fmt.Println("       n      l[n]   i[n]   d[n]")
    fmt.Println("-------------------------------------")
    for _, n := range nums {
        count, maxCount, _, digits := juggler(n)
        cn := rcu.Commatize(int(n))
        fmt.Printf("%11s   %3d    %3d    %s\n", cn, count, maxCount, rcu.Commatize(digits))
    }
}
