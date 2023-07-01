package main

import (
    "fmt"
    "math"
)

const epsilon = 1.0e-15

func main() {
    fact := uint64(1)
    e := 2.0
    n := uint64(2)
    for {
        e0 := e
        fact *= n
        n++
        e += 1.0 / float64(fact)
        if math.Abs(e - e0) < epsilon {
            break
        }
    }
    fmt.Printf("e = %.15f\n", e)
}
