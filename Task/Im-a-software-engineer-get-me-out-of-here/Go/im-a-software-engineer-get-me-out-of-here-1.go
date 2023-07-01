package main

import (
    "fmt"
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

type route [3]int // {cost, fromy, fromx}

var zeroRoute = route{0, 0, 0}
var routes [][]route // route for each gmooh[][]

func (p pyx) destruct() (int, int) {
    return p[0], p[1]
}

func (r route) destruct() (int, int, int) {
    return r[0], r[1], r[2]
}

func search(y, x int) {
    // Simple breadth-first search, populates routes.
    // This isn't strictly Dijkstra because graph edges are not weighted.
    cost := 0
    routes = make([][]route, height)
    for i := 0; i < width; i++ {
        routes[i] = make([]route, width)
    }
    routes[y][x] = route{0, y, x} // zero-cost, the starting point
    var next []route
    for {
        n := int(gmooh[y][x] - '0')
        for di := 0; di < len(d); di++ {
            dx, dy := d[di].destruct()
            rx, ry := x+n*dx, y+n*dy
            if rx >= 0 && rx < width && ry >= 0 && ry < height && gmooh[rx][ry] >= '0' {
                ryx := routes[ry][rx]
                if ryx == zeroRoute || ryx[0] > cost+1 {
                    routes[ry][rx] = route{cost + 1, y, x}
                    if gmooh[ry][rx] > '0' {
                        next = append(next, route{cost + 1, ry, rx})
                        // If the graph was weighted, at this point
                        // that would get shuffled up into place.
                    }
                }
            }
        }
        if len(next) == 0 {
            break
        }
        cost, y, x = next[0].destruct()
        next = next[1:]
    }
}

func getRoute(y, x int) []pyx {
    cost := 0
    res := []pyx{{y, x}}
    for {
        cost, y, x = routes[y][x].destruct()
        if cost == 0 {
            break
        }
        res = append(res, pyx{0, 0})
        copy(res[1:], res[0:])
        res[0] = pyx{y, x}
    }
    return res
}

func showShortest() {
    shortest := 9999
    var res []pyx
    for x := 0; x < width; x++ {
        for y := 0; y < height; y++ {
            if gmooh[y][x] == '0' {
                ryx := routes[y][x]
                if ryx != zeroRoute {
                    cost := ryx[0]
                    if cost <= shortest {
                        if cost < shortest {
                            res = res[:0]
                            shortest = cost
                        }
                        res = append(res, pyx{y, x})
                    }
                }
            }
        }
    }
    areis, s := "is", ""
    if len(res) > 1 {
        areis = "are"
        s = "s"
    }
    fmt.Printf("There %s %d shortest route%s of %d days to safety:\n", areis, len(res), s, shortest)
    for _, r := range res {
        fmt.Println(getRoute(r[0], r[1]))
    }
}

func showUnreachable() {
    var res []pyx
    for x := 0; x < width; x++ {
        for y := 0; y < height; y++ {
            if gmooh[y][x] >= '0' && routes[y][x] == zeroRoute {
                res = append(res, pyx{y, x})
            }
        }
    }
    fmt.Println("\nThe following cells are unreachable:")
    fmt.Println(res)
}

func showLongest() {
    longest := 0
    var res []pyx
    for x := 0; x < width; x++ {
        for y := 0; y < height; y++ {
            if gmooh[y][x] >= '0' {
                ryx := routes[y][x]
                if ryx != zeroRoute {
                    rl := ryx[0]
                    if rl >= longest {
                        if rl > longest {
                            res = res[:0]
                            longest = rl
                        }
                        res = append(res, pyx{y, x})
                    }
                }
            }
        }
    }
    fmt.Printf("\nThere are %d cells that take %d days to send reinforcements to:\n", len(res), longest)
    for _, r := range res {
        fmt.Println(getRoute(r[0], r[1]))
    }
}

func main() {
    search(11, 11)
    showShortest()

    search(21, 11)
    fmt.Println("\nThe shortest route from {21,11} to {1,11}:")
    fmt.Println(getRoute(1, 11))

    search(1, 11)
    fmt.Println("\nThe shortest route from {1,11} to {21,11}:")
    fmt.Println(getRoute(21, 11))

    search(11, 11)
    showUnreachable()
    showLongest()
}
