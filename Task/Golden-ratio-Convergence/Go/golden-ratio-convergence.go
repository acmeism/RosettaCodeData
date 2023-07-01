package main

import (
    "fmt"
    "math"
)

func main() {
    oldPhi := 1.0
    var phi float64
    iters := 0
    limit := 1e-5
    for {
        phi = 1.0 + 1.0/oldPhi
        iters++
        if math.Abs(phi-oldPhi) <= limit {
            break
        }
        oldPhi = phi
    }
    fmt.Printf("Final value of phi : %16.14f\n", phi)
    actualPhi := (1.0 + math.Sqrt(5.0)) / 2.0
    fmt.Printf("Number of iterations : %d\n", iters)
    fmt.Printf("Error (approx) : %16.14f\n", phi-actualPhi)
}
