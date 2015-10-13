package main

import (
    "fmt"

    "github.com/gonum/matrix/mat64"
)

func main() {
    showLU(mat64.NewDense(3, 3, []float64{
        1, 3, 5,
        2, 4, 7,
        1, 1, 0,
    }))
    fmt.Println()
    showLU(mat64.NewDense(4, 4, []float64{
        11, 9, 24, 2,
        1, 5, 2, 6,
        3, 17, 18, 1,
        2, 5, 7, 1,
    }))
}

func showLU(a *mat64.Dense) {
    fmt.Printf("a: %v\n\n", mat64.Formatted(a, mat64.Prefix("   ")))
    var lu mat64.LU
    lu.Factorize(a)
    var l, u mat64.TriDense
    l.LFrom(&lu)
    u.UFrom(&lu)
    fmt.Printf("l: %.5f\n\n", mat64.Formatted(&l, mat64.Prefix("   ")))
    fmt.Printf("u: %.5f\n\n", mat64.Formatted(&u, mat64.Prefix("   ")))
    fmt.Println("p:", lu.Pivot(nil))
}
