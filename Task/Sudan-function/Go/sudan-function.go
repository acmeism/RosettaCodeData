package main

import "fmt"

func F(n, x, y int) int {
    if n == 0 {
        return x + y
    }
    if y == 0 {
        return x
    }
    return F(n-1, F(n, x, y-1), F(n, x, y-1)+y)
}

func main() {
    for n := 0; n < 2; n++ {
        fmt.Printf("Values of F(%d, x, y):\n", n)
        fmt.Println("y/x    0   1   2   3   4   5")
        fmt.Println("----------------------------")
        for y := 0; y < 7; y++ {
            fmt.Printf("%d  |", y)
            for x := 0; x < 6; x++ {
                fmt.Printf("%4d", F(n, x, y))
            }
            fmt.Println()
        }
        fmt.Println()
    }
    fmt.Printf("F(2, 1, 1) = %d\n", F(2, 1, 1))
    fmt.Printf("F(3, 1, 1) = %d\n", F(3, 1, 1))
    fmt.Printf("F(2, 2, 1) = %d\n", F(2, 2, 1))
}
