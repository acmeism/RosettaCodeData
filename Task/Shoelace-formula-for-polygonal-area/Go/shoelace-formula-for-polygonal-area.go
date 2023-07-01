package main

import "fmt"

type point struct{ x, y float64 }

func shoelace(pts []point) float64 {
    sum := 0.
    p0 := pts[len(pts)-1]
    for _, p1 := range pts {
        sum += p0.y*p1.x - p0.x*p1.y
        p0 = p1
    }
    return sum / 2
}

func main() {
    fmt.Println(shoelace([]point{{3, 4}, {5, 11}, {12, 8}, {9, 5}, {5, 6}}))
}
