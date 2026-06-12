package main

import (
    "fmt"
    "math"
)

const (
    MAXN = 2500
    EPS  = 1e-8
)

// Globals
var (
    FAC        []*Facet
    pts        [][]*Vect
    TIME       int
    e          [2][MAXN]Edge
    vistimeArr [MAXN]int
    que        []int
    resfnew    []int
    resfdel    []int
    respt      []*Vect
)

// Vect represents a 3D point/vector
type Vect struct {
    x, y, z float64
    id      int
}

func (a *Vect) Sub(b *Vect) *Vect {
    return &Vect{a.x - b.x, a.y - b.y, a.z - b.z, 0}
}

func (a *Vect) Cross(b *Vect) *Vect {
    return &Vect{
        a.y*b.z - a.z*b.y,
        a.z*b.x - a.x*b.z,
        a.x*b.y - a.y*b.x,
        0,
    }
}

func (a *Vect) Dot(b *Vect) float64 {
    return a.x*b.x + a.y*b.y + a.z*b.z
}

func (a *Vect) Mag() float64 {
    return math.Sqrt(a.x*a.x + a.y*a.y + a.z*a.z)
}

func (a *Vect) Eq(b *Vect) bool {
    return eq(a.x, b.x) && eq(a.y, b.y) && eq(a.z, b.z)
}

// Line is the segment u->v
type Line struct {
    u, v *Vect
}

// Plane is defined by three points u, v, w
type Plane struct {
    u, v, w *Vect
}

// Normal vector of the plane
func (p *Plane) Normal() *Vect {
    return p.v.Sub(p.u).Cross(p.w.Sub(p.u))
}

// vecAt returns the i-th defining point of the plane (0=u,1=v,2=w)
func (p *Plane) vecAt(i int) *Vect {
    switch i {
    case 0:
        return p.u
    case 1:
        return p.v
    default:
        return p.w
    }
}

// vecID returns the id of the i-th plane point
func (p *Plane) vecID(i int) int {
    return p.vecAt(i).id
}

// Facet is a face in the hull
type Facet struct {
    n       [3]int // neighbor facet indices
    id      int
    vistime int
    isdel   bool
    p       Plane
}

// Edge on the horizon
type Edge struct {
    netid, facetid int
}

// ConvexHulls3d manages hull construction
type ConvexHulls3d struct {
    index       int
    surfacearea float64
}

// Basic floating comparisons
func eq(a, b float64) bool { return math.Abs(a-b) < EPS }
func gtr(a, b float64) bool { return a-b > EPS }
func Abs(x float64) float64 { if x < 0 { return -x }; return x }

// Distances
func distPointPlane(v *Vect, p Plane) float64 {
    num := v.Sub(p.u).Dot(p.Normal())
    den := p.Normal().Mag()
    return num / den
}
func distPointLine(v *Vect, f Line) float64 {
    d := v.Sub(f.u).Mag()
    if d == 0 {
        return 0
    }
    return f.v.Sub(f.u).Cross(v.Sub(f.u)).Mag() / f.v.Sub(f.u).Mag()
}
func distPointPoint(u, v *Vect) float64 {
    return u.Sub(v).Mag()
}
func isAbove(v *Vect, p Plane) bool {
    return gtr(v.Sub(p.u).Dot(p.Normal()), 0)
}

// Initialize globals
func preConvexHulls() {
    pts = append(pts, nil)      // reserve index 0
    FAC = append(FAC, &Facet{}) // dummy facet at 0
}

// DFS to accumulate area
func (h *ConvexHulls3d) dfsArea(nf int) {
    if FAC[nf].vistime == TIME {
        return
    }
    FAC[nf].vistime = TIME
    nrm := FAC[nf].p.Normal()
    h.surfacearea += nrm.Mag() / 2
    for i := 0; i < 3; i++ {
        h.dfsArea(FAC[nf].n[i])
    }
}

// GetSurfaceArea returns (and caches) the hull surface area
func (h *ConvexHulls3d) GetSurfaceArea() float64 {
    if gtr(h.surfacearea, 0) {
        return h.surfacearea
    }
    TIME++
    h.dfsArea(h.index)
    return h.surfacearea
}

// Recursively find the horizon around point p
func (h *ConvexHulls3d) getHorizon(f int, p *Vect, resfdel *[]int) int {
    if !isAbove(p, FAC[f].p) {
        return 0
    }
    if FAC[f].vistime == TIME {
        return -1
    }
    FAC[f].vistime = TIME
    FAC[f].isdel = true
    *resfdel = append(*resfdel, FAC[f].id)
    ret := -2
    for i := 0; i < 3; i++ {
        r := h.getHorizon(FAC[f].n[i], p, resfdel)
        if r == 0 {
            a := FAC[f].p.vecID(i)
            b := FAC[f].p.vecID((i + 1) % 3)
            for j, pt := range []int{a, b} {
                if vistimeArr[pt] != TIME {
                    vistimeArr[pt] = TIME
                    e[0][pt] = Edge{netid: []int{b, a}[j], facetid: FAC[f].n[i]}
                } else {
                    e[1][pt] = Edge{netid: []int{b, a}[j], facetid: FAC[f].n[i]}
                }
            }
            ret = a
        } else if r != -1 && r != -2 {
            ret = r
        }
    }
    return ret
}

// Build the initial tetrahedron
func getStart(point []*Vect, totp int) *ConvexHulls3d {
    var pt [6]*Vect
    var s [4]*Vect
    for i := range pt {
        pt[i] = point[1]
    }
    // pick extreme coords
    for i := 1; i <= totp; i++ {
        v := point[i]
        if gtr(v.x, pt[0].x) {
            pt[0] = v
        }
        if gtr(pt[1].x, v.x) {
            pt[1] = v
        }
        if gtr(v.y, pt[2].y) {
            pt[2] = v
        }
        if gtr(pt[3].y, v.y) {
            pt[3] = v
        }
        if gtr(v.z, pt[4].z) {
            pt[4] = v
        }
        if gtr(pt[5].z, v.z) {
            pt[5] = v
        }
    }
    // take furthest pair
    s[0], s[1] = pt[0], pt[1]
    for i := 0; i < 6; i++ {
        for j := i + 1; j < 6; j++ {
            d := distPointPoint(pt[i], pt[j])
            if gtr(d, distPointPoint(s[0], s[1])) {
                s[0], s[1] = pt[i], pt[j]
            }
        }
    }
    // furthest from that line
    L := Line{s[0], s[1]}
    s[2] = pt[0]
    for i := 0; i < 6; i++ {
        if gtr(distPointLine(pt[i], L), distPointLine(s[2], L)) {
            s[2] = pt[i]
        }
    }
    // furthest from the plane
    s[3] = point[1]
    base := Plane{s[0], s[1], s[2]}
    for i := 1; i <= totp; i++ {
        d1 := Abs(distPointPlane(point[i], base))
        d2 := Abs(distPointPlane(s[3], base))
        if gtr(d1, d2) {
            s[3] = point[i]
        }
    }
    if gtr(0, distPointPlane(s[3], base)) {
        s[1], s[2] = s[2], s[1]
    }
    // make 4 facets
    f := make([]int, 4)
    for i := 0; i < 4; i++ {
        FAC = append(FAC, &Facet{id: len(FAC)})
        f[i] = len(FAC) - 1
    }
    FAC[f[0]].p = Plane{s[0], s[2], s[1]}
    FAC[f[1]].p = Plane{s[0], s[1], s[3]}
    FAC[f[2]].p = Plane{s[1], s[2], s[3]}
    FAC[f[3]].p = Plane{s[2], s[0], s[3]}
    FAC[f[0]].n = [3]int{f[3], f[2], f[1]}
    FAC[f[1]].n = [3]int{f[0], f[2], f[3]}
    FAC[f[2]].n = [3]int{f[0], f[3], f[1]}
    FAC[f[3]].n = [3]int{f[0], f[1], f[2]}

    // prepare point‐lists
    for i := 0; i < 4; i++ {
        pts = append(pts, nil)
    }
    // assign remaining points
    for i := 1; i <= totp; i++ {
        v := point[i]
        if v.Eq(s[0]) || v.Eq(s[1]) || v.Eq(s[2]) || v.Eq(s[3]) {
            continue
        }
        for j := 0; j < 4; j++ {
            if isAbove(v, FAC[f[j]].p) {
                pts[f[j]] = append(pts[f[j]], v)
                break
            }
        }
    }
    return &ConvexHulls3d{index: f[0]}
}

// The main QuickHull3D loop
func quickHull3d(point []*Vect, totp int) *ConvexHulls3d {
    hull := getStart(point, totp)
    que = []int{hull.index}
    for i := 0; i < 3; i++ {
        que = append(que, FAC[hull.index].n[i])
    }
    snew := 0

    for len(que) > 0 {
        nf := que[0]
        que = que[1:]
        if FAC[nf].isdel || len(pts[nf]) == 0 {
            if !FAC[nf].isdel {
                snew = nf
            }
            continue
        }
        // find farthest point
        p := pts[nf][0]
        for _, v := range pts[nf][1:] {
            if gtr(distPointPlane(v, FAC[nf].p), distPointPlane(p, FAC[nf].p)) {
                p = v
            }
        }
        // find horizon
        TIME++
        resfdel = resfdel[:0]
        s := hull.getHorizon(nf, p, &resfdel)

        // build new faces around the horizon
        resfnew = resfnew[:0]
        TIME++
        from := -1
        lastf := -1
        fstf := -1
        for vistimeArr[s] != TIME {
            vistimeArr[s] = TIME
            var net, f, fnew int
            if e[0][s].netid == from {
                net, f = e[1][s].netid, e[1][s].facetid
            } else {
                net, f = e[0][s].netid, e[0][s].facetid
            }
            // find indices of s and net on facet f
            pt1, pt2 := 0, 0
            for i := 0; i < 3; i++ {
                if point[s].Eq(FAC[f].p.vecAt(i)) {
                    pt1 = i
                }
                if point[net].Eq(FAC[f].p.vecAt(i)) {
                    pt2 = i
                }
            }
            if (pt1+1)%3 != pt2 {
                pt1, pt2 = pt2, pt1
            }
            // create new facet facing outwards
            FAC = append(FAC, &Facet{
                id: len(FAC),
                p:  Plane{FAC[f].p.vecAt(pt2), FAC[f].p.vecAt(pt1), p},
            })
            fnew = len(FAC) - 1
            pts = append(pts, nil)
            resfnew = append(resfnew, fnew)

            FAC[fnew].n[0] = f
            FAC[f].n[pt1] = fnew
            if lastf >= 0 {
                // link with previous new facet
                if FAC[fnew].p.vecAt(1).Eq(FAC[lastf].p.u) {
                    FAC[fnew].n[1], FAC[lastf].n[2] = lastf, fnew
                } else {
                    FAC[fnew].n[2], FAC[lastf].n[1] = lastf, fnew
                }
            } else {
                fstf = fnew
            }
            lastf = fnew
            from = s
            s = net
        }
        // close the loop
        if FAC[fstf].p.v.Eq(FAC[lastf].p.u) {
            FAC[fstf].n[1], FAC[lastf].n[2] = lastf, fstf
        } else {
            FAC[fstf].n[2], FAC[lastf].n[1] = lastf, fstf
        }
        // collect points from deleted faces
        respt = respt[:0]
        for _, fid := range resfdel {
            respt = append(respt, pts[fid]...)
            pts[fid] = nil
        }
        // reassign them
        for _, v := range respt {
            if v == p {
                continue
            }
            for _, fid := range resfnew {
                if isAbove(v, FAC[fid].p) {
                    pts[fid] = append(pts[fid], v)
                    break
                }
            }
        }
        // enqueue new faces
        for _, fid := range resfnew {
            que = append(que, fid)
        }
    }

    hull.index = snew
    return hull
}

func main() {
    preConvexHulls()
    // Example: a unit tetrahedron
    point := []*Vect{
        nil,
        {0, 0, 0, 1},
        {1, 0, 0, 2},
        {0, 1, 0, 3},
        {0, 0, 1, 4},
    }
    hull := quickHull3d(point, 4)
    fmt.Printf("%.3f\n", hull.GetSurfaceArea())
}
