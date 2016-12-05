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
    var poss []struct{ x, y int }
    min2 := rMin * rMin
    max2 := rMax * rMax
    for y := -rMax; y <= rMax; y++ {
        for x := -rMax; x <= rMax; x++ {
            if r2 := x*x + y*y; r2 >= min2 && r2 <= max2 {
                poss = append(poss, struct{ x, y int }{x, y})
            }
        }
    }
    fmt.Println(len(poss), "possible points")
    span := rMax + 1 + rMax
    rows := make([][]byte, span)
    for r := range rows {
        rows[r] = bytes.Repeat([]byte{' '}, span*2)
    }
    u := 0
    for n := 0; n < nPts; n++ {
        i := rand.Intn(len(poss))
        r := poss[i].y + rMax
        c := (poss[i].x + rMax) * 2
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
