package main

import (
    "fmt"

    mat "github.com/skelterjohn/go.matrix"
)

func main() {
    a := mat.MakeDenseMatrixStacked([][]float64{
        {1, 1, 1, 1},
        {2, 4, 8, 16},
        {3, 9, 27, 81},
        {4, 16, 64, 256},
    })
    b := mat.MakeDenseMatrixStacked([][]float64{
        {
            4,
            -3,
            4. / 3,
            -1. / 4,
        },
        {
            -13. / 3,
            19. / 4,
            -7. / 3,
            11. / 24,
        },
        {
            3. / 2,
            -2,
            7. / 6,
            -1. / 4,
        },
        {
            -1. / 6,
            1. / 4,
            -1. / 6,
            1. / 24,
        },
    })
    p, err := a.TimesDense(b)
    fmt.Printf("Matrix A:\n%v\n", a)
    fmt.Printf("Matrix B:\n%v\n", b)
    if err != nil {
        fmt.Println(err)
        return
    }
    fmt.Printf("Product of A and B:\n%v\n", p)
}
