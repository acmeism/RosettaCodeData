package main

import (
    "fmt"

    "github.com/gonum/matrix/mat64"
)

func kronecker(a, b mat64.Matrix) *mat64.Dense {
    ar, ac := a.Dims()
    br, bc := b.Dims()
    k := mat64.NewDense(ar*br, ac*bc, nil)
    for i := 0; i < ar; i++ {
        for j := 0; j < ac; j++ {
            s := k.Slice(i*br, (i+1)*br, j*bc, (j+1)*bc).(*mat64.Dense)
            s.Scale(a.At(i, j), b)
        }
    }
    return k
}

func main() {
    fmt.Println(mat64.Formatted(kronecker(
        mat64.NewDense(2, 2, []float64{
            1, 2,
            3, 4,
        }),
        mat64.NewDense(2, 2, []float64{
            0, 5,
            6, 7,
        }))))
    fmt.Println()
    fmt.Println(mat64.Formatted(kronecker(
        mat64.NewDense(3, 3, []float64{
            0, 1, 0,
            1, 1, 1,
            0, 1, 0,
        }),
        mat64.NewDense(3, 4, []float64{
            1, 1, 1, 1,
            1, 0, 0, 1,
            1, 1, 1, 1,
        }))))
}
