package main

import (
    "fmt"
    "math"
)

const eps = 1e-14 // say

type point struct{ x, y float64 }

func (p point) String() string {
    // hack to get rid of negative zero
    // compiler treats 0 and -0 as being same
    if p.x == 0 {
        p.x = 0
    }
    if p.y == 0 {
        p.y = 0
    }
    return fmt.Sprintf("(%g, %g)", p.x, p.y)
}

func sq(x float64) float64 { return x * x }

// Returns the intersection points (if any) of a circle, center 'cp' with radius 'r',
// and either an infinite line containing the points 'p1' and 'p2'
// or a segment drawn between those points.
func intersects(p1, p2, cp point, r float64, segment bool) []point {
    var res []point
    x0, y0 := cp.x, cp.y
    x1, y1 := p1.x, p1.y
    x2, y2 := p2.x, p2.y
    A := y2 - y1
    B := x1 - x2
    C := x2*y1 - x1*y2
    a := sq(A) + sq(B)
    var b, c float64
    var bnz = true
    if math.Abs(B) >= eps { // if B isn't zero or close to it
        b = 2 * (A*C + A*B*y0 - sq(B)*x0)
        c = sq(C) + 2*B*C*y0 - sq(B)*(sq(r)-sq(x0)-sq(y0))
    } else {
        b = 2 * (B*C + A*B*x0 - sq(A)*y0)
        c = sq(C) + 2*A*C*x0 - sq(A)*(sq(r)-sq(x0)-sq(y0))
        bnz = false
    }
    d := sq(b) - 4*a*c // discriminant
    if d < 0 {
        // line & circle don't intersect
        return res
    }

    // checks whether a point is within a segment
    within := func(x, y float64) bool {
        d1 := math.Sqrt(sq(x2-x1) + sq(y2-y1)) // distance between end-points
        d2 := math.Sqrt(sq(x-x1) + sq(y-y1))   // distance from point to one end
        d3 := math.Sqrt(sq(x2-x) + sq(y2-y))   // distance from point to other end
        delta := d1 - d2 - d3
        return math.Abs(delta) < eps // true if delta is less than a small tolerance
    }

    var x, y float64
    fx := func() float64 { return -(A*x + C) / B }
    fy := func() float64 { return -(B*y + C) / A }
    rxy := func() {
        if !segment || within(x, y) {
            res = append(res, point{x, y})
        }
    }

    if d == 0 {
        // line is tangent to circle, so just one intersect at most
        if bnz {
            x = -b / (2 * a)
            y = fx()
            rxy()
        } else {
            y = -b / (2 * a)
            x = fy()
            rxy()
        }
    } else {
        // two intersects at most
        d = math.Sqrt(d)
        if bnz {
            x = (-b + d) / (2 * a)
            y = fx()
            rxy()
            x = (-b - d) / (2 * a)
            y = fx()
            rxy()
        } else {
            y = (-b + d) / (2 * a)
            x = fy()
            rxy()
            y = (-b - d) / (2 * a)
            x = fy()
            rxy()
        }
    }
    return res
}

func main() {
    cp := point{3, -5}
    r := 3.0
    fmt.Println("The intersection points (if any) between:")
    fmt.Println("\n  A circle, center (3, -5) with radius 3, and:")
    fmt.Println("\n    a line containing the points (-10, 11) and (10, -9) is/are:")
    fmt.Println("     ", intersects(point{-10, 11}, point{10, -9}, cp, r, false))
    fmt.Println("\n    a segment starting at (-10, 11) and ending at (-11, 12) is/are")
    fmt.Println("     ", intersects(point{-10, 11}, point{-11, 12}, cp, r, true))
    fmt.Println("\n    a horizontal line containing the points (3, -2) and (7, -2) is/are:")
    fmt.Println("     ", intersects(point{3, -2}, point{7, -2}, cp, r, false))
    cp = point{0, 0}
    r = 4.0
    fmt.Println("\n  A circle, center (0, 0) with radius 4, and:")
    fmt.Println("\n    a vertical line containing the points (0, -3) and (0, 6) is/are:")
    fmt.Println("     ", intersects(point{0, -3}, point{0, 6}, cp, r, false))
    fmt.Println("\n    a vertical segment starting at (0, -3) and ending at (0, 6) is/are:")
    fmt.Println("     ", intersects(point{0, -3}, point{0, 6}, cp, r, true))
    cp = point{4, 2}
    r = 5.0
    fmt.Println("\n  A circle, center (4, 2) with radius 5, and:")
    fmt.Println("\n    a line containing the points (6, 3) and (10, 7) is/are:")
    fmt.Println("     ", intersects(point{6, 3}, point{10, 7}, cp, r, false))
    fmt.Println("\n    a segment starting at (7, 4) and ending at (11, 8) is/are:")
    fmt.Println("     ", intersects(point{7, 4}, point{11, 8}, cp, r, true))
    cp = point{10, 10}
    r = 5.0
    fmt.Println("\n  A circle, center (10, 10) with radius 5, and:")
    fmt.Println("\n    a vertical line containing the points (5, 0) and (5, 20) is/are:")
    fmt.Println("     ", intersects(point{5, 0}, point{5, 20}, cp, r, false))
    fmt.Println("\n    a horizontal segment starting at (-5, 10) and ending at (5, 10) is/are:")
    fmt.Println("     ", intersects(point{-5, 10}, point{5, 10}, cp, r, true))
}
