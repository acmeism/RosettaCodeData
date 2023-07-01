package main

import (
    "fmt"
    "math"
    "strings"
)

var gmooh = strings.Split(
    `.........00000.........
......00003130000......
....000321322221000....
...00231222432132200...
..0041433223233211100..
..0232231612142618530..
.003152122326114121200.
.031252235216111132210.
.022211246332311115210.
00113232262121317213200
03152118212313211411110
03231234121132221411410
03513213411311414112320
00427534125412213211400
.013322444412122123210.
.015132331312411123120.
.003333612214233913300.
..0219126511415312570..
..0021321524341325100..
...00211415413523200...
....000122111322000....
......00001120000......
.........00000.........`, "\n")

var width, height = len(gmooh[0]), len(gmooh)

type pyx [2]int // {y, x}

var d = []pyx{{-1, -1}, {0, -1}, {1, -1}, {-1, 0}, {1, 0}, {-1, 1}, {0, 1}, {1, 1}}

var dist, next [][]int
var pmap []pyx

const (
    max = math.MaxInt32
    min = -1
)

func (p pyx) destruct() (int, int) {
    return p[0], p[1]
}

func fwPath(u, v int) string {
    res := ""
    if next[u][v] != min {
        path := []string{fmt.Sprintf("%v", pmap[u])}
        for u != v {
            u = next[u][v]
            path = append(path, fmt.Sprintf("%v", pmap[u]))
        }
        res = strings.Join(path, "->")
    }
    return res
}

func showFwPath(u, v int) {
    fmt.Printf("%v->%v   %2d   %s\n", pmap[u], pmap[v], dist[u][v], fwPath(u, v))
}

func floydWarshall() {
    point := 0
    var weights []pyx
    points := make([][]int, height)
    for i := 0; i < width; i++ {
        points[i] = make([]int, width)
    }
    // First number the points.
    for x := 0; x < width; x++ {
        for y := 0; y < height; y++ {
            if gmooh[y][x] >= '0' {
                points[y][x] = point
                point++
                pmap = append(pmap, pyx{y, x})
            }
        }
    }
    // ...and then a set of edges (all of which have a "weight" of 1 day)
    for x := 0; x < width; x++ {
        for y := 0; y < height; y++ {
            if gmooh[y][x] > '0' {
                n := int(gmooh[y][x] - '0')
                for di := 0; di < len(d); di++ {
                    dx, dy := d[di].destruct()
                    rx, ry := x+n*dx, y+n*dy
                    if rx >= 0 && rx < width && ry >= 0 && ry < height && gmooh[rx][ry] >= '0' {
                        weights = append(weights, pyx{points[y][x], points[ry][rx]})
                    }
                }
            }
        }
    }
    // Before applying Floyd-Warshall.
    vv := len(pmap)
    dist = make([][]int, vv)
    next = make([][]int, vv)
    for i := 0; i < vv; i++ {
        dist[i] = make([]int, vv)
        next[i] = make([]int, vv)
        for j := 0; j < vv; j++ {
            dist[i][j] = max
            next[i][j] = min
        }
    }
    for k := 0; k < len(weights); k++ {
        u, v := weights[k].destruct()
        dist[u][v] = 1 // the weight of the edge (u,v)
        next[u][v] = v
    }
    // Standard Floyd-Warshall implementation,
    // with the optimization of avoiding processing of self/infs,
    // which surprisingly makes quite a noticeable difference.
    for k := 0; k < vv; k++ {
        for i := 0; i < vv; i++ {
            if i != k && dist[i][k] != max {
                for j := 0; j < vv; j++ {
                    if j != i && j != k && dist[k][j] != max {
                        dd := dist[i][k] + dist[k][j]
                        if dd < dist[i][j] {
                            dist[i][j] = dd
                            next[i][j] = next[i][k]
                        }
                    }
                }
            }
        }
    }
    showFwPath(points[21][11], points[1][11])
    showFwPath(points[1][11], points[21][11])

    var maxd, mi, mj int
    for i := 0; i < vv; i++ {
        for j := 0; j < vv; j++ {
            if j != i {
                dd := dist[i][j]
                if dd != max && dd > maxd {
                    maxd, mi, mj = dd, i, j
                }
            }
        }
    }
    fmt.Println("\nMaximum shortest distance:")
    showFwPath(mi, mj)
}

func main() {
    floydWarshall()
}
