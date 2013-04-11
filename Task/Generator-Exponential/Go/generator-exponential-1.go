package main

import (
    "fmt"
    "math"
)

// note: exponent not limited to ints
func newPowGen(e float64) func() float64 {
    var i float64
    return func() (r float64) {
        r = math.Pow(i, e)
        i++
        return
    }
}

// given two functions af, bf, both monotonically increasing, return a
// new function that returns values of af not returned by bf.
func newMonoIncA_NotMonoIncB_Gen(af, bf func() float64) func() float64 {
    a, b := af(), bf()
    return func() (r float64) {
        for {
            if a < b {
                r = a
                a = af()
                break
            }
            if b == a {
                a = af()
            }
            b = bf()
        }
        return
    }
}

func main() {
    fGen := newMonoIncA_NotMonoIncB_Gen(newPowGen(2), newPowGen(3))
    for i := 0; i < 20; i++ {
        fGen()
    }
    for i := 0; i < 10; i++ {
        fmt.Print(fGen(), " ")
    }
    fmt.Println()
}
