package main

import (
    "fmt"
    "math"
)

func isSquare(n int) bool {
    s := int(math.Sqrt(float64(n)))
    return s*s == n
}

func main() {
    var squares []int
outer:
    for i := 1; i < 50; i++ {
        if isSquare(i) {
            squares = append(squares, i)
        } else {
            n := i
            limit := 10
            for {
                n *= 10
                for j := 0; j < limit; j++ {
                    s := n + j
                    if isSquare(s) {
                        squares = append(squares, s)
                        continue outer
                    }
                }
                limit *= 10
            }
        }
    }
    fmt.Println("Smallest squares that begin with 'n' in [1, 49]:")
    for i, s := range squares {
        fmt.Printf("%5d  ", s)
        if ((i + 1) % 10) == 0 {
            fmt.Println()
        }
    }
    if (len(squares) % 10) != 0 {
        fmt.Println()
    }
}
