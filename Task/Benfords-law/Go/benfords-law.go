package main

import (
    "fmt"
    "math"
)

func Fib1000() []float64 {
    a, b, r := 0., 1., [1000]float64{}
    for i := range r {
        r[i], a, b = b, b, b+a
    }
    return r[:]
}

func main() {
    show(Fib1000(), "First 1000 Fibonacci numbers")
}

func show(c []float64, title string) {
    var f [9]int
    for _, v := range c {
        f[fmt.Sprintf("%g", v)[0]-'1']++
    }
    fmt.Println(title)
    fmt.Println("Digit  Observed  Predicted")
    for i, n := range f {
        fmt.Printf("  %d  %9.3f  %8.3f\n", i+1, float64(n)/float64(len(c)),
            math.Log10(1+1/float64(i+1)))
    }
}
