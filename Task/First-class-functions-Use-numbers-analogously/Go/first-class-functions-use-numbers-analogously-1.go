package main

import "fmt"

func main() {
    x := 2.
    xi := .5
    y := 4.
    yi := .25
    z := x + y
    zi := 1 / (x + y)
    // point A

    numbers := []float64{x, y, z}
    inverses := []float64{xi, yi, zi}
    // point B

    mfs := make([]func(float64) float64, len(numbers))
    for i := range mfs {
        mfs[i] = multiplier(numbers[i], inverses[i])
    }
    // point C

    for _, mf := range mfs {
        fmt.Println(mf(1))
    }
}

func multiplier(n1, n2 float64) func(float64) float64 {
    // compute product of n's, store in a new variable
    n1n2 := n1 * n2
    // close on variable containing product
    return func(m float64) float64 {
        return n1n2 * m
    }
}
