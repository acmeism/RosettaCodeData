package main

import (
	"fmt"
	"strings"
)

// Digraph represents a directed graph using adjacency lists
type Digraph struct {
	v   int     // number of vertices
	e   int     // number of edges
	adj [][]int // adjacency lists
}

// NewDigraph initializes an empty digraph with V vertices
func NewDigraph(v int) (*Digraph, error) {
	if v < 0 {
		return nil, fmt.Errorf("number of vertices must be non-negative")
	}
	
	adj := make([][]int, v)
	for i := 0; i < v; i++ {
		adj[i] = make([]int, 0)
	}
	
	return &Digraph{
		v:   v,
		e:   0,
		adj: adj,
	}, nil
}

// V returns the number of vertices
func (g *Digraph) V() int {
	return g.v
}

// E returns the number of edges
func (g *Digraph) E() int {
	return g.e
}

// validateVertex raises an error if v is not a valid vertex
func (g *Digraph) validateVertex(v int) error {
	if v < 0 || v >= g.v {
		return fmt.Errorf("vertex %d is not between 0 and %d", v, g.v-1)
	}
	return nil
}

// AddEdge adds the directed edge v->w to the digraph
func (g *Digraph) AddEdge(v, w int) error {
	if err := g.validateVertex(v); err != nil {
		return err
	}
	if err := g.validateVertex(w); err != nil {
		return err
	}
	
	g.adj[v] = append(g.adj[v], w)
	g.e++
	return nil
}

// Adj returns the list of neighbors adjacent from vertex v
func (g *Digraph) Adj(v int) ([]int, error) {
	if err := g.validateVertex(v); err != nil {
		return nil, err
	}
	return g.adj[v], nil
}

// String returns a string representation of the digraph
func (g *Digraph) String() string {
	var sb strings.Builder
	fmt.Fprintf(&sb, "%d vertices, %d edges\n", g.v, g.e)
	
	for v := 0; v < g.v; v++ {
		sb.WriteString(fmt.Sprintf("%d: ", v))
		for _, w := range g.adj[v] {
			sb.WriteString(fmt.Sprintf("%d ", w))
		}
		sb.WriteString("\n")
	}
	
	return sb.String()
}

// GabowSCC computes strongly connected components (SCCs) in a digraph using Gabow's algorithm
type GabowSCC struct {
	marked    []bool // marked[v] = has v been visited?
	id        []int  // id[v] = id of strong component containing v
	preorder  []int  // preorder[v] = preorder of v
	preCounter int   // preorder number counter
	sccCount  int    // number of strongly-connected components
	stack1    []int  // Stores vertices in order of visitation
	stack2    []int  // Auxiliary stack for finding SCC roots
}

// NewGabowSCC computes the strong components of the digraph G
func NewGabowSCC(g *Digraph) *GabowSCC {
	marked := make([]bool, g.V())
	id := make([]int, g.V())
	preorder := make([]int, g.V())
	
	// Initialize id array with -1
	for i := range id {
		id[i] = -1
	}
	
	scc := &GabowSCC{
		marked:    marked,
		id:        id,
		preorder:  preorder,
		preCounter: 0,
		sccCount:  0,
		stack1:    make([]int, 0),
		stack2:    make([]int, 0),
	}
	
	for v := 0; v < g.V(); v++ {
		if !scc.marked[v] {
			scc.dfs(g, v)
		}
	}
	
	return scc
}

// dfs implements depth-first search core logic for Gabow's algorithm
func (scc *GabowSCC) dfs(g *Digraph, v int) {
	scc.marked[v] = true
	scc.preorder[v] = scc.preCounter
	scc.preCounter++
	scc.stack1 = append(scc.stack1, v)
	scc.stack2 = append(scc.stack2, v)
	
	adj, _ := g.Adj(v)
	for _, w := range adj {
		if !scc.marked[w] {
			scc.dfs(g, w)
		} else if scc.id[w] == -1 {
			// Pop vertices from stack2 until top has preorder number <= preorder[w]
			for len(scc.stack2) > 0 && scc.preorder[scc.stack2[len(scc.stack2)-1]] > scc.preorder[w] {
				scc.stack2 = scc.stack2[:len(scc.stack2)-1] // Pop
			}
		}
	}
	
	// If v is the root of an SCC
	if len(scc.stack2) > 0 && scc.stack2[len(scc.stack2)-1] == v {
		// Pop v from stack2
		scc.stack2 = scc.stack2[:len(scc.stack2)-1]
		
		// Pop vertices from stack1 until v is popped; assign them the current SCC id
		for {
			l := len(scc.stack1)
			if l == 0 {
				break
			}
			w := scc.stack1[l-1]
			scc.stack1 = scc.stack1[:l-1] // Pop
			scc.id[w] = scc.sccCount
			if w == v {
				break
			}
		}
		scc.sccCount++
	}
}

// Count returns the number of strong components
func (scc *GabowSCC) Count() int {
	return scc.sccCount
}

// validateVertex raises an error if v is not a valid vertex
func (scc *GabowSCC) validateVertex(v int) error {
	if v < 0 || v >= len(scc.marked) {
		return fmt.Errorf("vertex %d is not between 0 and %d", v, len(scc.marked)-1)
	}
	return nil
}

// StronglyConnected returns true if vertices v and w are in the same strong component
func (scc *GabowSCC) StronglyConnected(v, w int) (bool, error) {
	if err := scc.validateVertex(v); err != nil {
		return false, err
	}
	if err := scc.validateVertex(w); err != nil {
		return false, err
	}
	
	return scc.id[v] != -1 && scc.id[v] == scc.id[w], nil
}

// GetID returns the component id of the strong component containing vertex v
func (scc *GabowSCC) GetID(v int) (int, error) {
	if err := scc.validateVertex(v); err != nil {
		return -1, err
	}
	return scc.id[v], nil
}

func main() {
	// Manually construct the digraph (same as in Python code)
	numVertices := 13
	g, err := NewDigraph(numVertices)
	if err != nil {
		fmt.Printf("Error creating digraph: %v\n", err)
		return
	}
	
	edges := [][2]int{
		{4, 2}, {2, 3}, {3, 2}, {6, 0}, {0, 1}, {2, 0}, {11, 12},
		{12, 9}, {9, 10}, {9, 11}, {8, 9}, {10, 12}, {0, 5}, {5, 4},
		{3, 5}, {6, 4}, {6, 9}, {7, 6}, {7, 8}, {8, 7}, {5, 3}, {0, 6},
	}
	
	for _, edge := range edges {
		v, w := edge[0], edge[1]
		if err := g.AddEdge(v, w); err != nil {
			fmt.Printf("Error adding edge %d->%d: %v\n", v, w, err)
			return
		}
	}
	
	fmt.Println("Constructed Digraph:")
	fmt.Println(g)
	
	// Compute SCCs
	scc := NewGabowSCC(g)
	
	// Print results
	m := scc.Count()
	fmt.Printf("%d strongly connected components\n", m)
	
	// Group vertices by component ID
	components := make([][]int, m)
	for i := range components {
		components[i] = make([]int, 0)
	}
	
	for v := 0; v < g.V(); v++ {
		componentID, err := scc.GetID(v)
		if err != nil {
			fmt.Printf("Error getting ID for vertex %d: %v\n", v, err)
			continue
		}
		
		if componentID != -1 {
			components[componentID] = append(components[componentID], v)
		} else {
			fmt.Printf("Warning: Vertex %d has no SCC ID assigned.\n", v)
		}
	}
	
	fmt.Println("\nComponents:")
	for i := 0; i < m; i++ {
		fmt.Printf("Component %d: ", i)
		for _, v := range components[i] {
			fmt.Printf("%d ", v)
		}
		fmt.Println()
	}
	
	// Example usage of StronglyConnected and GetID
	fmt.Println("\nConnectivity checks:")
	connected03, _ := scc.StronglyConnected(0, 3)
	fmt.Printf("Vertices 0 and 3 strongly connected? %v\n", connected03)
	
	connected07, _ := scc.StronglyConnected(0, 7)
	fmt.Printf("Vertices 0 and 7 strongly connected? %v\n", connected07)
	
	connected912, _ := scc.StronglyConnected(9, 12)
	fmt.Printf("Vertices 9 and 12 strongly connected? %v\n", connected912)
	
	id5, _ := scc.GetID(5)
	fmt.Printf("ID of vertex 5: %d\n", id5)
	
	id8, _ := scc.GetID(8)
	fmt.Printf("ID of vertex 8: %d\n", id8)
}
