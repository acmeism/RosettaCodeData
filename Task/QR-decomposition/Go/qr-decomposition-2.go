package main

import (
    "fmt"

    "github.com/gonum/matrix/mat64"
)

func main() {
    // task 1: show qr decomp of wp example
    a := mat64.NewDense(3, 3, []float64{
        12, -51, 4,
        6, 167, -68,
        -4, 24, -41,
    })
    var qr mat64.QR
    qr.Factorize(a)
    var q, r mat64.Dense
    q.QFromQR(&qr)
    r.RFromQR(&qr)
    fmt.Printf("q: %.3f\n\n", mat64.Formatted(&q, mat64.Prefix("   ")))
    fmt.Printf("r: %.3f\n\n", mat64.Formatted(&r, mat64.Prefix("   ")))

    // task 2: use qr decomp for polynomial regression example
    x := []float64{0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
    y := []float64{1, 6, 17, 34, 57, 86, 121, 162, 209, 262, 321}
    a = Vandermonde(x, 2)
    b := mat64.NewDense(11, 1, y)
    qr.Factorize(a)
    var f mat64.Dense
    f.SolveQR(&qr, false, b)
    fmt.Printf("polyfit: %.3f\n",
        mat64.Formatted(&f, mat64.Prefix("         ")))
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
