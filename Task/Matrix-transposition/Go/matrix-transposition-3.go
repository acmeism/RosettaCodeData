package main

import "fmt"

type row []float64
type matrix []row

func main() {
    m := matrix{
        {1, 2, 3},
        {4, 5, 6},
    }
    printMatrix(m)
    t := transpose(m)
    printMatrix(t)
}

func printMatrix(m matrix) {
    for _, s := range m {
        fmt.Println(s)
    }
}

func transpose(m matrix) matrix {
    r := make(matrix, len(m[0]))
    for x, _ := range r {
        r[x] = make(row, len(m))
    }
    for y, s := range m {
        for x, e := range s {
            r[x][y] = e
        }
    }
    return r
}
