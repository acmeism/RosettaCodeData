package main

import "fmt"

const (
    N = 2200
    N2 = N * N * 2
)

func main() {
    s  := 3
    var s1, s2 int
    var r  [N + 1]bool
    var ab [N2 + 1]bool

    for a := 1; a <= N; a++ {
        a2 := a * a
        for b := a; b <= N; b++ {
            ab[a2 + b * b] = true
        }
    }

    for c := 1; c <= N; c++ {
        s1 = s
        s += 2
        s2 = s
        for d := c + 1; d <= N; d++ {
            if ab[s1] {
                r[d] = true
            }
            s1 += s2
            s2 += 2
        }
    }

    for d := 1; d <= N; d++ {
        if !r[d] {
            fmt.Printf("%d ", d)
        }
    }
    fmt.Println()
}
