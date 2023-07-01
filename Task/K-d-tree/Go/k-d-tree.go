// Implmentation following pseudocode from "An intoductory tutorial on kd-trees"
// by Andrew W. Moore, Carnegie Mellon University, PDF accessed from
// http://www.autonlab.org/autonweb/14665
package main

import (
    "fmt"
    "math"
    "math/rand"
    "sort"
    "time"
)

// point is a k-dimensional point.
type point []float64

// sqd returns the square of the euclidean distance.
func (p point) sqd(q point) float64 {
    var sum float64
    for dim, pCoord := range p {
        d := pCoord - q[dim]
        sum += d * d
    }
    return sum
}

// kdNode following field names in the paper.
// rangeElt would be whatever data is associated with the point.  we don't
// bother with it for this example.
type kdNode struct {
    domElt      point
    split       int
    left, right *kdNode
}

type kdTree struct {
    n      *kdNode
    bounds hyperRect
}

type hyperRect struct {
    min, max point
}

// Go slices are reference objects.  The data must be copied if you want
// to modify one without modifying the original.
func (hr hyperRect) copy() hyperRect {
    return hyperRect{append(point{}, hr.min...), append(point{}, hr.max...)}
}

// newKd constructs a kdTree from a list of points, also associating the
// bounds of the tree.  The bounds could be computed of course, but in this
// example we know them already.  The algorithm is table 6.3 in the paper.
func newKd(pts []point, bounds hyperRect) kdTree {
    var nk2 func([]point, int) *kdNode
    nk2 = func(exset []point, split int) *kdNode {
        if len(exset) == 0 {
            return nil
        }
        // pivot choosing procedure.  we find median, then find largest
        // index of points with median value.  this satisfies the
        // inequalities of steps 6 and 7 in the algorithm.
        sort.Sort(part{exset, split})
        m := len(exset) / 2
        d := exset[m]
        for m+1 < len(exset) && exset[m+1][split] == d[split] {
            m++
        }
        // next split
        s2 := split + 1
        if s2 == len(d) {
            s2 = 0
        }
        return &kdNode{d, split, nk2(exset[:m], s2), nk2(exset[m+1:], s2)}
    }
    return kdTree{nk2(pts, 0), bounds}
}

// a container type used for sorting.  it holds the points to sort and
// the dimension to use for the sort key.
type part struct {
    pts   []point
    dPart int
}

// satisfy sort.Interface
func (p part) Len() int { return len(p.pts) }
func (p part) Less(i, j int) bool {
    return p.pts[i][p.dPart] < p.pts[j][p.dPart]
}
func (p part) Swap(i, j int) { p.pts[i], p.pts[j] = p.pts[j], p.pts[i] }

// nearest.  find nearest neighbor.  return values are:
//    nearest neighbor--the point within the tree that is nearest p.
//    square of the distance to that point.
//    a count of the nodes visited in the search.
func (t kdTree) nearest(p point) (best point, bestSqd float64, nv int) {
    return nn(t.n, p, t.bounds, math.Inf(1))
}

// algorithm is table 6.4 from the paper, with the addition of counting
// the number nodes visited.
func nn(kd *kdNode, target point, hr hyperRect,
    maxDistSqd float64) (nearest point, distSqd float64, nodesVisited int) {
    if kd == nil {
        return nil, math.Inf(1), 0
    }
    nodesVisited++
    s := kd.split
    pivot := kd.domElt
    leftHr := hr.copy()
    rightHr := hr.copy()
    leftHr.max[s] = pivot[s]
    rightHr.min[s] = pivot[s]
    targetInLeft := target[s] <= pivot[s]
    var nearerKd, furtherKd *kdNode
    var nearerHr, furtherHr hyperRect
    if targetInLeft {
        nearerKd, nearerHr = kd.left, leftHr
        furtherKd, furtherHr = kd.right, rightHr
    } else {
        nearerKd, nearerHr = kd.right, rightHr
        furtherKd, furtherHr = kd.left, leftHr
    }
    var nv int
    nearest, distSqd, nv = nn(nearerKd, target, nearerHr, maxDistSqd)
    nodesVisited += nv
    if distSqd < maxDistSqd {
        maxDistSqd = distSqd
    }
    d := pivot[s] - target[s]
    d *= d
    if d > maxDistSqd {
        return
    }
    if d = pivot.sqd(target); d < distSqd {
        nearest = pivot
        distSqd = d
        maxDistSqd = distSqd
    }
    tempNearest, tempSqd, nv := nn(furtherKd, target, furtherHr, maxDistSqd)
    nodesVisited += nv
    if tempSqd < distSqd {
        nearest = tempNearest
        distSqd = tempSqd
    }
    return
}

func main() {
    rand.Seed(time.Now().Unix())
    kd := newKd([]point{{2, 3}, {5, 4}, {9, 6}, {4, 7}, {8, 1}, {7, 2}},
        hyperRect{point{0, 0}, point{10, 10}})
    showNearest("WP example data", kd, point{9, 2})
    kd = newKd(randomPts(3, 1000), hyperRect{point{0, 0, 0}, point{1, 1, 1}})
    showNearest("1000 random 3d points", kd, randomPt(3))
}

func randomPt(dim int) point {
    p := make(point, dim)
    for d := range p {
        p[d] = rand.Float64()
    }
    return p
}

func randomPts(dim, n int) []point {
    p := make([]point, n)
    for i := range p {
        p[i] = randomPt(dim)
    }
    return p
}

func showNearest(heading string, kd kdTree, p point) {
    fmt.Println()
    fmt.Println(heading)
    fmt.Println("point:           ", p)
    nn, ssq, nv := kd.nearest(p)
    fmt.Println("nearest neighbor:", nn)
    fmt.Println("distance:        ", math.Sqrt(ssq))
    fmt.Println("nodes visited:   ", nv)
}
