import "./queue" for Deque

// Setting a large value for infinity.
var INF = Num.maxSafeInteger

// Using 0 as the NIL code
var NIL = 0

/* Implementation of the Hopcroft-Karp algorithm for finding maximum matching
   in a bipartite graph.

   Assumes vertices in the left partition (U) are numbered 1 to m,
   and vertices in the right partition (V) are numbered 1 to n.
   The NIL node is represented by 0. */
class HKGraph {
   // Constructs a new HKGraph object with m vertices in the left partition (U)
   // and n vertices in the right partition (V).
   construct new(m, n) {
        _m = m
        _n = n

        // Adjacency list: _adj[u] contains list of neighbors of u in V
        // Initialize with empty lists for vertices 1 to m.
        _adj = List.filled(m+1, null)
        for (i in 1..m) _adj[i] = []

        // Matching pairs:
        // pairU[u] stores the vertex v in V matched with u in U (or NIL if unmatched).
        _pairU = List.filled(m+1, NIL)
        // pairV[v] stores the vertex u in U matched with v in V (or NIL if unmatched).
        _pairV = List.filled(n+1, NIL)

        // _dist[u] stores the distance (level) of vertex u in U during BFS.
        // Initialized within the hopcroftKarp or bfs methods.
        _dist = List.filled(m+1, INF)
    }

    // Adds a directed edge from vertex u (left partition) to vertex v (right partition).
    addEdge(u, v) {
        // Ensure vertices are within the valid range.
        if (1 <= u && u <= _m && 1 <= v && v <= _n) {
            _adj[u].add(v)  // add v to u's adjacency list
        } else {
            System.print("Warning: Attempted to add edge (%(u), %(v))" +
                        " outside graph bounds [1..%(m)], [1..%(n)]")
        }
    }

    // Performs Breadth-First Search (BFS) to find layers in the graph.
    // It checks if there exists an augmenting path starting from a free vertex in U.
    // Returns true if an augmenting path might exist (_dist[NIL] is finite),
    // false otherwise.
    bfs() {
        var queue = Deque.new()  // use deque for efficient queue operations

        // Initialize distances for vertices in U.
        for (u in 1.._m) {
            if (_pairU[u] == NIL) {
                // If u is a free vertex, its distance is 0, add to queue.
                _dist[u] = 0
                queue.pushBack(u)
            } else {
                // Otherwise, set distance to infinity initially.
                _dist[u] = INF
            }
        }

        // Distance to the NIL node represents the length of the shortest augmenting path.
        _dist[NIL] = INF

        while (!queue.isEmpty) {
            var u = queue.popFront()  // dequeue a vertex from U

            // If the path through u can potentially lead to a shorter augmenting path:
            if (_dist[u] < _dist[NIL]) {
                // Explore neighbors v of u in V.
                for (v in _adj[u]) {
                    var matchedU = _pairV[v]  // get the vertex u' matched with v
                    // If the matched vertex u' hasn't been visited yet (its distance is INF):
                    if (_dist[matchedU] == INF) {
                        // Set the distance of u' based on u.
                        _dist[matchedU] = _dist[u] + 1
                        // Enqueue u' to explore further.
                        queue.pushBack(matchedU)
                    }
                }
            }
        }

        // If _dist[NIL] is still INF, no augmenting path was found originating
        // from the initial free vertices. Otherwise, augmenting paths might exist.
        return _dist[NIL] != INF
    }

    // Performs Depth-First Search (DFS) starting from vertex u in U
    // to find and augment along a shortest path identified by BFS.
    // Returns true if an augmenting path was found and used starting from u,
    // false otherwise.
    dfs(u) {
        if (u != NIL) {
            // Explore neighbors v of u in V.
            for (v in _adj[u]) {
                var matchedU = _pairV[v]  // get the vertex u' matched with v
                // Check if the edge (u, v) leads to a vertex u'
                // such that the path u -> v -> u' is part of a shortest augmenting path.
                if (_dist[matchedU] == _dist[u] + 1) {
                    // Recursively call DFS on u'.
                    if (dfs(matchedU)) {
                        // If an augmenting path is found starting from u',
                        // update the matching: match v with u, and u with v.
                        _pairV[v] = u
                        _pairU[u] = v
                        return true  // augmentation successful
                    }
                }
            }

            // If no augmenting path was found starting from u through any neighbor v,
            // mark u as visited in this DFS phase by setting its distance to INF.
            _dist[u] = INF
            return false  // augmentation failed for this path
        }

        // Base case: If u is NIL, it means we have reached the end of an alternating path
        // originating from a free vertex in U and ending at a free vertex in V (represented by NIL).
        return true
    }

    // Executes the Hopcroft-Karp algorithm to find the maximum matching and returns its size.
    hopcroftKarp() {
        // Initialize matching pairs to NIL (unmatched).
        _pairU = List.filled(_m+1, NIL)
        _pairV = List.filled(_n+1, NIL)

        var matchingSize = 0  // initialize the size of the matching

        // Keep finding augmenting paths using BFS and DFS until no more exist.
        while (bfs()) {
            // For every free vertex u in U:
            for (u in 1.._m) {
                // If u is free and an augmenting path starting from u is found via DFS:
                if (_pairU[u] == NIL && dfs(u)) {
                    // Increment the matching size.
                    matchingSize = matchingSize + 1
                }
            }
        }

        return matchingSize
    }
}

// --- Testing ---

// Runs test cases for the Hopcroft-Karp implementation.
var tests = Fn.new {
    System.print("Running tests...")
    var success = 0

    // Test Case 1
    // m=3, n=5, edges = [(1, 4)] - Expected matching size = 1.
    var g1 = HKGraph.new(3, 5)
    g1.addEdge(1, 4)
    var res1 = g1.hopcroftKarp()
    var expectedRes1 = 1
    System.print("Test 1: Result = %(res1), Expected = %(expectedRes1)")
    if (res1 != expectedRes1) System.print("So test 1 Failed.") else success = success + 1

    // Test Case 2
    // m=6, n=6, edges = [(1,4), (1,5), (5,1)]
    // Expected matching size = 2 (e.g., (1,4), (5,1) or (1,5), (5,1)).
    var g2 = HKGraph.new(6, 6)
    g2.addEdge(1, 4)
    g2.addEdge(1, 5)
    g2.addEdge(5, 1)
    var res2 = g2.hopcroftKarp()
    var expectedRes2 = 2
    System.print("Test 2: Result = %(res2), Expected = %(expectedRes2)")
    if (res2 != expectedRes2) System.print("So test 2 failed") else success = success + 1

    // Test Case 3: Complete Bipartite Graph K_{3,3}
    // m=3, n=3, all possible edges. Expected matching size = 3.
    var g3 = HKGraph.new(3, 3)
    for (i in 1..3) {
        for (j in 1..3) g3.addEdge(i, j)
    }
    var res3 = g3.hopcroftKarp()
    var expectedRes3 = 3
    System.print("Test 3: Result = %(res3), Expected = %(expectedRes3)")
    if (res3 != expectedRes3) System.print("So test 3 failed") else success = success + 1

    // Test Case 4: No edges
    // m=2, n=2, no edges. Expected matching size = 0.
    var g4 = HKGraph.new(2, 2)
    var res4 = g4.hopcroftKarp()
    var expectedRes4 = 0
    System.print("Test 4: Result = %(res4), Expected = %(expectedRes4)")
    if (res4 != expectedRes4) System.print("So test 4 Failed") else success = success + 1

    if (success == 4) System.print("All tests passed!")
}

// --- Main execution ---

// Run self-tests first.
tests.call()

System.print("\n--- Running main execution with hard-coded input ---")

// --- Hard-coded input data ---
// Example 1: Corresponds to Test Case 2.
var hardcodedV1 = 4  // mumber of vertices in left partition (m)
var hardcodedV2 = 4  // number of vertices in right partition (n)
var hardcodedEdges = [ [1, 1], [1, 3], [2, 3], [3, 4], [4, 3], [4, 2] ]
// Expected output for Example 1: 3.

// Use the selected hardcoded data.
var v1 = hardcodedV1
var v2 = hardcodedV2
var edgesData = hardcodedEdges
var e = edgesData.count  // number of edges is derived from the list

// Create the graph object.
var g = HKGraph.new(v1, v2)

System.print("Hard-coded graph dimensions: m=%(v1), n=%(v2), edges=%(e)")
System.print("Adding hard-coded edges:")

// Add edges from the hard-coded list.
for (edge in edgesData) {
    var u = edge[0]
    var v = edge[1]
    System.print("  Adding edge: (%(u), %(v))")
    // Add edge only if vertices are within valid 1-based range.
    if (1 <= u && u <= v1 && 1 <= v && v <= v2) {
        g.addEdge(u, v)
    } else {
        // This warning is important if hardcoded data might be invalid.
        System.print("Warning: Skipping invalid hard-coded edge (%(u), %(v)) - " +
                     "indices out of range [1..%(v1)] or [1..%(v2)]")
    }
}
// Run the Hopcroft-Karp algorithm.
var maxMatchingSize = g.hopcroftKarp()

// Print the result.
System.print("\nMaximum matching size is %(maxMatchingSize)")
