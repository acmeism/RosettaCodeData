package main

import "fmt"

func mosaicMatrix(n uint) {
    for i := uint(0); i < n; i++ {
        for j := uint(0); j < n; j++ {
            if (i+j)%2 == 0 {
                fmt.Printf("%s ", "1")
            } else {
                fmt.Printf("%s ", ".")
            }
        }
        fmt.Println()
    }
}

func main() {
    mosaicMatrix(7)
    fmt.Println()
    mosaicMatrix(8)
}
