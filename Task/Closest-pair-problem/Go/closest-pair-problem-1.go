package main

import (
    "fmt"
    "math"
    "math/rand"
    "time"
)

type xy struct {
    x, y float64
}

const n = 1000
const scale = 100.

func d(p1, p2 xy) float64 {
    return math.Hypot(p2.x-p1.x, p2.y-p1.y)
}

func main() {
    rand.Seed(time.Now().Unix())
    points := make([]xy, n)
    for i := range points {
        points[i] = xy{rand.Float64() * scale, rand.Float64() * scale}
    }
    p1, p2 := closestPair(points)
    fmt.Println(p1, p2)
    fmt.Println("distance:", d(p1, p2))
}

func closestPair(points []xy) (p1, p2 xy) {
    if len(points) < 2 {
        panic("at least two points expected")
    }
    min := 2 * scale
    for i, q1 := range points[:len(points)-1] {
        for _, q2 := range points[i+1:] {
            if dq := d(q1, q2); dq < min {
                p1, p2 = q1, q2
                min = dq
            }
        }
    }
    return
}
