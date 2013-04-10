package main

import (
    "fmt"
    "math"
    "math/rand"
)

type xy struct {
    x, y float64
}

const n = 1000
const scale = 1.

func d(p1, p2 xy) float64 {
    dx := p2.x - p1.x
    dy := p2.y - p1.y
    return math.Sqrt(dx*dx + dy*dy)
}

func main() {
    points := make([]xy, n)
    for i := range points {
        points[i] = xy{rand.Float64(), rand.Float64() * scale}
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
