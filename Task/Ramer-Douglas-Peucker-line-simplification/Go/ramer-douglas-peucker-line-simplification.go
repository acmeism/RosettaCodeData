package main

import (
    "fmt"
    "math"
)

type point struct{ x, y float64 }

func RDP(l []point, ε float64) []point {
    x := 0
    dMax := -1.
    last := len(l) - 1
    p1 := l[0]
    p2 := l[last]
    x21 := p2.x - p1.x
    y21 := p2.y - p1.y
    for i, p := range l[1:last] {
        if d := math.Abs(y21*p.x - x21*p.y + p2.x*p1.y - p2.y*p1.x); d > dMax {
            x = i + 1
            dMax = d
        }
    }
    if dMax > ε {
        return append(RDP(l[:x+1], ε), RDP(l[x:], ε)[1:]...)
    }
    return []point{l[0], l[len(l)-1]}
}

func main() {
    fmt.Println(RDP([]point{{0, 0}, {1, 0.1}, {2, -0.1},
        {3, 5}, {4, 6}, {5, 7}, {6, 8.1}, {7, 9}, {8, 9}, {9, 9}}, 1))
}
