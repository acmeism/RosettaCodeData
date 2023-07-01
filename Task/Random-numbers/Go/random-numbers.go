package main

import (
    "fmt"
    "math"
    "math/rand"
    "strings"
    "time"
)

const mean = 1.0
const stdv = .5
const n = 1000

func main() {
    var list [n]float64
    rand.Seed(time.Now().UnixNano())
    for i := range list {
        list[i] = mean + stdv*rand.NormFloat64()
    }
    // show computed mean and stdv of list
    var s, sq float64
    for _, v := range list {
        s += v
    }
    cm := s / n
    for _, v := range list {
        d := v - cm
        sq += d * d
    }
    fmt.Printf("mean %.3f, stdv %.3f\n", cm, math.Sqrt(sq/(n-1)))
    // show histogram by hdiv divisions per stdv over +/-hrange stdv
    const hdiv = 3
    const hrange = 2
    var h [1 + 2*hrange*hdiv]int
    for _, v := range list {
        bin := hrange*hdiv + int(math.Floor((v-mean)/stdv*hdiv+.5))
        if bin >= 0 && bin < len(h) {
            h[bin]++
        }
    }
    const hscale = 10
    for _, c := range h {
        fmt.Println(strings.Repeat("*", (c+hscale/2)/hscale))
    }
}
