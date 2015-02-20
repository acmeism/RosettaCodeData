package main

import (
    "fmt"
    "math"
    "math/rand"
    "strings"
)

func main() {
    bigSample(1e7)
}

func bigSample(n int64) {
    sum, ssq, h := reduce(0, n)
    // compute final statistics and output as above
    fmt.Println(n, "numbers")
    m := sum / float64(n)
    fmt.Println("Mean:  ", m)
    fmt.Println("Stddev:", math.Sqrt(ssq/float64(n)-m*m))
    for _, c := range h {
        fmt.Println(strings.Repeat("*", c*205/int(n)))
    }
    fmt.Println()
}

const threshold = 1e6

func reduce(start, end int64) (sum, ssq float64, h []int) {
    n := end - start
    if n < threshold {
        d := getSegment(start, end)
        return computeSegment(d)
    }
    // map to two sub problems
    half := (start + end) / 2
    sum1, ssq1, h1 := reduce(start, half)
    sum2, ssq2, h2 := reduce(half, end)
    // combine results
    for i, c := range h2 {
        h1[i] += c
    }
    return sum1 + sum2, ssq1 + ssq2, h1
}

func getSegment(start, end int64) []float64 {
    d := make([]float64, end-start)
    for i := range d {
        d[i] = rand.Float64()
    }
    return d
}

func computeSegment(d []float64) (sum, ssq float64, h []int) {
    for _, s := range d {
        sum += s
        ssq += s * s
    }
    h = make([]int, 10)
    for _, s := range d {
        h[int(s*10)]++
    }
    return
}
