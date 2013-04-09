// implementation following algorithm described in
// http://www.cs.umd.edu/~samir/grant/cp.pdf
package main

import (
    "fmt"
    "math"
    "math/rand"
)

// number of points to search for closest pair
const n = 1e6

// size of bounding box for points.
// x and y will be random with uniform distribution in the range [0,scale).
const scale = 1.

// point struct
type xy struct {
    x, y float64 // coordinates
    key  int64   // an annotation used in the algorithm
}

// Euclidian distance
func d(p1, p2 xy) float64 {
    dx := p2.x - p1.x
    dy := p2.y - p1.y
    return math.Sqrt(dx*dx + dy*dy)
}

func main() {
    points := make([]xy, n)
    for i := range points {
        points[i] = xy{rand.Float64(), rand.Float64() * scale, 0}
    }
    p1, p2 := closestPair(points)
    fmt.Println(p1, p2)
    fmt.Println("distance:", d(p1, p2))
}

func closestPair(s []xy) (p1, p2 xy) {
    if len(s) < 2 {
        panic("2 points required")
    }
    var dxi float64
    // step 0
    for s1, i := s, 1; ; i++ {
        // step 1: compute min distance to a random point
        // (for the case of random data, it's enough to just try
        // to pick a different point)
        rp := i % len(s1)
        xi := s1[rp]
        dxi = 2 * scale
        for p, xn := range s1 {
            if p != rp {
                if dq := d(xi, xn); dq < dxi {
                    dxi = dq
                }
            }
        }

        // step 2: filter
        invB := 3 / dxi             // b is size of a mesh cell
        mx := int64(scale*invB) + 1 // mx is number of cells along a side
        // construct map as a histogram:
        // key is index into mesh.  value is count of points in cell
        hm := make(map[int64]int)
        for ip, p := range s1 {
            key := int64(p.x*invB)*mx + int64(p.y*invB)
            s1[ip].key = key
            hm[key]++
        }
        // construct s2 = s1 less the points without neighbors
        var s2 []xy
        nx := []int64{-mx - 1, -mx, -mx + 1, -1, 0, 1, mx - 1, mx, mx + 1}
        for i, p := range s1 {
            nn := 0
            for _, ofs := range nx {
                nn += hm[p.key+ofs]
                if nn > 1 {
                    s2 = append(s2, s1[i])
                    break
                }
            }
        }

        // step 3: done?
        if len(s2) == 0 {
            break
        }
        s1 = s2
    }
    // step 4: compute answer from approximation
    invB := 1 / dxi
    mx := int64(scale*invB) + 1
    hm := make(map[int64][]int)
    for i, p := range s {
        key := int64(p.x*invB)*mx + int64(p.y*invB)
        s[i].key = key
        hm[key] = append(hm[key], i)
    }
    nx := []int64{-mx - 1, -mx, -mx + 1, -1, 0, 1, mx - 1, mx, mx + 1}
    var min = scale * 2
    for ip, p := range s {
        for _, ofs := range nx {
            for _, iq := range hm[p.key+ofs] {
                if ip != iq {
                    if d1 := d(p, s[iq]); d1 < min {
                        min = d1
                        p1, p2 = p, s[iq]
                    }
                }
            }
        }
    }
    return p1, p2
}
