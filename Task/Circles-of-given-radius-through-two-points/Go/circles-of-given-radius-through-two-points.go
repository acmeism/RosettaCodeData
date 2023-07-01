package main

import (
    "fmt"
    "math"
)

var (
    Two  = "Two circles."
    R0   = "R==0.0 does not describe circles."
    Co   = "Coincident points describe an infinite number of circles."
    CoR0 = "Coincident points with r==0.0 describe a degenerate circle."
    Diam = "Points form a diameter and describe only a single circle."
    Far  = "Points too far apart to form circles."
)

type point struct{ x, y float64 }

func circles(p1, p2 point, r float64) (c1, c2 point, Case string) {
    if p1 == p2 {
        if r == 0 {
            return p1, p1, CoR0
        }
        Case = Co
        return
    }
    if r == 0 {
        return p1, p2, R0
    }
    dx := p2.x - p1.x
    dy := p2.y - p1.y
    q := math.Hypot(dx, dy)
    if q > 2*r {
        Case = Far
        return
    }
    m := point{(p1.x + p2.x) / 2, (p1.y + p2.y) / 2}
    if q == 2*r {
        return m, m, Diam
    }
    d := math.Sqrt(r*r - q*q/4)
    ox := d * dx / q
    oy := d * dy / q
    return point{m.x - oy, m.y + ox}, point{m.x + oy, m.y - ox}, Two
}

var td = []struct {
    p1, p2 point
    r      float64
}{
    {point{0.1234, 0.9876}, point{0.8765, 0.2345}, 2.0},
    {point{0.0000, 2.0000}, point{0.0000, 0.0000}, 1.0},
    {point{0.1234, 0.9876}, point{0.1234, 0.9876}, 2.0},
    {point{0.1234, 0.9876}, point{0.8765, 0.2345}, 0.5},
    {point{0.1234, 0.9876}, point{0.1234, 0.9876}, 0.0},
}

func main() {
    for _, tc := range td {
        fmt.Println("p1: ", tc.p1)
        fmt.Println("p2: ", tc.p2)
        fmt.Println("r: ", tc.r)
        c1, c2, Case := circles(tc.p1, tc.p2, tc.r)
        fmt.Println("  ", Case)
        switch Case {
        case CoR0, Diam:
            fmt.Println("   Center: ", c1)
        case Two:
            fmt.Println("   Center 1: ", c1)
            fmt.Println("   Center 2: ", c2)
        }
        fmt.Println()
    }
}
