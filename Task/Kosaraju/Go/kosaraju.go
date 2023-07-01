package main

import "fmt"

var g = [][]int{
    0: {1},
    1: {2},
    2: {0},
    3: {1, 2, 4},
    4: {3, 5},
    5: {2, 6},
    6: {5},
    7: {4, 6, 7},
}

func main() {
    fmt.Println(kosaraju(g))
}

func kosaraju(g [][]int) []int {
    // 1. For each vertex u of the graph, mark u as unvisited. Let L be empty.
    vis := make([]bool, len(g))
    L := make([]int, len(g))
    x := len(L)                // index for filling L in reverse order
    t := make([][]int, len(g)) // transpose graph
    // 2. recursive subroutine:
    var Visit func(int)
    Visit = func(u int) {
        if !vis[u] {
            vis[u] = true
            for _, v := range g[u] {
                Visit(v)
                t[v] = append(t[v], u) // construct transpose
            }
            x--
            L[x] = u
        }
    }
    // 2. For each vertex u of the graph do Visit(u)
    for u := range g {
        Visit(u)
    }
    c := make([]int, len(g)) // result, the component assignment
    // 3: recursive subroutine:
    var Assign func(int, int)
    Assign = func(u, root int) {
        if vis[u] { // repurpose vis to mean "unassigned"
            vis[u] = false
            c[u] = root
            for _, v := range t[u] {
                Assign(v, root)
            }
        }
    }
    // 3: For each element u of L in order, do Assign(u,u)
    for _, u := range L {
        Assign(u, u)
    }
    return c
}
