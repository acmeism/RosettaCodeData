package main

import (
	"fmt"
)

type Edge struct {
	u      int
	v      int
	weight float64
}

type Graph struct {
	edges       []Edge
	vertexCount int
}

func NewGraph(vertexCount int) *Graph {
	return &Graph{
		edges:       []Edge{},
		vertexCount: vertexCount,
	}
}

func (g *Graph) AddEdge(edge Edge) {
	g.edges = append(g.edges, edge)
}

// Return the minimum spanning tree using Borůvka's algorithm
func (g *Graph) BorůvkaMinimumSpanningTree() {
	parent := make([]int, g.vertexCount)
	rank := make([]int, g.vertexCount)
	
	// Initialize parent array - each vertex is its own parent initially
	for i := 0; i < g.vertexCount; i++ {
		parent[i] = i
		rank[i] = 0
	}
	
	// Store the indexes of the cheapest edge of each tree
	cheapest := make([]Edge, g.vertexCount)
	for i := 0; i < g.vertexCount; i++ {
		cheapest[i] = Edge{-1, -1, -1.0}
	}
	
	// Initially there are 'vertexCount' different trees
	treeCount := g.vertexCount
	minimumSpanningTreeWeight := 0.0
	
	// Combine trees until all trees are combined into a single minimum spanning tree
	for treeCount > 1 {
		// Traverse through all edges and update cheapest edge for every tree
		for _, edge := range g.edges {
			u := edge.u
			v := edge.v
			weight := edge.weight
			
			index1 := find(parent, u)
			index2 := find(parent, v)
			
			// If the two vertices of the current edge belong to different trees,
			// check whether the current edge is cheaper than previous cheapest edges
			if index1 != index2 {
				if cheapest[index1].weight == -1.0 || cheapest[index1].weight > weight {
					cheapest[index1] = Edge{u, v, weight}
				}
				if cheapest[index2].weight == -1.0 || cheapest[index2].weight > weight {
					cheapest[index2] = Edge{u, v, weight}
				}
			}
		}
		
		// Add the cheapest edges to the minimum spanning tree
		for vertex := 0; vertex < g.vertexCount; vertex++ {
			// Check whether the cheapest edge for current vertex exists
			if cheapest[vertex].weight != -1.0 {
				u := cheapest[vertex].u
				v := cheapest[vertex].v
				weight := cheapest[vertex].weight
				
				index1 := find(parent, u)
				index2 := find(parent, v)
				
				if index1 != index2 {
					minimumSpanningTreeWeight += weight
					unionSet(parent, rank, index1, index2)
					fmt.Printf("Edge %d--%d with weight %.1f is included in the minimum spanning tree\n",
						u, v, weight)
					treeCount--
				}
			}
		}
		
		// Reset cheapest edges for next iteration
		for i := 0; i < g.vertexCount; i++ {
			cheapest[i] = Edge{-1, -1, -1.0}
		}
	}
	
	fmt.Printf("\nWeight of minimum spanning tree is %.1f\n", minimumSpanningTreeWeight)
}

// Return the index of the tree containing 'vertex', using a path compression technique
func find(parent []int, vertex int) int {
	if parent[vertex] != vertex {
		parent[vertex] = find(parent, parent[vertex])
	}
	return parent[vertex]
}

// Form the union by rank of the two trees indexed by u and v
func unionSet(parent []int, rank []int, u, v int) {
	uRoot := find(parent, u)
	vRoot := find(parent, v)
	
	// Attach the smaller rank tree under root of the high rank tree
	switch {
	case rank[uRoot] < rank[vRoot]:
		parent[uRoot] = vRoot
	case rank[uRoot] > rank[vRoot]:
		parent[vRoot] = uRoot
	default:
		// If ranks are the same, make one the root and increment its rank
		parent[vRoot] = uRoot
		rank[uRoot]++
	}
}

func main() {
	graph := NewGraph(4)
	graph.AddEdge(Edge{0, 1, 10.0})
	graph.AddEdge(Edge{0, 2, 6.0})
	graph.AddEdge(Edge{0, 3, 5.0})
	graph.AddEdge(Edge{1, 3, 15.0})
	graph.AddEdge(Edge{2, 3, 4.0})
	
	graph.BorůvkaMinimumSpanningTree()
}
