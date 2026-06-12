package main

import "fmt"

func hollowMatrix(n uint) {
    for i := uint(0); i < n; i++ {
        for j := uint(0); j < n; j++ {
            if i == 0 || i == n-1 || j == 0 || j == n-1 {
                fmt.Printf("%d ", 1)
            } else {
                fmt.Printf("%d ", 0)
            }
        }
        fmt.Println()
    }
}

func main() {
    hollowMatrix(8)
    fmt.Println()
    hollowMatrix(9)
}
