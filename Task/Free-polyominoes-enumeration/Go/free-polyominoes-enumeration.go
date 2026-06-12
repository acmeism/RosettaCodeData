package main

import (
    "fmt"
    "sort"
)

type point struct{ x, y int }
type polyomino []point
type pointset map[point]bool

func (p point) rotate90() point  { return point{p.y, -p.x} }
func (p point) rotate180() point { return point{-p.x, -p.y} }
func (p point) rotate270() point { return point{-p.y, p.x} }
func (p point) reflect() point   { return point{-p.x, p.y} }

func (p point) String() string { return fmt.Sprintf("(%d, %d)", p.x, p.y) }

// All four points in Von Neumann neighborhood
func (p point) contiguous() polyomino {
    return polyomino{point{p.x - 1, p.y}, point{p.x + 1, p.y},
        point{p.x, p.y - 1}, point{p.x, p.y + 1}}
}

// Finds the min x and y coordinates of a Polyomino.
func (po polyomino) minima() (int, int) {
    minx := po[0].x
    miny := po[0].y
    for i := 1; i < len(po); i++ {
        if po[i].x < minx {
            minx = po[i].x
        }
        if po[i].y < miny {
            miny = po[i].y
        }
    }
    return minx, miny
}

func (po polyomino) translateToOrigin() polyomino {
    minx, miny := po.minima()
    res := make(polyomino, len(po))
    for i, p := range po {
        res[i] = point{p.x - minx, p.y - miny}
    }
    sort.Slice(res, func(i, j int) bool {
        return res[i].x < res[j].x || (res[i].x == res[j].x && res[i].y < res[j].y)
    })
    return res
}

// All the plane symmetries of a rectangular region.
func (po polyomino) rotationsAndReflections() []polyomino {
    rr := make([]polyomino, 8)
    for i := 0; i < 8; i++ {
        rr[i] = make(polyomino, len(po))
    }
    copy(rr[0], po)
    for j := 0; j < len(po); j++ {
        rr[1][j] = po[j].rotate90()
        rr[2][j] = po[j].rotate180()
        rr[3][j] = po[j].rotate270()
        rr[4][j] = po[j].reflect()
        rr[5][j] = po[j].rotate90().reflect()
        rr[6][j] = po[j].rotate180().reflect()
        rr[7][j] = po[j].rotate270().reflect()
    }
    return rr
}

func (po polyomino) canonical() polyomino {
    rr := po.rotationsAndReflections()
    minr := rr[0].translateToOrigin()
    mins := minr.String()
    for i := 1; i < 8; i++ {
        r := rr[i].translateToOrigin()
        s := r.String()
        if s < mins {
            minr = r
            mins = s
        }
    }
    return minr
}

func (po polyomino) String() string {
    return fmt.Sprintf("%v", []point(po))
}

func (po polyomino) toPointset() pointset {
    pset := make(pointset, len(po))
    for _, p := range po {
        pset[p] = true
    }
    return pset
}

// Finds all distinct points that can be added to a Polyomino.
func (po polyomino) newPoints() polyomino {
    pset := po.toPointset()
    m := make(pointset)
    for _, p := range po {
        pts := p.contiguous()
        for _, pt := range pts {
            if !pset[pt] {
                m[pt] = true // using an intermediate set is about 15% faster!
            }
        }
    }
    poly := make(polyomino, 0, len(m))
    for k := range m {
        poly = append(poly, k)
    }
    return poly
}

func (po polyomino) newPolys() []polyomino {
    pts := po.newPoints()
    res := make([]polyomino, len(pts))
    for i, pt := range pts {
        poly := make(polyomino, len(po))
        copy(poly, po)
        poly = append(poly, pt)
        res[i] = poly.canonical()
    }
    return res
}

var monomino = polyomino{point{0, 0}}
var monominoes = []polyomino{monomino}

// Generates polyominoes of rank n recursively.
func rank(n int) []polyomino {
    switch {
    case n < 0:
        panic("n cannot be negative. Program terminated.")
    case n == 0:
        return []polyomino{}
    case n == 1:
        return monominoes
    default:
        r := rank(n - 1)
        m := make(map[string]bool)
        var polys []polyomino
        for _, po := range r {
            for _, po2 := range po.newPolys() {
                if s := po2.String(); !m[s] {
                    polys = append(polys, po2)
                    m[s] = true
                }
            }
        }
        sort.Slice(polys, func(i, j int) bool {
            return polys[i].String() < polys[j].String()
        })
        return polys
    }
}

func main() {
    const n = 5
    fmt.Printf("All free polyominoes of rank %d:\n\n", n)
    for _, poly := range rank(n) {
        for _, pt := range poly {
            fmt.Printf("%s ", pt)
        }
        fmt.Println()
    }
    const k = 10
    fmt.Printf("\nNumber of free polyominoes of ranks 1 to %d:\n", k)
    for i := 1; i <= k; i++ {
        fmt.Printf("%d ", len(rank(i)))
    }
    fmt.Println()
}
