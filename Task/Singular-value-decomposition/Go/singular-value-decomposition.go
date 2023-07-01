<package main

import (
    "fmt"
    "gonum.org/v1/gonum/mat"
    "log"
)

func matPrint(m mat.Matrix) {
    fa := mat.Formatted(m, mat.Prefix(""), mat.Squeeze())
    fmt.Printf("%13.10f\n", fa)
}

func main() {
    var svd mat.SVD
    a := mat.NewDense(2, 2, []float64{3, 0, 4, 5})
    ok := svd.Factorize(a, mat.SVDFull)
    if !ok {
        log.Fatal("Something went wrong!")
    }
    u := mat.NewDense(2, 2, nil)
    svd.UTo(u)
    fmt.Println("U:")
    matPrint(u)
    values := svd.Values(nil)
    sigma := mat.NewDense(2, 2, []float64{values[0], 0, 0, values[1]})
    fmt.Println("\nΣ:")
    matPrint(sigma)
    vt := mat.NewDense(2, 2, nil)
    svd.VTo(vt)
    fmt.Println("\nVT:")
    matPrint(vt)
}
