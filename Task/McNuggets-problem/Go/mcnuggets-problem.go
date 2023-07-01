package main

import "fmt"

func mcnugget(limit int) {
    sv := make([]bool, limit+1) // all false by default
    for s := 0; s <= limit; s += 6 {
        for n := s; n <= limit; n += 9 {
            for t := n; t <= limit; t += 20 {
                sv[t] = true
            }
        }
    }
    for i := limit; i >= 0; i-- {
        if !sv[i] {
            fmt.Println("Maximum non-McNuggets number is", i)
            return
        }
    }
}

func main() {
    mcnugget(100)
}
