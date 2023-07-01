package main

import (
    "fmt"
    "math"
    "math/rand"
    "strings"
)

// Box-Muller
func norm2() (s, c float64) {
    r := math.Sqrt(-2 * math.Log(rand.Float64()))
    s, c = math.Sincos(2 * math.Pi * rand.Float64())
    return s * r, c * r
}

func main() {
    const (
        n     = 10000
        bins  = 12
        sig   = 3
        scale = 100
    )
    var sum, sumSq float64
    h := make([]int, bins)
    for i, accum := 0, func(v float64) {
        sum += v
        sumSq += v * v
        b := int((v + sig) * bins / sig / 2)
        if b >= 0 && b < bins {
            h[b]++
        }
    }; i < n/2; i++ {
        v1, v2 := norm2()
        accum(v1)
        accum(v2)
    }
    m := sum / n
    fmt.Println("mean:", m)
    fmt.Println("stddev:", math.Sqrt(sumSq/float64(n)-m*m))
    for _, p := range h {
        fmt.Println(strings.Repeat("*", p/scale))
    }
}
