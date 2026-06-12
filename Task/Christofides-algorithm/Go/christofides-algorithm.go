package main

import (
	"fmt"
	"math"
	"math/rand"
	"sort"
	"time"
)

// --- Helper Structs ---

type Point struct {
	x, y float64
	id   int // Original index
}

type Edge struct {
	u, v    int
	weight  float64
}

// --- Helper Function to print vectors/lists ---
func printContainer[T any](container []T, name string) {
	fmt.Printf("%s: [", name)
	for i, item := range container {
		if i > 0 {
			fmt.Print(", ")
		}
		fmt.Print(item)
	}
	fmt.Println("]")
}

func printEdges(edges []Edge, name string) {
	fmt.Printf("%s: [", name)
	for i, edge := range edges {
		if i > 0 {
			fmt.Print(", ")
		}
		fmt.Printf("(%d, %d, %.2f)", edge.u, edge.v, edge.weight)
	}
	fmt.Println("]")
}

func printGraph(graph [][]float64, name string) {
	fmt.Printf("%s: {\n", name)
	n := len(graph)
	for i := 0; i < n; i++ {
		fmt.Printf("  %d: {", i)
		first := true
		for j := 0; j < n; j++ {
			if i != j {
				if !first {
					fmt.Print(", ")
				}
				fmt.Printf("%d: %.2f", j, graph[i][j])
				first = false
			}
		}
		comma := ""
		if i != n-1 {
			comma = ","
		}
		fmt.Printf("}%s\n", comma)
	}
	fmt.Println("}")
}

// --- Euclidean Distance ---
func getLength(p1, p2 Point) float64 {
	dx := p1.x - p2.x
	dy := p1.y - p2.y
	return math.Sqrt(dx*dx + dy*dy)
}

// --- Build Complete Graph (Adjacency Matrix) ---
func buildGraph(data []Point) [][]float64 {
	n := len(data)
	graph := make([][]float64, n)
	for i := range graph {
		graph[i] = make([]float64, n)
	}
	
	for i := 0; i < n; i++ {
		for j := i + 1; j < n; j++ { // Only calculate upper triangle + diagonal is 0
			dist := getLength(data[i], data[j])
			graph[i][j] = dist
			graph[j][i] = dist // Symmetric graph
		}
	}
	return graph
}

// --- Union-Find Data Structure ---
type UnionFind struct {
	parent []int
	rank   []int
}

func NewUnionFind(n int) *UnionFind {
	parent := make([]int, n)
	rank := make([]int, n)
	for i := range parent {
		parent[i] = i
	}
	return &UnionFind{parent, rank}
}

func (uf *UnionFind) Find(i int) int {
	if uf.parent[i] == i {
		return i
	}
	// Path compression
	uf.parent[i] = uf.Find(uf.parent[i])
	return uf.parent[i]
}

func (uf *UnionFind) Unite(i, j int) {
	rootI := uf.Find(i)
	rootJ := uf.Find(j)
	if rootI != rootJ {
		// Union by rank
		if uf.rank[rootI] < uf.rank[rootJ] {
			uf.parent[rootI] = rootJ
		} else if uf.rank[rootI] > uf.rank[rootJ] {
			uf.parent[rootJ] = rootI
		} else {
			uf.parent[rootJ] = rootI
			uf.rank[rootI]++
		}
	}
}

// --- Minimum Spanning Tree (Kruskal's Algorithm) ---
func minimumSpanningTree(graph [][]float64) []Edge {
	n := len(graph)
	if n == 0 {
		return []Edge{}
	}

	edges := []Edge{}
	for i := 0; i < n; i++ {
		for j := i + 1; j < n; j++ { // Avoid duplicates and self-loops
			edges = append(edges, Edge{i, j, graph[i][j]})
		}
	}

	// Sort edges by weight
	sort.Slice(edges, func(i, j int) bool {
		return edges[i].weight < edges[j].weight
	})

	mst := []Edge{}
	uf := NewUnionFind(n)
	edgesCount := 0

	for _, edge := range edges {
		if uf.Find(edge.u) != uf.Find(edge.v) {
			mst = append(mst, edge)
			uf.Unite(edge.u, edge.v)
			edgesCount++
			if edgesCount == n-1 { // Optimization: MST has n-1 edges
				break
			}
		}
	}
	return mst
}

// --- Find Vertices with Odd Degree in MST ---
func findOddVertexes(mst []Edge, n int) []int {
	degree := make([]int, n)
	for _, edge := range mst {
		degree[edge.u]++
		degree[edge.v]++
	}

	oddVertices := []int{}
	for i := 0; i < n; i++ {
		if degree[i]%2 != 0 {
			oddVertices = append(oddVertices, i)
		}
	}
	return oddVertices
}

// --- Minimum Weight Matching (Greedy Heuristic) ---
func minimumWeightMatching(mst []Edge, graph [][]float64, oddVertices []int) []Edge {
	// Create a copy to allow modification while iterating
	currentOdd := make([]int, len(oddVertices))
	copy(currentOdd, oddVertices)

	// Shuffle for randomness
	rand.Seed(time.Now().UnixNano())
	rand.Shuffle(len(currentOdd), func(i, j int) {
		currentOdd[i], currentOdd[j] = currentOdd[j], currentOdd[i]
	})

	// Keep track of vertices already matched in this phase
	matched := make([]bool, len(graph))
	result := make([]Edge, len(mst))
	copy(result, mst)

	for i := 0; i < len(currentOdd); i++ {
		v := currentOdd[i]
		if matched[v] {
			continue // Skip if already matched
		}

		minLength := math.Inf(1)
		closestU := -1

		// Find the closest unmatched odd vertex
		for j := i + 1; j < len(currentOdd); j++ {
			u := currentOdd[j]
			if !matched[u] { // Check if 'u' is available
				if graph[v][u] < minLength {
					minLength = graph[v][u]
					closestU = u
				}
			}
		}

		if closestU != -1 {
			// Add the matching edge to the MST list (now a multigraph)
			result = append(result, Edge{v, closestU, minLength})
			matched[v] = true
			matched[closestU] = true // Mark both as matched
		}
	}
	
	return result
}

// --- Find Eulerian Tour (Hierholzer's Algorithm) ---
func findEulerianTour(matchedMst []Edge, n int) []int {
	if len(matchedMst) == 0 {
		return []int{}
	}

	// Build adjacency list representation of the multigraph (MST + matching)
	type EdgeInfo struct {
		neighbor int
		edgePtr  *Edge
	}
	
	adj := make([][]EdgeInfo, n)
	edgeUsed := make(map[*Edge]bool)

	for i := range matchedMst {
		edge := &matchedMst[i]
		adj[edge.u] = append(adj[edge.u], EdgeInfo{edge.v, edge})
		adj[edge.v] = append(adj[edge.v], EdgeInfo{edge.u, edge})
		edgeUsed[edge] = false
	}

	tour := []int{}
	currentPath := []int{}

	// Start at any vertex with edges (e.g., the first vertex of the first edge)
	startNode := matchedMst[0].u
	currentPath = append(currentPath, startNode)
	
	for len(currentPath) > 0 {
		currentNode := currentPath[len(currentPath)-1]
		foundEdge := false

		// Find an unused edge from the current node
		for i := 0; i < len(adj[currentNode]); i++ {
			neighbor := adj[currentNode][i].neighbor
			edgePtr := adj[currentNode][i].edgePtr

			if !edgeUsed[edgePtr] {
				edgeUsed[edgePtr] = true // Mark edge as used

				// Push neighbor onto stack and move to it
				currentPath = append(currentPath, neighbor)
				foundEdge = true
				break // Move to the neighbor
			}
		}

		// If no unused edge was found from currentNode, backtrack
		if !foundEdge {
			tour = append(tour, currentPath[len(currentPath)-1])
			currentPath = currentPath[:len(currentPath)-1]
		}
	}

	// Reverse the tour
	for i, j := 0, len(tour)-1; i < j; i, j = i+1, j-1 {
		tour[i], tour[j] = tour[j], tour[i]
	}
	
	return tour
}

// --- Main TSP Function (Christofides Approximation) ---
func tsp(data []Point) (float64, []int) {
  //fmt.Printf("%s\n", "step in `tsp` function")

	n := len(data)
	if n == 0 {
		return 0.0, []int{}
	}
	if n == 1 {
		return 0.0, []int{data[0].id}
	}

	// Build a graph
	G := buildGraph(data)
	//printGraph(G, "Graph")

	// Build a minimum spanning tree
	MSTree := minimumSpanningTree(G)
	printEdges(MSTree, "MSTree")

	// Find odd degree vertices
	oddVertexes := findOddVertexes(MSTree, n)
	printContainer(oddVertexes, "Odd vertexes in MSTree")

	// Add minimum weight matching edges (using greedy heuristic)
	// Note: This returns a new slice containing MST + matching edges
	MSTreeWithMatching := minimumWeightMatching(MSTree, G, oddVertexes)
	printEdges(MSTreeWithMatching, "Minimum weight matching (MST + Matching Edges)")

	// Find an Eulerian tour in the combined graph
	eulerianTour := findEulerianTour(MSTreeWithMatching, n)
	printContainer(eulerianTour, "Eulerian tour")

	// --- Create Hamiltonian Circuit by Skipping Visited Nodes ---
	if len(eulerianTour) == 0 {
		fmt.Println("Error: Eulerian tour could not be found.")
		return -1.0, []int{}
	}

	path := []int{}
	length := 0.0
	visited := make([]bool, n)

	current := eulerianTour[0]
	path = append(path, current)
	visited[current] = true

	for i := 1; i < len(eulerianTour); i++ {
		v := eulerianTour[i]
		if !visited[v] {
			path = append(path, v)
			visited[v] = true
			length += G[current][v] // Add distance from previous node in path
			current = v             // Update current node in path
		}
	}

	// Add the edge back to the start
	length += G[current][path[0]]
	path = append(path, path[0]) // Complete the cycle

	printContainer(path, "Result path")
	fmt.Printf("Result length of the path: %.2f\n", length)

	return length, path
}

func main() {
	// Input data matching the C++ example
	rawData := [][]float64{
		{1380, 939}, {2848, 96}, {3510, 1671}, {457, 334}, {3888, 666}, {984, 965}, {2721, 1482}, {1286, 525},
		{2716, 1432}, {738, 1325}, {1251, 1832}, {2728, 1698}, {3815, 169}, {3683, 1533}, {1247, 1945}, {123, 862},
		{1234, 1946}, {252, 1240}, {611, 673}, {2576, 1676}, {928, 1700}, {53, 857}, {1807, 1711}, {274, 1420},
		{2574, 946}, {178, 24}, {2678, 1825}, {1795, 962}, {3384, 1498}, {3520, 1079}, {1256, 61}, {1424, 1728},
		{3913, 192}, {3085, 1528}, {2573, 1969}, {463, 1670}, {3875, 598}, {298, 1513}, {3479, 821}, {2542, 236},
		{3955, 1743}, {1323, 280}, {3447, 1830}, {2936, 337}, {1621, 1830}, {3373, 1646}, {1393, 1368},
		{3874, 1318}, {938, 955}, {3022, 474}, {2482, 1183}, {3854, 923}, {376, 825}, {2519, 135}, {2945, 1622},
		{953, 268}, {2628, 1479}, {2097, 981}, {890, 1846}, {2139, 1806}, {2421, 1007}, {2290, 1810}, {1115, 1052},
		{2588, 302}, {327, 265}, {241, 341}, {1917, 687}, {2991, 792}, {2573, 599}, {19, 674}, {3911, 1673},
		{872, 1559}, {2863, 558}, {929, 1766}, {839, 620}, {3893, 102}, {2178, 1619}, {3822, 899}, {378, 1048},
		{1178, 100}, {2599, 901}, {3416, 143}, {2961, 1605}, {611, 1384}, {3113, 885}, {2597, 1830}, {2586, 1286},
		{161, 906}, {1429, 134}, {742, 1025}, {1625, 1651}, {1187, 706}, {1787, 1009}, {22, 987}, {3640, 43},
		{3756, 882}, {776, 392}, {1724, 1642}, {198, 1810}, {3950, 1558},
	}

	dataPoints := make([]Point, len(rawData))
	for i, point := range rawData {
		dataPoints[i] = Point{point[0], point[1], i}
	}

	tsp(dataPoints)
}
