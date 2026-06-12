package main

import "fmt"

type Vector2 struct {
    x, y float64
}

type Projection struct {
    min, max float64
}

type Rectangle struct {
    x, y, w, h float64
}

func (v Vector2) dot(other Vector2) float64 {
    return v.x*other.x + v.y*other.y
}

/* In the following a polygon is represented as a slice of vertices
   and a vertex by a pair of x, y coordinates in the plane. */

func getAxes(poly [][2]float64) []Vector2 {
    axes := make([]Vector2, len(poly))
    for i := 0; i < len(poly); i++ {
        vertex1 := poly[i]
        j := i + 1
        if i+1 == len(poly) {
            j = 0
        }
        vertex2 := poly[j]
        vector1 := Vector2{vertex1[0], vertex1[1]}
        vector2 := Vector2{vertex2[0], vertex2[1]}
        edge := Vector2{vector1.x - vector2.x, vector1.y - vector2.y}
        axes[i] = Vector2{-edge.y, edge.x}
    }
    return axes
}

func projectOntoAxis(poly [][2]float64, axis Vector2) Projection {
    vertex0 := poly[0]
    vector0 := Vector2{vertex0[0], vertex0[1]}
    min := axis.dot(vector0)
    max := min
    for i := 1; i < len(poly); i++ {
        vertex := poly[i]
        vector := Vector2{vertex[0], vertex[1]}
        p := axis.dot(vector)
        if p < min {
            min = p
        } else if p > max {
            max = p
        }
    }
    return Projection{min, max}
}

func projectionsOverlap(proj1, proj2 Projection) bool {
    if proj1.max < proj2.min {
        return false
    }
    if proj2.max < proj1.min {
        return false
    }
    return true
}

func rectToPolygon(r Rectangle) [][2]float64 {
    return [][2]float64{{r.x, r.y}, {r.x, r.y + r.h}, {r.x + r.w, r.y + r.h}, {r.x + r.w, r.y}}
}

func polygonOverlapsRect(poly1 [][2]float64, rect Rectangle) bool {
    // Convert 'rect' struct into polygon form.
    poly2 := rectToPolygon(rect)
    axes1 := getAxes(poly1)
    axes2 := getAxes(poly2)
    for _, axes := range [][]Vector2{axes1, axes2} {
        for _, axis := range axes {
            proj1 := projectOntoAxis(poly1, axis)
            proj2 := projectOntoAxis(poly2, axis)
            if !projectionsOverlap(proj1, proj2) {
                return false
            }
        }
    }
    return true
}

func main() {
    poly := [][2]float64{{0, 0}, {0, 2}, {1, 4}, {2, 2}, {2, 0}}
    rect1 := Rectangle{4, 0, 2, 2}
    rect2 := Rectangle{1, 0, 8, 2}
    fmt.Println("poly  = ", poly)
    fmt.Println("rect1 = ", rect1, " => ", rectToPolygon(rect1))
    fmt.Println("rect2 = ", rect2, " => ", rectToPolygon(rect2))
    fmt.Println()
    fmt.Println("poly and rect1 overlap?", polygonOverlapsRect(poly, rect1))
    fmt.Println("poly and rect2 overlap?", polygonOverlapsRect(poly, rect2))
}
