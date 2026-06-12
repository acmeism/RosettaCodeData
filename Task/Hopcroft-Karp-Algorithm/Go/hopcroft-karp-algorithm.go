package main

import (
	"container/list"
	"fmt"
	"math"
)

const (
	NIL = 0
)

type HKGraph struct {
	m, n    int
	adj     [][]int
	pairU   []int
	pairV   []int
	dist    []float64
}

func NewHKGraph(m, n int) *HKGraph {
	adj := make([][]int, m+1)
	for i := range adj {
		adj[i] = make([]int, 0)
	}
	
	return &HKGraph{
		m:     m,
		n:     n,
		adj:   adj,
		pairU: make([]int, m+1),
		pairV: make([]int, n+1),
		dist:  make([]float64, m+1),
	}
}

func (g *HKGraph) AddEdge(u, v int) {
	if 1 <= u && u <= g.m && 1 <= v && v <= g.n {
		g.adj[u] = append(g.adj[u], v)
	}
}

func (g *HKGraph) BFS() bool {
	queue := list.New()
	
	for u := 1; u <= g.m; u++ {
		if g.pairU[u] == NIL {
			g.dist[u] = 0
			queue.PushBack(u)
		} else {
			g.dist[u] = math.Inf(1)
		}
	}
	
	g.dist[NIL] = math.Inf(1)
	
	for queue.Len() > 0 {
		u := queue.Remove(queue.Front()).(int)
		
		if g.dist[u] < g.dist[NIL] {
			for _, v := range g.adj[u] {
				matchedU := g.pairV[v]
				if math.IsInf(g.dist[matchedU], 1) {
					g.dist[matchedU] = g.dist[u] + 1
					queue.PushBack(matchedU)
				}
			}
		}
	}
	
	return !math.IsInf(g.dist[NIL], 1)
}

func (g *HKGraph) DFS(u int) bool {
	if u != NIL {
		for _, v := range g.adj[u] {
			matchedU := g.pairV[v]
			if g.dist[matchedU] == g.dist[u]+1 {
				if g.DFS(matchedU) {
					g.pairV[v] = u
					g.pairU[u] = v
					return true
				}
			}
		}
		
		g.dist[u] = math.Inf(1)
		return false
	}
	
	return true
}

func (g *HKGraph) HopcroftKarpAlgorithm() int {
	g.pairU = make([]int, g.m+1)
	g.pairV = make([]int, g.n+1)
	matchingSize := 0
	
	for g.BFS() {
		for u := 1; u <= g.m; u++ {
			if g.pairU[u] == NIL && g.DFS(u) {
				matchingSize++
			}
		}
	}
	
	return matchingSize
}

func runTests() {
	fmt.Println("Running tests...")
	
	g1 := NewHKGraph(3, 5)
	g1.AddEdge(1, 4)
	res1 := g1.HopcroftKarpAlgorithm()
	expectedRes1 := 1
	fmt.Printf("Test 1: Result=%d, Expected=%d\n", res1, expectedRes1)
	if res1 != expectedRes1 {
		panic(fmt.Sprintf("Test 1 Failed: Expected %d, got %d", expectedRes1, res1))
	}
	
	g2 := NewHKGraph(6, 6)
	g2.AddEdge(1, 4)
	g2.AddEdge(1, 5)
	g2.AddEdge(5, 1)
	res2 := g2.HopcroftKarpAlgorithm()
	expectedRes2 := 2
	fmt.Printf("Test 2: Result=%d, Expected=%d\n", res2, expectedRes2)
	if res2 != expectedRes2 {
		panic(fmt.Sprintf("Test 2 Failed: Expected %d, got %d", expectedRes2, res2))
	}
	
	g3 := NewHKGraph(3, 3)
	for i := 1; i <= 3; i++ {
		for j := 1; j <= 3; j++ {
			g3.AddEdge(i, j)
		}
	}
	res3 := g3.HopcroftKarpAlgorithm()
	expectedRes3 := 3
	fmt.Printf("Test 3: Result=%d, Expected=%d\n", res3, expectedRes3)
	if res3 != expectedRes3 {
		panic(fmt.Sprintf("Test 3 Failed: Expected %d, got %d", expectedRes3, res3))
	}
	
	g4 := NewHKGraph(2, 2)
	res4 := g4.HopcroftKarpAlgorithm()
	expectedRes4 := 0
	fmt.Printf("Test 4: Result=%d, Expected=%d\n", res4, expectedRes4)
	if res4 != expectedRes4 {
		panic(fmt.Sprintf("Test 4 Failed: Expected %d, got %d", expectedRes4, res4))
	}
	
	fmt.Println("All tests passed!")
}

func main() {
	runTests()
	
	fmt.Println("\n--- Running main execution with hard-coded input ---")
	
	hardcodedV1 := 4
	hardcodedV2 := 4
	hardcodedEdges := [][2]int{
		{1, 1},
		{1, 3},
		{2, 3},
		{3, 4},
		{4, 3},
		{4, 2},
	}
	
	v1 := hardcodedV1
	v2 := hardcodedV2
	edgesData := hardcodedEdges
	e := len(edgesData)
	
	g := NewHKGraph(v1, v2)
	fmt.Printf("Hard-coded graph dimensions: m=%d, n=%d, edges=%d\n", v1, v2, e)
	fmt.Println("Adding hard-coded edges:")
	
	for _, edge := range edgesData {
		u, v := edge[0], edge[1]
		fmt.Printf("  Adding edge: (%d, %d)\n", u, v)
		
		if 1 <= u && u <= v1 && 1 <= v && v <= v2 {
			g.AddEdge(u, v)
		} else {
			fmt.Printf("Warning: Skipping invalid hard-coded edge (%d, %d) - indices out of range [1..%d] or [1..%d]\n",
				u, v, v1, v2)
		}
	}
	
	maxMatchingSize := g.HopcroftKarpAlgorithm()
	fmt.Printf("\nMaximum matching size is %d\n", maxMatchingSize)
}
