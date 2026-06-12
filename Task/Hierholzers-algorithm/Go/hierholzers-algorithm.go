package main

import (
	"fmt"
)

// printCircuit finds and prints an Eulerian circuit in a directed graph
// using Hierholzer's algorithm.
// It assumes the graph has an Eulerian circuit starting from vertex 0.
// NOTE: This function modifies the input adjacency list 'adj'.
func printCircuit(adj [][]int) {
	if len(adj) == 0 {
		fmt.Println("Empty graph")
		return // empty graph
	}

	// edgeCount represents the number of edges emerging from a vertex
	// Equivalent to Python's edge_count dictionary
	edgeCount := make(map[int]int)
	for i := 0; i < len(adj); i++ {
		// Find the count of edges to keep track of unused edges
		edgeCount[i] = len(adj[i])
	}

	// Maintain a stack to keep vertices
	// Equivalent to Python's curr_path list used as a stack
	currPath := []int{}

	// Slice to store final circuit
	// Equivalent to Python's circuit list
	circuit := []int{}

	// Start from vertex 0 (or any vertex if guaranteed to be part of circuit)
	currPath = append(currPath, 0)
	currV := 0 // Current vertex

	for len(currPath) > 0 {
		// If there's a remaining edge from the current vertex
		if edgeCount[currV] > 0 {
			// Push the current vertex onto the path before exploring the edge
			currPath = append(currPath, currV)

			// Find the next vertex using an edge
			// Equivalent to Python's adj[curr_v][-1]
			lastNeighborIndex := len(adj[currV]) - 1
			nextV := adj[currV][lastNeighborIndex]

			// Decrement the edge count for the current vertex
			edgeCount[currV]--
			// Remove that edge (modifies the original adj slice)
			// Equivalent to Python's adj[curr_v].pop()
			adj[currV] = adj[currV][:lastNeighborIndex]

			// Move to the next vertex
			currV = nextV
		} else {
			// If no more edges from currV, it means we've completed a cycle (or sub-cycle)
			// Add the vertex to the final circuit
			circuit = append(circuit, currV)

			// Backtrack: Pop the last vertex from the path and make it the current one
			// Equivalent to Python's curr_v = curr_path[-1]; curr_path.pop()
			lastElementIndex := len(currPath) - 1
			currV = currPath[lastElementIndex]
			currPath = currPath[:lastElementIndex] // Pop from stack
		}
	}

	// We've got the circuit, now print it in reverse
	// Equivalent to Python's reverse iteration and printing
	for i := len(circuit) - 1; i >= 0; i-- {
		fmt.Print(circuit[i])
		if i > 0 {
			fmt.Print(" -> ")
		}
	}
	fmt.Println() // Add a final newline
}

func main() {
	// --- Input Graph 1 ---
	// Equivalent to Python's adj1 initialization
	adj1 := make([][]int, 3)
	// No need to initialize inner slices with make if using append
	// adj1[0] = make([]int, 0, 1) // Optional pre-allocation
	// adj1[1] = make([]int, 0, 1)
	// adj1[2] = make([]int, 0, 1)

	// Build the edges
	adj1[0] = append(adj1[0], 1)
	adj1[1] = append(adj1[1], 2)
	adj1[2] = append(adj1[2], 0)

	fmt.Println("Circuit for Graph 1:")
	printCircuit(adj1) // Note: adj1 will be modified
	fmt.Println()

	// --- Input Graph 2 ---
	// Equivalent to Python's adj2 initialization
	adj2 := make([][]int, 7)
	// adj2[0] = make([]int, 0, 2) // Optional pre-allocation
	// ... and so on

	adj2[0] = append(adj2[0], 1)
	adj2[0] = append(adj2[0], 6)
	adj2[1] = append(adj2[1], 2)
	adj2[2] = append(adj2[2], 0)
	adj2[2] = append(adj2[2], 3)
	adj2[3] = append(adj2[3], 4)
	adj2[4] = append(adj2[4], 2)
	adj2[4] = append(adj2[4], 5)
	adj2[5] = append(adj2[5], 0)
	adj2[6] = append(adj2[6], 4)

	fmt.Println("Circuit for Graph 2:")
	printCircuit(adj2) // Note: adj2 will be modified
	fmt.Println()
}
