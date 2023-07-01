package main

import (
    "fmt"
    "sort"
)

type graph struct {
    nn  int     // number of nodes
    st  int     // node numbering starts from
    nbr [][]int // neighbor list for each node
}

type nodeval struct {
    n int // number of node
    v int // valence of node i.e. number of neighbors
}

func contains(s []int, n int) bool {
    for _, e := range s {
        if e == n {
            return true
        }
    }
    return false
}

func newGraph(nn, st int) graph {
    nbr := make([][]int, nn)
    return graph{nn, st, nbr}
}

// Note that this creates a single 'virtual' edge for an isolated node.
func (g graph) addEdge(n1, n2 int) {
    n1, n2 = n1-g.st, n2-g.st // adjust to starting node number
    g.nbr[n1] = append(g.nbr[n1], n2)
    if n1 != n2 {
        g.nbr[n2] = append(g.nbr[n2], n1)
    }
}

// Uses 'greedy' algorithm.
func (g graph) greedyColoring() []int {
    // create a slice with a color for each node, starting with color 0
    cols := make([]int, g.nn) // all zero by default including the first node
    for i := 1; i < g.nn; i++ {
        cols[i] = -1 // mark all nodes after the first as having no color assigned (-1)
    }
    // create a bool slice to keep track of which colors are available
    available := make([]bool, g.nn) // all false by default
    // assign colors to all nodes after the first
    for i := 1; i < g.nn; i++ {
        // iterate through neighbors and mark their colors as available
        for _, j := range g.nbr[i] {
            if cols[j] != -1 {
                available[cols[j]] = true
            }
        }
        // find the first available color
        c := 0
        for ; c < g.nn; c++ {
            if !available[c] {
                break
            }
        }
        cols[i] = c // assign it to the current node
        // reset the neighbors' colors to unavailable
        // before the next iteration
        for _, j := range g.nbr[i] {
            if cols[j] != -1 {
                available[cols[j]] = false
            }
        }
    }
    return cols
}

// Uses Welsh-Powell algorithm.
func (g graph) wpColoring() []int {
    // create nodeval for each node
    nvs := make([]nodeval, g.nn)
    for i := 0; i < g.nn; i++ {
        v := len(g.nbr[i])
        if v == 1 && g.nbr[i][0] == i { // isolated node
            v = 0
        }
        nvs[i] = nodeval{i, v}
    }
    // sort the nodevals in descending order by valence
    sort.Slice(nvs, func(i, j int) bool {
        return nvs[i].v > nvs[j].v
    })
    // create colors slice with entries for each node
    cols := make([]int, g.nn)
    for i := range cols {
        cols[i] = -1 // set all nodes to no color (-1) initially
    }
    currCol := 0 // start with color 0
    for f := 0; f < g.nn-1; f++ {
        h := nvs[f].n
        if cols[h] != -1 { // already assigned a color
            continue
        }
        cols[h] = currCol
        // assign same color to all subsequent uncolored nodes which are
        // not connected to a previous colored one
    outer:
        for i := f + 1; i < g.nn; i++ {
            j := nvs[i].n
            if cols[j] != -1 { // already colored
                continue
            }
            for k := f; k < i; k++ {
                l := nvs[k].n
                if cols[l] == -1 { // not yet colored
                    continue
                }
                if contains(g.nbr[j], l) {
                    continue outer // node j is connected to an earlier colored node
                }
            }
            cols[j] = currCol
        }
        currCol++
    }
    return cols
}

func main() {
    fns := [](func(graph) []int){graph.greedyColoring, graph.wpColoring}
    titles := []string{"'Greedy'", "Welsh-Powell"}
    nns := []int{4, 8, 8, 8}
    starts := []int{0, 1, 1, 1}
    edges1 := [][2]int{{0, 1}, {1, 2}, {2, 0}, {3, 3}}
    edges2 := [][2]int{{1, 6}, {1, 7}, {1, 8}, {2, 5}, {2, 7}, {2, 8},
        {3, 5}, {3, 6}, {3, 8}, {4, 5}, {4, 6}, {4, 7}}
    edges3 := [][2]int{{1, 4}, {1, 6}, {1, 8}, {3, 2}, {3, 6}, {3, 8},
        {5, 2}, {5, 4}, {5, 8}, {7, 2}, {7, 4}, {7, 6}}
    edges4 := [][2]int{{1, 6}, {7, 1}, {8, 1}, {5, 2}, {2, 7}, {2, 8},
        {3, 5}, {6, 3}, {3, 8}, {4, 5}, {4, 6}, {4, 7}}
    for j, fn := range fns {
        fmt.Println("Using the", titles[j], "algorithm:\n")
        for i, edges := range [][][2]int{edges1, edges2, edges3, edges4} {
            fmt.Println("  Example", i+1)
            g := newGraph(nns[i], starts[i])
            for _, e := range edges {
                g.addEdge(e[0], e[1])
            }
            cols := fn(g)
            ecount := 0 // counts edges
            for _, e := range edges {
                if e[0] != e[1] {
                    fmt.Printf("    Edge  %d-%d -> Color %d, %d\n", e[0], e[1],
                        cols[e[0]-g.st], cols[e[1]-g.st])
                    ecount++
                } else {
                    fmt.Printf("    Node  %d   -> Color %d\n", e[0], cols[e[0]-g.st])
                }
            }
            maxCol := 0 // maximum color number used
            for _, col := range cols {
                if col > maxCol {
                    maxCol = col
                }
            }
            fmt.Println("    Number of nodes  :", nns[i])
            fmt.Println("    Number of edges  :", ecount)
            fmt.Println("    Number of colors :", maxCol+1)
            fmt.Println()
        }
    }
}
