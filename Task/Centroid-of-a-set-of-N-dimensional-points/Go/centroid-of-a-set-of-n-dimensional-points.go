package main

import (
    "fmt"
    "log"
)

func centroid(pts [][]float64) []float64 {
    n := len(pts)
    if n == 0 {
        log.Fatal("Slice must contain at least one point.")
    }
    d := len(pts[0])
    for i := 1; i < n; i++ {
        if len(pts[i]) != d {
            log.Fatal("Points must all have the same dimension.")
        }
    }
    res := make([]float64, d)
    for j := 0; j < d; j++ {
        for i := 0; i < n; i++ {
            res[j] += pts[i][j]
        }
        res[j] /= float64(n)
    }
    return res
}

func main() {
    points := [][][]float64{
        {{1}, {2}, {3}},
        {{8, 2}, {0, 0}},
        {{5, 5, 0}, {10, 10, 0}},
        {{1, 3.1, 6.5}, {-2, -5, 3.4}, {-7, -4, 9}, {2, 0, 3}},
        {{0, 0, 0, 0, 1}, {0, 0, 0, 1, 0}, {0, 0, 1, 0, 0}, {0, 1, 0, 0, 0}},
    }
    for _, pts := range points {
        fmt.Println(pts, "=> Centroid:", centroid(pts))
    }
}
