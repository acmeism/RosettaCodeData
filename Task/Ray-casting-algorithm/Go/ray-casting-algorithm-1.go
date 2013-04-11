package main

import (
    "math"
    "fmt"
)

type xy struct {
    x, y float64
}

type seg struct {
    p1, p2 xy
}

type poly struct {
    name  string
    sides []seg
}

func inside(pt xy, pg poly) (i bool) {
    for _, side := range pg.sides {
        if rayIntersectsSegment(pt, side) {
            i = !i
        }
    }
    return
}

func rayIntersectsSegment(p xy, s seg) bool {
    var a, b xy
    if s.p1.y < s.p2.y {
        a, b = s.p1, s.p2
    } else {
        a, b = s.p2, s.p1
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

var (
    p1  = xy{0, 0}
    p2  = xy{10, 0}
    p3  = xy{10, 10}
    p4  = xy{0, 10}
    p5  = xy{2.5, 2.5}
    p6  = xy{7.5, 2.5}
    p7  = xy{7.5, 7.5}
    p8  = xy{2.5, 7.5}
    p9  = xy{0, 5}
    p10 = xy{10, 5}
    p11 = xy{3, 0}
    p12 = xy{7, 0}
    p13 = xy{7, 10}
    p14 = xy{3, 10}
)

var tpg = []poly{
    {"square", []seg{{p1, p2}, {p2, p3}, {p3, p4}, {p4, p1}}},
    {"square hole", []seg{{p1, p2}, {p2, p3}, {p3, p4}, {p4, p1},
        {p5, p6}, {p6, p7}, {p7, p8}, {p8, p5}}},
    {"strange", []seg{{p1, p5},
        {p5, p4}, {p4, p8}, {p8, p7}, {p7, p3}, {p3, p2}, {p2, p5}}},
    {"exagon", []seg{{p11, p12}, {p12, p10}, {p10, p13},
        {p13, p14}, {p14, p9}, {p9, p11}}},
}

var tpt = []xy{{5, 5}, {5, 8}, {-10, 5}, {0, 5}, {10, 5}, {8, 5}, {10, 10}}

func main() {
    for _, pg := range tpg {
        fmt.Printf("%s:\n", pg.name)
        for _, pt := range tpt {
            fmt.Println(pt, inside(pt, pg))
        }
    }
}
