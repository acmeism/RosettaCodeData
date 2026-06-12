package main

import (
    "fmt"
)

// Graph represents an undirected graph using an adjacency matrix.
type Graph struct {
    n   int
    adj [][]bool
}

// NewGraph creates a new graph on n vertices (0..n-1), with no edges.
func NewGraph(n int) *Graph {
    adj := make([][]bool, n)
    for i := range adj {
        adj[i] = make([]bool, n)
    }
    return &Graph{n: n, adj: adj}
}

// Clone returns a deep copy of the graph.
func (g *Graph) Clone() *Graph {
    adjCopy := make([][]bool, g.n)
    for i := 0; i < g.n; i++ {
        adjCopy[i] = make([]bool, g.n)
        copy(adjCopy[i], g.adj[i])
    }
    return &Graph{n: g.n, adj: adjCopy}
}

// AddEdge adds an undirected edge u--v.
func (g *Graph) AddEdge(u, v int) {
    if u < 0 || u >= g.n || v < 0 || v >= g.n {
        panic("vertex index out of bounds")
    }
    g.adj[u][v] = true
    g.adj[v][u] = true
}

// Degree returns the degree of vertex u.
func (g *Graph) Degree(u int) int {
    deg := 0
    for _, has := range g.adj[u] {
        if has {
            deg++
        }
    }
    return deg
}

// Closure computes the Chvátal closure in‑place.
func (g *Graph) Closure() {
    n := g.n
    for {
        added := false
    outer:
        for u := 0; u < n; u++ {
            for v := u + 1; v < n; v++ {
                if !g.adj[u][v] {
                    if g.Degree(u)+g.Degree(v) >= n {
                        g.AddEdge(u, v)
                        added = true
                        break outer
                    }
                }
            }
        }
        if !added {
            break
        }
    }
}

// IsComplete reports whether the graph is complete.
func (g *Graph) IsComplete() bool {
    for u := 0; u < g.n; u++ {
        for v := u + 1; v < g.n; v++ {
            if !g.adj[u][v] {
                return false
            }
        }
    }
    return true
}

// HamiltonianCycle finds a Hamiltonian cycle in the original graph
// by simple backtracking. If found, returns a slice of vertices
// including the return to the start; otherwise returns nil.
func (g *Graph) HamiltonianCycle() []int {
    n := g.n
    visited := make([]bool, n)
    path := []int{0}
    visited[0] = true

    var dfs func(u int) []int
    dfs = func(u int) []int {
        if len(path) == n {
            // check if we can close the cycle
            if g.adj[u][path[0]] {
                cycle := append(append([]int(nil), path...), path[0])
                return cycle
            }
            return nil
        }
        for v := 0; v < n; v++ {
            if !visited[v] && g.adj[u][v] {
                visited[v] = true
                path = append(path, v)
                if cycle := dfs(v); cycle != nil {
                    return cycle
                }
                // backtrack
                path = path[:len(path)-1]
                visited[v] = false
            }
        }
        return nil
    }

    return dfs(0)
}

func main() {
    // Example: 5 vertices, almost complete graph missing edge 0--1.
    // This satisfies Ore's condition: deg(0)=3, deg(1)=3, 3+3>=5.
    g := NewGraph(5)
    // Add all edges except (0,1)
    for u := 0; u < 5; u++ {
        for v := u + 1; v < 5; v++ {
            if !(u == 0 && v == 1) {
                g.AddEdge(u, v)
            }
        }
    }

    fmt.Println("Original graph degrees:")
    for u := 0; u < g.n; u++ {
        fmt.Printf(" deg(%d) = %d\n", u, g.Degree(u))
    }

    // Compute closure
    closure := g.Clone()
    closure.Closure()

    fmt.Println("\nAfter Chvátal closure:")
    for u := 0; u < closure.n; u++ {
        fmt.Printf("  %d:", u)
        for v := 0; v < closure.n; v++ {
            if closure.adj[u][v] {
                fmt.Printf(" %d", v)
            }
        }
        fmt.Println()
    }

    if closure.IsComplete() {
        fmt.Println("\nClosure is complete ⇒ graph is Hamiltonian (by Bondy–Chvátal).")
        if cycle := g.HamiltonianCycle(); cycle != nil {
            fmt.Println("Found Hamiltonian cycle in original graph:")
            for i, v := range cycle {
                if i > 0 {
                    fmt.Print(" → ")
                }
                fmt.Print(v)
            }
            fmt.Println()
        } else {
            fmt.Println("Unexpected: could not find a Hamiltonian cycle.")
        }
    } else {
        fmt.Println("\nClosure is not complete ⇒ no guarantee of Hamiltonian cycle.")
    }
}
