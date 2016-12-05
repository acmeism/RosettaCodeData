package main

import (
    "bytes"
    "fmt"
    "math/rand"
    "time"
)

const (
    nPts = 100
    rMin = 10
    rMax = 15
)

func main() {
    rand.Seed(time.Now().Unix())
    span := rMax + 1 + rMax
    rows := make([][]byte, span)
    for r := range rows {
        rows[r] = bytes.Repeat([]byte{' '}, span*2)
    }
    u := 0 // count unique points
    min2 := rMin * rMin
    max2 := rMax * rMax
    for n := 0; n < nPts; {
        x := rand.Intn(span) - rMax
        y := rand.Intn(span) - rMax
        // x, y is the generated coordinate pair
        rs := x*x + y*y
        if rs < min2 || rs > max2 {
            continue
        }
        n++ // count pair as meeting condition
        r := y + rMax
        c := (x + rMax) * 2
        if rows[r][c] == ' ' {
            rows[r][c] = '*'
            u++
        }
    }
    for _, row := range rows {
        fmt.Println(string(row))
    }
    fmt.Println(u, "unique points")
}
