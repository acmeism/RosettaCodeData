package main

import "fmt"

func specialMatrix(n uint) {
    for i := uint(0); i < n; i++ {
        for j := uint(0); j < n; j++ {
            if i == j || i+j == n-1 {
                fmt.Printf("%d ", 1)
            } else {
                fmt.Printf("%d ", 0)
            }
        }
        fmt.Println()
    }
}

func main() {
    specialMatrix(8) // even n
    fmt.Println()
    specialMatrix(9) // odd n
}
