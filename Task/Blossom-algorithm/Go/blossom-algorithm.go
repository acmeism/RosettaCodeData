package main

import (
    "fmt"
)

type Blossom struct {
    n        int
    adj      [][]int
    match    []int
    p        []int
    base     []int
    used     []bool
    blossom  []bool
    queue    []int
}

func NewBlossom(adj [][]int) *Blossom {
    n := len(adj)
    match := make([]int, n)
    p := make([]int, n)
    base := make([]int, n)
    used := make([]bool, n)
    blossom := make([]bool, n)
    for i := 0; i < n; i++ {
        match[i] = -1
        p[i] = -1
        base[i] = i
    }
    return &Blossom{
        n:       n,
        adj:     adj,
        match:   match,
        p:       p,
        base:    base,
        used:    used,
        blossom: blossom,
        queue:   make([]int, 0, n),
    }
}

// least common ancestor of x and y in the alternating forest
func (bm *Blossom) lca(x, y int) int {
    usedPath := make([]bool, bm.n)
    for {
        x = bm.base[x]
        usedPath[x] = true
        if bm.match[x] < 0 {
            break
        }
        x = bm.p[bm.match[x]]
    }
    for {
        y = bm.base[y]
        if usedPath[y] {
            return y
        }
        y = bm.p[bm.match[y]]
    }
}

// mark path from v up to base0, setting parents to x
func (bm *Blossom) markPath(v, base0, x int) {
    for bm.base[v] != base0 {
        mv := bm.match[v]
        bm.blossom[bm.base[v]] = true
        bm.blossom[bm.base[mv]] = true
        bm.p[v] = x
        x = mv
        v = bm.p[x]
    }
}

// attempt to find an augmenting path from root
func (bm *Blossom) findPath(root int) bool {
    // reset BFS state
    for i := 0; i < bm.n; i++ {
        bm.used[i] = false
        bm.p[i] = -1
        bm.base[i] = i
    }
    bm.queue = bm.queue[:0]

    bm.used[root] = true
    bm.queue = append(bm.queue, root)

    qi := 0
    for qi < len(bm.queue) {
        v := bm.queue[qi]
        qi++
        for _, u := range bm.adj[v] {
            if bm.base[v] == bm.base[u] || bm.match[v] == u {
                continue
            }
            // blossom found
            if u == root || (bm.match[u] >= 0 && bm.p[bm.match[u]] >= 0) {
                curbase := bm.lca(v, u)
                for i := 0; i < bm.n; i++ {
                    bm.blossom[i] = false
                }
                bm.markPath(v, curbase, u)
                bm.markPath(u, curbase, v)
                for i := 0; i < bm.n; i++ {
                    if bm.blossom[bm.base[i]] {
                        bm.base[i] = curbase
                        if !bm.used[i] {
                            bm.used[i] = true
                            bm.queue = append(bm.queue, i)
                        }
                    }
                }
            } else if bm.p[u] < 0 {
                // extend tree
                bm.p[u] = v
                if bm.match[u] < 0 {
                    // augmenting path found
                    cur := u
                    for cur >= 0 {
                        prev := bm.p[cur]
                        nxt := -1
                        if prev >= 0 {
                            nxt = bm.match[prev]
                            bm.match[cur] = prev
                            bm.match[prev] = cur
                        }
                        cur = nxt
                    }
                    return true
                }
                // enqueue matched partner
                mu := bm.match[u]
                if !bm.used[mu] {
                    bm.used[mu] = true
                    bm.queue = append(bm.queue, mu)
                }
            }
        }
    }
    return false
}

// Solve returns the matching array and the size of the matching
func (bm *Blossom) Solve() ([]int, int) {
    res := 0
    for v := 0; v < bm.n; v++ {
        if bm.match[v] < 0 {
            if bm.findPath(v) {
                res++
            }
        }
    }
    return bm.match, res
}

func main() {
    // Example: 5‑cycle 0–1–2–3–4–0
    n := 5
    edges := [][2]int{{0, 1}, {1, 2}, {2, 3}, {3, 4}, {4, 0}}
    adj := make([][]int, n)
    for _, e := range edges {
        u, v := e[0], e[1]
        adj[u] = append(adj[u], v)
        adj[v] = append(adj[v], u)
    }

    bm := NewBlossom(adj)
    match, size := bm.Solve()

    fmt.Printf("Maximum matching size: %d\n", size)
    fmt.Println("Matched pairs:")
    for u, v := range match {
        if v >= 0 && u < v {
            fmt.Printf("  %d – %d\n", u, v)
        }
    }
}
