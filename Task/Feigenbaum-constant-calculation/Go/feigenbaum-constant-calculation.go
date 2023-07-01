package main

import "fmt"

func feigenbaum() {
    maxIt, maxItJ := 13, 10
    a1, a2, d1 := 1.0, 0.0, 3.2
    fmt.Println(" i       d")
    for i := 2; i <= maxIt; i++ {
        a := a1 + (a1-a2)/d1
        for j := 1; j <= maxItJ; j++ {
            x, y := 0.0, 0.0
            for k := 1; k <= 1<<uint(i); k++ {
                y = 1.0 - 2.0*y*x
                x = a - x*x
            }
            a -= x / y
        }
        d := (a1 - a2) / (a - a1)
        fmt.Printf("%2d    %.8f\n", i, d)
        d1, a2, a1 = d, a1, a
    }
}

func main() {
    feigenbaum()
}
