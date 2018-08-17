package main

import "fmt"

var i int

func sum(i *int, lo, hi int, term func() float64) float64 {
    temp := 0.0
    for *i = lo; *i <= hi; (*i)++ {
        temp += term()
    }
    return temp
}

func main() {
    fmt.Printf("%f\n", sum(&i, 1, 100, func() float64 { return 1.0 / float64(i) }))
}
