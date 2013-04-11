package main

import (
    "math"
    "fmt"
)

type xy struct {
    x, y float64
}

type closedPoly struct {
    name string
    vert []xy
}

func inside(pt xy, pg closedPoly) bool {
    if len(pg.vert) < 3 {
        return false
    }
    in := rayIntersectsSegment(pt, pg.vert[len(pg.vert)-1], pg.vert[0])
    for i := 1; i < len(pg.vert); i++ {
        if rayIntersectsSegment(pt, pg.vert[i-1], pg.vert[i]) {
            in = !in
        }
    }
    return in
}

func rayIntersectsSegment(p, a, b xy) bool {
    if a.y > b.y {
        a, b = b, a
    }
    for p.y == a.y || p.y == b.y {
        p.y = math.Nextafter(p.y, math.Inf(1))
    }
    if p.y < a.y || p.y > b.y {
        return false
    }
    if a.x > b.x {
        if p.x > a.x {
            return false
        }
        if p.x < b.x {
            return true
        }
    } else {
        if p.x > b.x {
            return false
        }
        if p.x < a.x {
            return true
        }
    }
    return (p.y-a.y)/(p.x-a.x) >= (b.y-a.y)/(b.x-a.x)
}

var tpg = []closedPoly{
    {"square", []xy{{0, 0}, {10, 0}, {10, 10}, {0, 10}}},
    {"square hole", []xy{{0, 0}, {10, 0}, {10, 10}, {0, 10}, {0, 0},
        {2.5, 2.5}, {7.5, 2.5}, {7.5, 7.5}, {2.5, 7.5}, {2.5, 2.5}}},
    {"strange", []xy{{0, 0}, {2.5, 2.5}, {0, 10}, {2.5, 7.5}, {7.5, 7.5},
        {10, 10}, {10, 0}, {2.5, 2.5}}},
    {"exagon", []xy{{3, 0}, {7, 0}, {10, 5}, {7, 10}, {3, 10}, {0, 5}}},
}

var tpt = []xy{{1, 2}, {2, 1}}

func main() {
    for _, pg := range tpg {
        fmt.Printf("%s:\n", pg.name)
        for _, pt := range tpt {
            fmt.Println(pt, inside(pt, pg))
        }
    }
}
