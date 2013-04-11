package main

import (
    "fmt"
    "math"
)

func newPowGen(e float64) chan float64 {
    ch := make(chan float64)
    go func() {
        for i := 0.; ; i++ {
            ch <- math.Pow(i, e)
        }
    }()
    return ch
}

// given two input channels, a and b, both known to return monotonically
// increasing values, supply on channel c values of a not returned by b.
func newMonoIncA_NotMonoIncB_Gen(a, b chan float64) chan float64 {
    ch := make(chan float64)
    go func() {
        for va, vb := <-a, <-b; ; {
            switch {
            case va < vb:
                ch <- va
                fallthrough
            case va == vb:
                va = <-a
            default:
                vb = <-b

            }
        }
    }()
    return ch
}

func main() {
    ch := newMonoIncA_NotMonoIncB_Gen(newPowGen(2), newPowGen(3))
    for i := 0; i < 20; i++ {
        <-ch
    }
    for i := 0; i < 10; i++ {
        fmt.Print(<-ch, " ")
    }
    fmt.Println()
}
