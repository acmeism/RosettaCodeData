package main

import "fmt"

type vector []float64

func (v vector) add(v2 vector) vector {
    r := make([]float64, len(v))
    for i, vi := range v {
        r[i] = vi + v2[i]
    }
    return r
}

func (v vector) sub(v2 vector) vector {
    r := make([]float64, len(v))
    for i, vi := range v {
        r[i] = vi - v2[i]
    }
    return r
}

func (v vector) scalarMul(s float64) vector {
    r := make([]float64, len(v))
    for i, vi := range v {
        r[i] = vi * s
    }
    return r
}

func (v vector) scalarDiv(s float64) vector {
    r := make([]float64, len(v))
    for i, vi := range v {
        r[i] = vi / s
    }
    return r
}

func main() {
    v1 := vector{5, 7}
    v2 := vector{2, 3}
    fmt.Println(v1.add(v2))
    fmt.Println(v1.sub(v2))
    fmt.Println(v1.scalarMul(11))
    fmt.Println(v1.scalarDiv(2))
}
