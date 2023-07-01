package main

import (
    "fmt"
    "log"
)

func ms(n int) (int, []int) {
    M := func(x int) int { return (x + n - 1) % n }
    if n <= 0 || n&1 == 0 {
        n = 5
        log.Println("forcing size", n)
    }
    m := make([]int, n*n)
    i, j := 0, n/2
    for k := 1; k <= n*n; k++ {
        m[i*n+j] = k
        if m[M(i)*n+M(j)] != 0 {
            i = (i + 1) % n
        } else {
            i, j = M(i), M(j)
        }
    }
    return n, m
}

func main() {
    n, m := ms(5)
    i := 2
    for j := 1; j <= n*n; j *= 10 {
        i++
    }
    f := fmt.Sprintf("%%%dd", i)
    for i := 0; i < n; i++ {
        for j := 0; j < n; j++ {
            fmt.Printf(f, m[i*n+j])
        }
        fmt.Println()
    }
}
