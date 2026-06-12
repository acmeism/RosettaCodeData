package main

import "fmt"

func main() {
    fmt.Println(root(3, 8))
    fmt.Println(root(3, 9))
    fmt.Println(root(2, 2e18))
}

func root(N, X int) int {
    // adapted from https://en.wikipedia.org/wiki/Nth_root_algorithm
    for r := 1; ; {
        x := X
        for i := 1; i < N; i++ {
            x /= r
        }
        x -= r
        // A small complication here is that Go performs truncated integer
        // division but for negative values of x, Δr in the line below needs
        // to be computed as the floor of x / N.  The following % test and
        // correction completes the floor division operation (for positive N.)
        Δr := x / N
        if x%N < 0 {
            Δr--
        }
        if Δr == 0 {
            return r
        }
        r += Δr
    }
}
