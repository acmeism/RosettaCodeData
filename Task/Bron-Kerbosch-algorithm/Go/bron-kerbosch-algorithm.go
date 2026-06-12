package main

import (
	"fmt"
	"sort"
	"strings"
)

// Using map[string]bool to simulate a set of strings
type StringSet map[string]bool

// Edge struct represents a graph edge
type Edge struct {
	Start string
	End   string
}

// Global variable to store cliques (slices of sorted strings)
var cliques [][]string

// --- Set Operations Helper Functions ---

// setUnion returns the union of two sets (a U b)
func setUnion(a, b StringSet) StringSet {
	union := make(StringSet)
	for k := range a {
		union[k] = true
	}
	for k := range b {
		union[k] = true
	}
	return union
}

// setIntersection returns the intersection of two sets (a ∩ b)
func setIntersection(a, b StringSet) StringSet {
	intersection := make(StringSet)
	// Iterate over the smaller set for efficiency
	if len(a) < len(b) {
		for k := range a {
			if b[k] {
				intersection[k] = true
			}
		}
	} else {
		for k := range b {
			if a[k] {
				intersection[k] = true
			}
		}
	}
	return intersection
}

// setDifference returns the difference of two sets (a \ b)
func setDifference(a, b StringSet) StringSet {
	difference := make(StringSet)
	for k := range a {
		if !b[k] { // If element from a is NOT in b
			difference[k] = true
		}
	}
	return difference
}

// setCopy creates a shallow copy of the set
func setCopy(s StringSet) StringSet {
	newSet := make(StringSet)
	for k := range s {
		newSet[k] = true
	}
	return newSet
}

// setToSortedSlice converts a set to a sorted slice of strings
func setToSortedSlice(s StringSet) []string {
	slice := make([]string, 0, len(s))
	for k := range s {
		slice = append(slice, k)
	}
	sort.Strings(slice)
	return slice
}

// --- Printing Helper Functions ---

// printSlice prints a sorted string slice like [a, b, c]
func printSlice(slice []string) {
	fmt.Printf("[%s]", strings.Join(slice, ", "))
}

// print2DSlice prints a slice of slices like [[a, b, c], [d, e, f]]
func print2DSlice(slices [][]string) {
	fmt.Print("[")
	for i, slice := range slices {
		printSlice(slice)
		if i < len(slices)-1 {
			fmt.Print(", ")
		}
	}
	fmt.Println("]")
}

// --- Bron-Kerbosch Algorithm ---

// bronKerbosch implements the algorithm with pivoting.
// R: current clique being built
// P: candidate vertices
// X: processed vertices
// graph: adjacency list representation (map[vertex] -> set of neighbors)
func bronKerbosch(currentClique, candidates, processedVertices StringSet, graph map[string]StringSet) {

	if len(candidates) == 0 && len(processedVertices) == 0 {
		// Base case: Found a maximal clique
		if len(currentClique) > 2 {
			// Convert set to sorted slice before storing
			cliqueSlice := setToSortedSlice(currentClique)
			cliques = append(cliques, cliqueSlice)
		}
		return
	}

	// --- Pivot Selection ---
	// Choose a pivot u from P union X with the maximum number of neighbors in P.
	// Python version simplifies to max degree in the *whole graph* from P union X. We'll mimic that.
	unionSet := setUnion(candidates, processedVertices)
	pivot := ""
	maxDegree := -1

	// Find pivot (vertex in P U X with highest degree in the whole graph)
    if len(unionSet) > 0 {
        // Find *any* element first to initialize pivot
        for v := range unionSet {
            pivot = v
            if neighbors, ok := graph[pivot]; ok {
                maxDegree = len(neighbors)
            } else {
                maxDegree = 0 // Handle nodes with no outgoing edges if they exist
            }
            break // Found the first element, stop
        }

        // Now find the actual max degree pivot
        for v := range unionSet {
            degree := 0
            if neighbors, ok := graph[v]; ok {
                degree = len(neighbors)
            }
            if degree > maxDegree {
                maxDegree = degree
                pivot = v
            }
        }
    } else {
         // If unionSet is empty, we should have hit the base case already,
         // but handle defensively.
         return
    }


	// --- Iteration ---
	// Iterate through vertices v in P \ N(u) (candidates not neighbors of pivot)
	pivotNeighbors := graph[pivot] // Might be nil if pivot has no neighbors listed
	if pivotNeighbors == nil {
		pivotNeighbors = make(StringSet) // Treat as empty set if nil
	}

	// Create a copy of candidates to iterate over, as candidates set is modified inside the loop
	candidatesWithoutPivotNeighbors := setDifference(candidates, pivotNeighbors)

	// Need to iterate over a stable copy because 'candidates' is modified
	verticesToProcess := setToSortedSlice(candidatesWithoutPivotNeighbors) // Get keys to iterate safely

	for _, vertex := range verticesToProcess {
        // Ensure vertex is still in the *current* candidates set before processing
        // (It might have been removed if processing another vertex moved it to X implicitly,
        // although the standard BK algorithm structure should prevent this here).
        // This check is mostly for robustness if the sets were modified unexpectedly.
        // In this specific BK implementation, removing happens *after* recursion, so it's safe.
        // if !candidates[vertex] {
        //     continue
        // }

		vertexNeighbors := graph[vertex]
		if vertexNeighbors == nil {
			vertexNeighbors = make(StringSet)
		}

		// Create new clique R U {v}
		newClique := setCopy(currentClique)
		newClique[vertex] = true

		// New candidates P ∩ N(v)
		newCandidates := setIntersection(candidates, vertexNeighbors)

		// New processed vertices X ∩ N(v)
		newProcessed := setIntersection(processedVertices, vertexNeighbors)

		// Recursive call
		bronKerbosch(newClique, newCandidates, newProcessed, graph)

		// Move vertex from P to X: P = P \ {v}, X = X U {v}
		delete(candidates, vertex)
		processedVertices[vertex] = true
	}
}

func main() {
	// Define edges
	edges := []Edge{
		{"a", "b"}, {"b", "a"}, {"a", "c"}, {"c", "a"},
		{"b", "c"}, {"c", "b"}, {"d", "e"}, {"e", "d"},
		{"d", "f"}, {"f", "d"}, {"e", "f"}, {"f", "e"},
	}

	// Build the graph as an adjacency list (map[string]StringSet)
	graph := make(map[string]StringSet)
	allVertices := make(StringSet) // Keep track of all unique vertices

	for _, edge := range edges {
		// Ensure the map for the start node exists
		if _, ok := graph[edge.Start]; !ok {
			graph[edge.Start] = make(StringSet)
		}
		graph[edge.Start][edge.End] = true // Add neighbor

		// Add vertices to our set of all vertices
		allVertices[edge.Start] = true
		allVertices[edge.End] = true
	}

	// Initialize sets for the algorithm
	currentClique := make(StringSet)
	// Candidates initially contain all vertices in the graph
	candidates := setCopy(allVertices) // Start with all unique vertices found
	processedVertices := make(StringSet)

	// Execute the Bron-Kerbosch algorithm
	bronKerbosch(currentClique, candidates, processedVertices, graph)

	// Sort the final list of cliques for consistent display
	// Sort first by length, then lexicographically by the elements
	sort.Slice(cliques, func(i, j int) bool {
		if len(cliques[i]) != len(cliques[j]) {
			return len(cliques[i]) < len(cliques[j])
		}
		// If lengths are equal, compare element by element
		for k := 0; k < len(cliques[i]); k++ {
			if cliques[i][k] != cliques[j][k] {
				return cliques[i][k] < cliques[j][k]
			}
		}
		return false // Should not happen for distinct cliques
	})

	// Display the cliques
	print2DSlice(cliques)
}
