/* The control points of a planar quadratic Bézier curve form a
   triangle--called the "control polygon"--that completely contains
   the curve. Furthermore, the rectangle formed by the minimum and
   maximum x and y values of the control polygon completely contain
   the polygon, and therefore also the curve.

   Thus a simple method for narrowing down where intersections might
   be is: subdivide both curves until you find "small enough" regions
   where these rectangles overlap.
*/

package main

import (
    "fmt"
    "log"
    "math"
)

type point struct {
    x, y float64
}

type quadSpline struct { // Non-parametric spline.
    c0, c1, c2 float64
}

type quadCurve struct { // Planar parametric spline.
    x, y quadSpline
}

// Subdivision by de Casteljau's algorithm.
func subdivideQuadSpline(q quadSpline, t float64, u, v *quadSpline) {
    s := 1.0 - t
    c0 := q.c0
    c1 := q.c1
    c2 := q.c2
    u.c0 = c0
    v.c2 = c2
    u.c1 = s*c0 + t*c1
    v.c1 = s*c1 + t*c2
    u.c2 = s*u.c1 + t*v.c1
    v.c0 = u.c2
}

func subdivideQuadCurve(q quadCurve, t float64, u, v *quadCurve) {
    subdivideQuadSpline(q.x, t, &u.x, &v.x)
    subdivideQuadSpline(q.y, t, &u.y, &v.y)
}

// It is assumed that xa0 <= xa1, ya0 <= ya1, xb0 <= xb1, and yb0 <= yb1.
func rectsOverlap(xa0, ya0, xa1, ya1, xb0, yb0, xb1, yb1 float64) bool {
    return (xb0 <= xa1 && xa0 <= xb1 && yb0 <= ya1 && ya0 <= yb1)
}

func max3(x, y, z float64) float64 { return math.Max(math.Max(x, y), z) }
func min3(x, y, z float64) float64 { return math.Min(math.Min(x, y), z) }

// This accepts the point as an intersection if the boxes are small enough.
func testIntersect(p, q quadCurve, tol float64, exclude, accept *bool, intersect *point) {
    pxmin := min3(p.x.c0, p.x.c1, p.x.c2)
    pymin := min3(p.y.c0, p.y.c1, p.y.c2)
    pxmax := max3(p.x.c0, p.x.c1, p.x.c2)
    pymax := max3(p.y.c0, p.y.c1, p.y.c2)

    qxmin := min3(q.x.c0, q.x.c1, q.x.c2)
    qymin := min3(q.y.c0, q.y.c1, q.y.c2)
    qxmax := max3(q.x.c0, q.x.c1, q.x.c2)
    qymax := max3(q.y.c0, q.y.c1, q.y.c2)

    *exclude = true
    *accept = false
    if rectsOverlap(pxmin, pymin, pxmax, pymax, qxmin, qymin, qxmax, qymax) {
        *exclude = false
        xmin := math.Max(pxmin, qxmin)
        xmax := math.Min(pxmax, pxmax)
        if xmax < xmin {
            log.Fatalf("Assertion failure: %f < %f\n", xmax, xmin)
        }
        if xmax-xmin <= tol {
            ymin := math.Max(pymin, qymin)
            ymax := math.Min(pymax, qymax)
            if ymax < ymin {
                log.Fatalf("Assertion failure: %f < %f\n", ymax, ymin)
            }
            if ymax-ymin <= tol {
                *accept = true
                intersect.x = 0.5*xmin + 0.5*xmax
                intersect.y = 0.5*ymin + 0.5*ymax
            }
        }
    }
}

func seemsToBeDuplicate(intersects []point, xy point, spacing float64) bool {
    seemsToBeDup := false
    i := 0
    for !seemsToBeDup && i != len(intersects) {
        pt := intersects[i]
        seemsToBeDup = math.Abs(pt.x-xy.x) < spacing && math.Abs(pt.y-xy.y) < spacing
        i++
    }
    return seemsToBeDup
}

func findIntersects(p, q quadCurve, tol, spacing float64) []point {
    var intersects []point
    type workset struct {
        p, q quadCurve
    }
    workload := []workset{workset{p, q}}

    // Quit looking after having emptied the workload.
    for len(workload) > 0 {
        l := len(workload)
        work := workload[l-1]
        workload = workload[0 : l-1]
        var exclude, accept bool
        intersect := point{0, 0}
        testIntersect(work.p, work.q, tol, &exclude, &accept, &intersect)
        if accept {
            // To avoid detecting the same intersection twice, require some
            // space between intersections.
            if !seemsToBeDuplicate(intersects, intersect, spacing) {
                intersects = append(intersects, intersect)
            }
        } else if !exclude {
            var p0, p1, q0, q1 quadCurve
            subdivideQuadCurve(work.p, 0.5, &p0, &p1)
            subdivideQuadCurve(work.q, 0.5, &q0, &q1)
            workload = append(workload, workset{p0, q0})
            workload = append(workload, workset{p0, q1})
            workload = append(workload, workset{p1, q0})
            workload = append(workload, workset{p1, q1})
        }
    }
    return intersects
}

func main() {
    var p, q quadCurve
    p.x = quadSpline{-1.0, 0.0, 1.0}
    p.y = quadSpline{0.0, 10.0, 0.0}
    q.x = quadSpline{2.0, -8.0, 2.0}
    q.y = quadSpline{1.0, 2.0, 3.0}
    tol := 0.0000001
    spacing := tol * 10
    intersects := findIntersects(p, q, tol, spacing)
    for _, intersect := range intersects {
        fmt.Printf("(% f, %f)\n", intersect.x, intersect.y)
    }
}
