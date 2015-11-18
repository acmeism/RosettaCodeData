package main

import (
    "fmt"

    "github.com/gonum/matrix/mat64"
)

func givens() (x, y *mat64.Dense) {
    height := []float64{1.47, 1.50, 1.52, 1.55, 1.57, 1.60, 1.63,
        1.65, 1.68, 1.70, 1.73, 1.75, 1.78, 1.80, 1.83}
    weight := []float64{52.21, 53.12, 54.48, 55.84, 57.20, 58.57, 59.93,
        61.29, 63.11, 64.47, 66.28, 68.10, 69.92, 72.19, 74.46}
    degree := 2
    x = Vandermonde(height, degree)
    y = mat64.NewDense(len(weight), 1, weight)
    return
}

func Vandermonde(a []float64, degree int) *mat64.Dense {
    x := mat64.NewDense(len(a), degree+1, nil)
    for i := range a {
        for j, p := 0, 1.; j <= degree; j, p = j+1, p*a[i] {
            x.Set(i, j, p)
        }
    }
    return x
}

func main() {
    x, y := givens()
    fmt.Printf("%.4f\n", mat64.Formatted(mat64.QR(x).Solve(y)))
}
