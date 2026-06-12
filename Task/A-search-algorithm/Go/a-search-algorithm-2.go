package main

import (
    "fmt"

    "astar"
)

// rcNode implements the astar.Node interface
type rcNode struct{ r, c int }

var barrier = map[rcNode]bool{{2, 4}: true, {2, 5}: true,
    {2, 6}: true, {3, 6}: true, {4, 6}: true, {5, 6}: true, {5, 5}: true,
    {5, 4}: true, {5, 3}: true, {5, 2}: true, {4, 2}: true, {3, 2}: true}

// graph representation is virtual.  Arcs from a node are generated when
// requested, but there is no static graph representation.
func (fr rcNode) To() (a []astar.Arc) {
    for r := fr.r - 1; r <= fr.r+1; r++ {
        for c := fr.c - 1; c <= fr.c+1; c++ {
            if (r == fr.r && c == fr.c) || r < 0 || r > 7 || c < 0 || c > 7 {
                continue
            }
            n := rcNode{r, c}
            cost := 1
            if barrier[n] {
                cost = 100
            }
            a = append(a, astar.Arc{n, cost})
        }
    }
    return a
}

// The heuristic computed is max of row distance and column distance.
// This is effectively the cost if there were no barriers.
func (n rcNode) Heuristic(fr astar.Node) int {
    dr := n.r - fr.(rcNode).r
    if dr < 0 {
        dr = -dr
    }
    dc := n.c - fr.(rcNode).c
    if dc < 0 {
        dc = -dc
    }
    if dr > dc {
        return dr
    }
    return dc
}

func main() {
    route, cost := astar.Route(rcNode{0, 0}, rcNode{7, 7})
    fmt.Println("Route:", route)
    fmt.Println("Cost:", cost)
}
