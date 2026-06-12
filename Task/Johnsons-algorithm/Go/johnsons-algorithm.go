package main

import (
	"container/heap"
	"fmt"
	"math"
)

const INF = math.MaxFloat64

type Edge struct {
	u, v   int
	weight float64
}

type VertexAndWeight struct {
	v      int
	weight float64
}

type WeightAndVertex struct {
	weight float64
	vertex int
}

// Priority queue implementation for Dijkstra's algorithm
type PriorityQueue []WeightAndVertex

func (pq PriorityQueue) Len() int           { return len(pq) }
func (pq PriorityQueue) Less(i, j int) bool { return pq[i].weight < pq[j].weight }
func (pq PriorityQueue) Swap(i, j int)      { pq[i], pq[j] = pq[j], pq[i] }

func (pq *PriorityQueue) Push(x interface{}) {
	*pq = append(*pq, x.(WeightAndVertex))
}

func (pq *PriorityQueue) Pop() interface{} {
	old := *pq
	n := len(old)
	item := old[n-1]
	*pq = old[0 : n-1]
	return item
}

func main() {
	// The element (i, j) is the weight of the edge from vertex i to vertex j.
	// INF, for infinity, means that there is no edge from vertex i to vertex j.
	graph := [][]float64{
		{0.0, -5.0, 2.0, 3.0},
		{INF, 0.0, 4.0, INF},
		{INF, INF, 0.0, 1.0},
		{INF, INF, INF, 0.0},
	}

	result, hasNegativeCycle := johnsonsAlgorithm(graph)

	if !hasNegativeCycle {
		fmt.Println("All pairs shortest paths:")
		fmt.Println("The element (i, j) is the shortest path between vertex i and vertex j.")
		for _, row := range result {
			fmt.Print("[")
			for _, number := range row {
				if number == INF {
					fmt.Print("INF ")
				} else {
					fmt.Printf("%v ", number)
				}
			}
			fmt.Println("]")
		}
	} else {
		fmt.Println("A negative cycle was detected in the graph.")
	}
}

// johnsonsAlgorithm returns the shortest path between all pairs of vertices in an edge weighted directed graph
// and a boolean indicating whether a negative cycle was detected
func johnsonsAlgorithm(graph [][]float64) ([][]float64, bool) {
	vertexCount := len(graph)
	originalEdges := []Edge{}

	// Step 0: Build a list of edges for the original graph
	for i := 0; i < vertexCount; i++ {
		for j := 0; j < vertexCount; j++ {
			weight := graph[i][j]
			if i == j {
				if weight != 0.0 {
					fmt.Printf("Warning: graph[i][i] for i = %d is %v, expected to be 0.0, resetting it to 0.0\n", i, weight)
				}
			} else if weight != INF {
				originalEdges = append(originalEdges, Edge{i, j, weight})
			}
		}
	}

	// Step 1: Form the augmented graph
	// Add a new vertex with index 'vertexCount' and having 0-weight edges to all the original vertices
	augmentedEdges := make([]Edge, len(originalEdges))
	copy(augmentedEdges, originalEdges)
	for i := 0; i < vertexCount; i++ {
		augmentedEdges = append(augmentedEdges, Edge{vertexCount, i, 0.0})
	}

	// Step 2: Invoke the Bellman-Ford Algorithm starting from the new vertex
	hValues, hasNegativeCycle := bellmanFordAlgorithm(vertexCount+1, augmentedEdges, vertexCount)

	if hasNegativeCycle {
		return nil, true // A negative cycle was detected by the Bellman-Ford Algorithm
	}

	values := hValues[:vertexCount] // Remove the value for the augmented vertex

	// Step 3: Reweight the edges
	reweightedAdjacencies := make(map[int][]VertexAndWeight)
	for v := 0; v < vertexCount; v++ {
		reweightedAdjacencies[v] = []VertexAndWeight{}
	}

	for _, edge := range originalEdges {
		// Ensure the 'values' are valid before reweighting
		if values[edge.u] == INF || values[edge.v] == INF {
			// This can happen if the original graph was not strongly connected to the augmented vertex.
			// While not strictly an error for Johnson's Algorithm, because paths might still exist between
			// reachable nodes, it means the reweighting might involve INF.
			// Computation can proceed since Dijkstra's Algorithm can handle INF.
			fmt.Println("Warning: invalid hValues detected by the Bellman-Ford Algorithm.")
		}

		reweight := edge.weight + values[edge.u] - values[edge.v]
		reweightedAdjacencies[edge.u] = append(reweightedAdjacencies[edge.u], VertexAndWeight{edge.v, reweight})
	}

	// Step 4: Invoke Dijkstra's Algorithm starting from each vertex on the reweighted graph
	allPairsShortestPaths := make([][]float64, vertexCount)
	for u := 0; u < vertexCount; u++ {
		allPairsShortestPaths[u] = dijkstraAlgorithm(vertexCount, reweightedAdjacencies, u, values)
	}

	// Step 5: Return the result matrix
	return allPairsShortestPaths, false
}

// bellmanFordAlgorithm returns a list of shortest distances from the source vertex to all other vertices,
// and a boolean indicating whether a negative cycle was detected
func bellmanFordAlgorithm(augmentedVertexCount int, edges []Edge, sourceVertex int) ([]float64, bool) {
	distances := make([]float64, augmentedVertexCount)
	for i := range distances {
		distances[i] = INF
	}
	distances[sourceVertex] = 0.0

	// Relax the edges (augmentedVertexCount - 1) times
	updated := true
	for i := 0; i < augmentedVertexCount-1 && updated; i++ {
		updated = false
		for j := 0; j < len(edges); j++ {
			edge := edges[j]
			if distances[edge.u] != INF && distances[edge.u]+edge.weight < distances[edge.v] {
				distances[edge.v] = distances[edge.u] + edge.weight
				updated = true
			}
		}
	}

	// Check for negative cycles in the graph
	for _, edge := range edges {
		if distances[edge.u] != INF && distances[edge.u]+edge.weight < distances[edge.v] {
			return nil, true // Indicates to the calling method that a negative cycle has been detected
		}
	}

	return distances, false
}

// dijkstraAlgorithm returns a list of shortest path distances from the source vertex in the original graph to all other vertices
func dijkstraAlgorithm(vertexCount int, reweightedAdjacencies map[int][]VertexAndWeight, sourceVertex int, values []float64) []float64 {
	distances := make([]float64, vertexCount)
	for i := range distances {
		distances[i] = INF
	}
	distances[sourceVertex] = 0.0

	pq := make(PriorityQueue, 0)
	heap.Init(&pq)
	heap.Push(&pq, WeightAndVertex{0.0, sourceVertex})

	finalDistances := make([]float64, vertexCount)
	for i := range finalDistances {
		finalDistances[i] = INF
	}

	for pq.Len() > 0 {
		weightAndVertex := heap.Pop(&pq).(WeightAndVertex)
		vertex := weightAndVertex.vertex
		if weightAndVertex.weight > distances[vertex] {
			continue
		}

		// Store the final shortest path distance, translated back to the distance in the original graph
		// which prevents processing vertices disconnected from the source vertex
		if finalDistances[vertex] == INF {
			if distances[vertex] == INF { // This should not happen, but is included as a safety check
				finalDistances[vertex] = INF
			} else {
				// Translate distance back to its original weight: d(u,v) = d'(u,v) - h[u] + h[v]
				finalDistances[vertex] = distances[vertex] - values[sourceVertex] + values[vertex]
			}
		}

		// Relax the edges outgoing from vertex
		if adjList, exists := reweightedAdjacencies[vertex]; exists {
			for _, pair := range adjList {
				if distances[vertex] != INF && distances[vertex]+pair.weight < distances[pair.v] {
					distances[pair.v] = distances[vertex] + pair.weight
					heap.Push(&pq, WeightAndVertex{distances[pair.v], pair.v})
				}
			}
		}
	}

	// Translate distance back to its original weight for any remaining reachable vertices
	// This handles cases where a vertex was reachable, but was not the minimum vertex
	// removed from the priority queue when its final distance was determined.
	for i := 0; i < vertexCount; i++ {
		if finalDistances[i] == INF && distances[i] != INF {
			finalDistances[i] = distances[i] - values[sourceVertex] + values[i]
		}
	}

	return finalDistances
}
