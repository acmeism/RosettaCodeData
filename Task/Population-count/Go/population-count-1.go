package main

import (
    "fmt"
    "math/bits"
)

func main() {
    fmt.Println("Pop counts, powers of 3:")
    n := uint64(1) // 3^0
    for i := 0; i < 30; i++ {
        fmt.Printf("%d ", bits.OnesCount64(n))
        n *= 3
    }
    fmt.Println()
    fmt.Println("Evil numbers:")
    var od [30]uint64
    var ne, no int
    for n = 0; ne+no < 60; n++ {
        if bits.OnesCount64(n)&1 == 0 {
            if ne < 30 {
                fmt.Printf("%d ", n)
                ne++
            }
        } else {
            if no < 30 {
                od[no] = n
                no++
            }
        }
    }
    fmt.Println()
    fmt.Println("Odious numbers:")
    for _, n := range od {
        fmt.Printf("%d ", n)
    }
    fmt.Println()
}
