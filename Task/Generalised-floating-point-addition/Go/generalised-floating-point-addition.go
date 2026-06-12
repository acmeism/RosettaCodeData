package main

import (
    "fmt"
    "math/big"
)

func repeatedAdd(bf *big.Float, times int) *big.Float {
    if times < 2 {
        return bf
    }
    var sum big.Float
    for i := 0; i < times; i++ {
        sum.Add(&sum, bf)
    }
    return &sum
}

func main() {
    s := "12345679"
    t := "123456790"
    e := 63
    var bf, extra big.Float
    for n := -7; n <= 21; n++ {
        bf.SetString(fmt.Sprintf("%se%d", s, e))
        extra.SetString(fmt.Sprintf("1e%d", e))
        bf = *repeatedAdd(&bf, 81)
        bf.Add(&bf, &extra)
        fmt.Printf("%2d : %s\n", n, bf.String())
        s = t + s
        e -= 9
    }
}
