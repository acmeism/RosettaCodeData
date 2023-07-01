package main

import (
    "fmt"
    "math"
    "math/rand"
    "strings"
)

func main() {
    sample(100)
    sample(1000)
    sample(10000)
}

func sample(n int) {
    // generate data
    d := make([]float64, n)
    for i := range d {
        d[i] = rand.Float64()
    }
    // show mean, standard deviation
    var sum, ssq float64
    for _, s := range d {
        sum += s
        ssq += s * s
    }
    fmt.Println(n, "numbers")
    m := sum / float64(n)
    fmt.Println("Mean:  ", m)
    fmt.Println("Stddev:", math.Sqrt(ssq/float64(n)-m*m))
    // show histogram
    h := make([]int, 10)
    for _, s := range d {
        h[int(s*10)]++
    }
    for _, c := range h {
        fmt.Println(strings.Repeat("*", c*205/int(n)))
    }
    fmt.Println()
}
