package main

import (
    "fmt"
    "math/big"
    "math/rand"
    "strings"
)

func main() {
    const cells = 20
    const generations = 9
    fmt.Println("Single 1, rule 90:")
    a := big.NewInt(1)
    a.Lsh(a, cells/2)
    elem(90, cells, generations, a)
    fmt.Println("Random intial state, rule 30:")
    a = big.NewInt(1)
    a.Rand(rand.New(rand.NewSource(3)), a.Lsh(a, cells))
    elem(30, cells, generations, a)
}

func elem(rule uint, cells, generations int, a *big.Int) {
    output := func() {
        fmt.Println(strings.Replace(strings.Replace(
            fmt.Sprintf("%0*b", cells, a), "0", " ", -1), "1", "#", -1))
    }
    output()
    a1 := new(big.Int)
    set := func(cell int, k uint) {
        a1.SetBit(a1, cell, rule>>k&1)
    }
    last := cells - 1
    for r := 0; r < generations; r++ {
        k := a.Bit(last) | a.Bit(0)<<1 | a.Bit(1)<<2
        set(0, k)
        for c := 1; c < last; c++ {
            k = k>>1 | a.Bit(c+1)<<2
            set(c, k)
        }
        set(last, k>>1|a.Bit(0)<<2)
        a, a1 = a1, a
        output()
    }
}
