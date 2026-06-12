package main

import "fmt"

func main() {
    found := make([]bool, 1000) // all false initially
    for l := 1; l < 498; l++ {
        for w := 1; w <= l; w++ {
            lw := l * w
            if lw >= 498 {
                break
            }
            for h := 1; h <= w; h++ {
                sa := (lw + w*h + h*l) * 2
                if sa < 1000 {
                    found[sa] = true
                }
            }
        }
    }
    fmt.Printf("All known O'Halloran numbers:\n[")
    for i := 6; i < 1000; i += 2 {
        if !found[i] {
            fmt.Printf("%d, ", i)
        }
    }
    fmt.Printf("\b\b]\n")
}
