package main

import (
    "fmt"
    "log"
    "math"
    "math/rand"
    "time"
)

type Point struct{ x, y float64 }

type Circle struct {
    c Point
    r float64
}

// string representation of a Point
func (p Point) String() string { return fmt.Sprintf("(%f, %f)", p.x, p.y) }

// returns the square of the distance between two points
func distSq(a, b Point) float64 {
    return (a.x-b.x)*(a.x-b.x) + (a.y-b.y)*(a.y-b.y)
}

// returns the center of a circle defined by 3 points
func getCircleCenter(bx, by, cx, cy float64) Point {
    b := bx*bx + by*by
    c := cx*cx + cy*cy
    d := bx*cy - by*cx
    return Point{(cy*b - by*c) / (2 * d), (bx*c - cx*b) / (2 * d)}
}

// returns whether a circle contains the point 'p'
func (ci Circle) contains(p Point) bool {
    return distSq(ci.c, p) <= ci.r*ci.r
}

// returns whether a circle contains a slice of points
func (ci Circle) encloses(ps []Point) bool {
    for _, p := range ps {
        if !ci.contains(p) {
            return false
        }
    }
    return true
}

// string representation of a Circle
func (ci Circle) String() string { return fmt.Sprintf("{%v, %f}", ci.c, ci.r) }

// returns a unique circle that intersects 3 points
func circleFrom3(a, b, c Point) Circle {
    i := getCircleCenter(b.x-a.x, b.y-a.y, c.x-a.x, c.y-a.y)
    i.x += a.x
    i.y += a.y
    return Circle{i, math.Sqrt(distSq(i, a))}
}

// returns smallest circle that intersects 2 points
func circleFrom2(a, b Point) Circle {
    c := Point{(a.x + b.x) / 2, (a.y + b.y) / 2}
    return Circle{c, math.Sqrt(distSq(a, b)) / 2}
}

// returns smallest enclosing circle for n <= 3
func secTrivial(rs []Point) Circle {
    size := len(rs)
    if size > 3 {
        log.Fatal("There shouldn't be more than 3 points.")
    }
    if size == 0 {
        return Circle{Point{0, 0}, 0}
    }
    if size == 1 {
        return Circle{rs[0], 0}
    }
    if size == 2 {
        return circleFrom2(rs[0], rs[1])
    }
    for i := 0; i < 2; i++ {
        for j := i + 1; j < 3; j++ {
            c := circleFrom2(rs[i], rs[j])
            if c.encloses(rs) {
                return c
            }
        }
    }
    return circleFrom3(rs[0], rs[1], rs[2])
}

// helper function for Welzl method
func welzlHelper(ps, rs []Point, n int) Circle {
    rc := make([]Point, len(rs))
    copy(rc, rs) // 'rs' passed by value so need to copy
    if n == 0 || len(rc) == 3 {
        return secTrivial(rc)
    }
    idx := rand.Intn(n)
    p := ps[idx]
    ps[idx], ps[n-1] = ps[n-1], p
    d := welzlHelper(ps, rc, n-1)
    if d.contains(p) {
        return d
    }
    rc = append(rc, p)
    return welzlHelper(ps, rc, n-1)
}

// applies the Welzl algorithm to find the SEC
func welzl(ps []Point) Circle {
    var pc = make([]Point, len(ps))
    copy(pc, ps)
    rand.Shuffle(len(pc), func(i, j int) {
        pc[i], pc[j] = pc[j], pc[i]
    })
    return welzlHelper(pc, []Point{}, len(pc))
}

func main() {
    rand.Seed(time.Now().UnixNano())
    tests := [][]Point{
        {Point{0, 0}, Point{0, 1}, Point{1, 0}},
        {Point{5, -2}, Point{-3, -2}, Point{-2, 5}, Point{1, 6}, Point{0, 2}},
    }
    for _, test := range tests {
        fmt.Println(welzl(test))
    }
}
