package main

import (
    "fmt"

    "github.com/gonum/matrix/mat64"
)

var (
    x = []float64{0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
    y = []float64{1, 6, 17, 34, 57, 86, 121, 162, 209, 262, 321}

    degree = 2
)

func main() {
    a := Vandermonde(x, degree)
    b := mat64.NewDense(len(y), 1, y)
    c := mat64.NewDense(degree+1, 1, nil)

    qr := new(mat64.QR)
    qr.Factorize(a)

    err := c.SolveQR(qr, false, b)
    if err != nil {
        fmt.Println(err)
    } else {
        fmt.Printf("%.3f\n", mat64.Formatted(c))
    }
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
