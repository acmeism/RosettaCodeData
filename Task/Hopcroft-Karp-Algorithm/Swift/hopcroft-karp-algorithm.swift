import Foundation

// Setting a large value for infinity
let INF = Int.max
// Using 0 as the NIL node
let NIL = 0

class HKGraph {
    /**
     Implementation of the Hopcroft-Karp algorithm for finding maximum matching
     in a bipartite graph.

     Assumes vertices in the left partition (U) are numbered 1 to m,
     and vertices in the right partition (V) are numbered 1 to n.
     The NIL node is represented by 0.
     */

    private var m: Int  // Number of vertices on the left side (U)
    private var n: Int  // Number of vertices on the right side (V)

    // Adjacency list: adj[u] contains list of neighbors of u in V
    private var adj: [[Int]]

    // Matching pairs:
    // pair_u[u] stores the vertex v in V matched with u in U (or NIL if unmatched)
    private var pair_u: [Int]
    // pair_v[v] stores the vertex u in U matched with v in V (or NIL if unmatched)
    private var pair_v: [Int]

    // dist[u] stores the distance (level) of vertex u in U during BFS
    private var dist: [Int]

    /**
     Constructor for the HKGraph class.

     - Parameters:
         - m: Number of vertices in the left partition (U).
         - n: Number of vertices in the right partition (V).
     */
    init(_ m: Int, _ n: Int) {
        self.m = m
        self.n = n

        // Initialize with empty lists for vertices 1 to m
        self.adj = Array(repeating: [Int](), count: m + 1)

        // Initialize matching arrays
        self.pair_u = Array(repeating: NIL, count: m + 1)
        self.pair_v = Array(repeating: NIL, count: n + 1)

        // Initialize distance array
        self.dist = Array(repeating: INF, count: m + 1)
    }

    /**
     Adds a directed edge from vertex u (left partition) to vertex v (right partition).

     - Parameters:
         - u: Vertex index in the left partition (1 to m).
         - v: Vertex index in the right partition (1 to n).
     */
    func addEdge(_ u: Int, _ v: Int) {
        // Ensure vertices are within the valid range
        if 1 <= u && u <= self.m && 1 <= v && v <= self.n {
            self.adj[u].append(v)  // Add v to u's adjacency list
        } else {
            // Optionally print a warning for edges added outside the defined range
            // print("Warning: Attempted to add edge (\(u), \(v)) outside graph bounds [1..\(self.m)], [1..\(self.n)]")
        }
    }

    /**
     Performs Breadth-First Search (BFS) to find layers in the graph.
     It checks if there exists an augmenting path starting from a free vertex in U.

     - Returns: True if an augmenting path might exist (dist[NIL] is finite),
                False otherwise.
     */
    func bfs() -> Bool {
        var queue: [Int] = []

        // Initialize distances for vertices in U
        for u in 1...(self.m) {
            if self.pair_u[u] == NIL {
                // If u is a free vertex, its distance is 0, add to queue
                self.dist[u] = 0
                queue.append(u)
            } else {
                // Otherwise, set distance to infinity initially
                self.dist[u] = INF
            }
        }

        // Distance to the NIL node represents the length of the shortest augmenting path
        self.dist[NIL] = INF

        while !queue.isEmpty {
            let u = queue.removeFirst()  // Dequeue a vertex from U

            // If the path through u can potentially lead to a shorter augmenting path
            if self.dist[u] < self.dist[NIL] {
                // Explore neighbors v of u in V
                for v in self.adj[u] {
                    let matched_u = self.pair_v[v]  // Get the vertex u' matched with v
                    // If the matched vertex u' hasn't been visited yet (its distance is INF)
                    if self.dist[matched_u] == INF {
                        // Set the distance of u' based on u
                        self.dist[matched_u] = self.dist[u] + 1
                        // Enqueue u' to explore further
                        queue.append(matched_u)
                    }
                }
            }
        }

        // If dist[NIL] is still INF, no augmenting path was found originating
        // from the initial free vertices. Otherwise, augmenting paths might exist.
        return self.dist[NIL] != INF
    }

    /**
     Performs Depth-First Search (DFS) starting from vertex u in U
     to find and augment along a shortest path identified by BFS.

     - Parameter u: The current vertex in U being visited (or NIL).
     - Returns: True if an augmenting path was found and used starting from u,
                False otherwise.
     */
    func dfs(_ u: Int) -> Bool {
        if u != NIL {
            // Explore neighbors v of u in V
            for v in self.adj[u] {
                let matched_u = self.pair_v[v]  // Get the vertex u' matched with v
                // Check if the edge (u, v) leads to a vertex u'
                // such that the path u -> v -> u' is part of a shortest augmenting path
                if self.dist[matched_u] == self.dist[u] + 1 {
                    // Recursively call DFS on u'
                    if self.dfs(matched_u) {
                        // If an augmenting path is found starting from u',
                        // update the matching: match v with u, and u with v
                        self.pair_v[v] = u
                        self.pair_u[u] = v
                        return true  // Augmentation successful
                    }
                }
            }

            // If no augmenting path was found starting from u through any neighbor v,
            // mark u as visited in this DFS phase by setting its distance to INF
            self.dist[u] = INF
            return false  // Augmentation failed for this path
        }

        // Base case: If u is NIL, it means we have reached the end of an alternating path
        // originating from a free vertex in U and ending at a free vertex in V (represented by NIL).
        return true
    }

    /**
     Executes the Hopcroft-Karp algorithm to find the maximum matching.

     - Returns: The size of the maximum matching found.
     */
    func hopcroftKarpAlgorithm() -> Int {
        // Initialize matching pairs to NIL (unmatched)
        self.pair_u = Array(repeating: NIL, count: self.m + 1)
        self.pair_v = Array(repeating: NIL, count: self.n + 1)

        var matchingSize = 0  // Initialize the size of the matching

        // Keep finding augmenting paths using BFS and DFS until no more exist
        while self.bfs() {
            // For every free vertex u in U
            for u in 1...(self.m) {
                // If u is free and an augmenting path starting from u is found via DFS
                if self.pair_u[u] == NIL && self.dfs(u) {
                    // Increment the matching size
                    matchingSize += 1
                }
            }
        }

        return matchingSize
    }
}

// --- Testing ---

func tests() {
    print("Running tests...")

    // Test Case 1 (Corrected from C++ version - using 1-based indexing)
    // m=3, n=5, edges = [(1, 4)] - Expected matching size = 1
    let g1 = HKGraph(3, 5)
    g1.addEdge(1, 4)
    let res1 = g1.hopcroftKarpAlgorithm()
    let expected_res1 = 1
    print("Test 1: Result=\(res1), Expected=\(expected_res1)")
    assert(res1 == expected_res1, "Test 1 Failed: Expected \(expected_res1), got \(res1)")

    // Test Case 2 (Corrected from C++ version - using 1-based indexing, assuming (5,0) meant (5,1) or similar valid edge)
    // m=6, n=6, edges = [(1,4), (1,5), (5,1)]
    // Expected matching size = 2 (e.g., (1,4), (5,1) or (1,5), (5,1))
    // Note: Original C++ test had (0,1) and (5,0) which are problematic with 1-based index logic.
    let g2 = HKGraph(6, 6)
    // g3.addEdge(0,1) // Invalid vertex 0 in U
    g2.addEdge(1, 4)
    g2.addEdge(1, 5)
    g2.addEdge(5, 1)  // Assuming (5,0) meant a valid edge like (5,1)
    // g2.addEdge(5, 0) // Invalid vertex 0 in V
    let res2 = g2.hopcroftKarpAlgorithm()
    let expected_res2 = 2
    print("Test 2: Result=\(res2), Expected=\(expected_res2)")
    assert(res2 == expected_res2, "Test 2 Failed: Expected \(expected_res2), got \(res2)")

    // Test Case 3: Complete Bipartite Graph K_{3,3}
    // m=3, n=3, all possible edges. Expected matching size = 3
    let g3 = HKGraph(3, 3)
    for i in 1...3 {
        for j in 1...3 {
            g3.addEdge(i, j)
        }
    }
    let res3 = g3.hopcroftKarpAlgorithm()
    let expected_res3 = 3
    print("Test 3: Result=\(res3), Expected=\(expected_res3)")
    assert(res3 == expected_res3, "Test 3 Failed: Expected \(expected_res3), got \(res3)")

    // Test Case 4: No edges
    // m=2, n=2, no edges. Expected matching size = 0
    let g4 = HKGraph(2, 2)
    let res4 = g4.hopcroftKarpAlgorithm()
    let expected_res4 = 0
    print("Test 4: Result=\(res4), Expected=\(expected_res4)")
    assert(res4 == expected_res4, "Test 4 Failed: Expected \(expected_res4), got \(res4)")

    print("All tests passed!")
}

// --- Main execution ---

func main() {
    // Run self-tests first
    tests()
    print("\n--- Running main execution with hard-coded input ---")

    // --- Hard-coded input data ---
    // Example 1: Corresponds to Test Case 2
    let hardcoded_v1 = 4  // Number of vertices in left partition (m)
    let hardcoded_v2 = 4  // Number of vertices in right partition (n)
    let hardcoded_edges = [
        (1, 1),
        (1, 3),
        (2, 3),
        (3, 4),
        (4, 3),
        (4, 2)
    ]
    // Expected output for Example 1: 3

    // Use the selected hardcoded data
    let v1 = hardcoded_v1
    let v2 = hardcoded_v2
    let edges_data = hardcoded_edges
    let e = edges_data.count  // Number of edges is derived from the list

    // Create the graph object
    let g = HKGraph(v1, v2)

    print("Hard-coded graph dimensions: m=\(v1), n=\(v2), edges=\(e)")
    print("Adding hard-coded edges:")

    // Add edges from the hard-coded list
    for (u, v) in edges_data {
        print("  Adding edge: (\(u), \(v))")
        // Add edge only if vertices are within valid 1-based range
        if 1 <= u && u <= v1 && 1 <= v && v <= v2 {
            g.addEdge(u, v)
        } else {
            // This warning is important if hardcoded data might be invalid
            print("Warning: Skipping invalid hard-coded edge (\(u), \(v)) - indices out of range [1..\(v1)] or [1..\(v2)]")
        }
    }

    // Run the Hopcroft-Karp algorithm
    let max_matching_size = g.hopcroftKarpAlgorithm()

    // Print the result
    print("\nMaximum matching size is \(max_matching_size)")
}

// Run the main function
main()
