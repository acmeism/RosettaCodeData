package main

import (
    "fmt"

    "gonum.org/v1/gonum/mat"
)

func main() {
    showLU(mat.NewDense(3, 3, []float64{
        1, 3, 5,
        2, 4, 7,
        1, 1, 0,
    }))
    fmt.Println()
    showLU(mat.NewDense(4, 4, []float64{
        11, 9, 24, 2,
        1, 5, 2, 6,
        3, 17, 18, 1,
        2, 5, 7, 1,
    }))
}

func showLU(a *mat.Dense) {
    fmt.Printf("a: %v\n\n", mat.Formatted(a, mat.Prefix("   ")))
    var lu mat.LU
    lu.Factorize(a)
    l := lu.LTo(nil)
    u := lu.UTo(nil)
    fmt.Printf("l: %.5f\n\n", mat.Formatted(l, mat.Prefix("   ")))
    fmt.Printf("u: %.5f\n\n", mat.Formatted(u, mat.Prefix("   ")))
    fmt.Println("p:", lu.Pivot(nil))
}
