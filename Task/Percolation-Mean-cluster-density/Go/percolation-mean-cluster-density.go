package main

import (
    "fmt"
    "math/rand"
    "time"
)

var (
    n_range = []int{4, 64, 256, 1024, 4096}
    M       = 15
    N       = 15
)

const (
    p             = .5
    t             = 5
    NOT_CLUSTERED = 1
    cell2char     = " #abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
)

func newgrid(n int, p float64) [][]int {
    g := make([][]int, n)
    for y := range g {
        gy := make([]int, n)
        for x := range gy {
            if rand.Float64() < p {
                gy[x] = 1
            }
        }
        g[y] = gy
    }
    return g
}

func pgrid(cell [][]int) {
    for n := 0; n < N; n++ {
        fmt.Print(n%10, ") ")
        for m := 0; m < M; m++ {
            fmt.Printf(" %c", cell2char[cell[n][m]])
        }
        fmt.Println()
    }
}

func cluster_density(n int, p float64) float64 {
    cc := clustercount(newgrid(n, p))
    return float64(cc) / float64(n) / float64(n)
}

func clustercount(cell [][]int) int {
    walk_index := 1
    for n := 0; n < N; n++ {
        for m := 0; m < M; m++ {
            if cell[n][m] == NOT_CLUSTERED {
                walk_index++
                walk_maze(m, n, cell, walk_index)
            }
        }
    }
    return walk_index - 1
}

func walk_maze(m, n int, cell [][]int, indx int) {
    cell[n][m] = indx
    if n < N-1 && cell[n+1][m] == NOT_CLUSTERED {
        walk_maze(m, n+1, cell, indx)
    }
    if m < M-1 && cell[n][m+1] == NOT_CLUSTERED {
        walk_maze(m+1, n, cell, indx)
    }
    if m > 0 && cell[n][m-1] == NOT_CLUSTERED {
        walk_maze(m-1, n, cell, indx)
    }
    if n > 0 && cell[n-1][m] == NOT_CLUSTERED {
        walk_maze(m, n-1, cell, indx)
    }
}

func main() {
    rand.Seed(time.Now().Unix())
    cell := newgrid(N, .5)
    fmt.Printf("Found %d clusters in this %d by %d grid\n\n",
        clustercount(cell), N, N)
    pgrid(cell)
    fmt.Println()

    for _, n := range n_range {
        M = n
        N = n
        sum := 0.
        for i := 0; i < t; i++ {
            sum += cluster_density(n, p)
        }
        sim := sum / float64(t)
        fmt.Printf("t=%3d p=%4.2f n=%5d sim=%7.5f\n", t, p, n, sim)
    }
}
