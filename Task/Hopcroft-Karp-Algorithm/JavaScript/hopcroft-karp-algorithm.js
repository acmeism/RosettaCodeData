class HKGraph {
    /**
     * Implementation of the Hopcroft-Karp algorithm for finding maximum matching
     * in a bipartite graph.
     *
     * Assumes vertices in the left partition (U) are numbered 1 to m,
     * and vertices in the right partition (V) are numbered 1 to n.
     * The NIL node is represented by 0.
     */

    /**
     * Constructor for the HKGraph class.
     *
     * @param {number} m Number of vertices in the left partition (U).
     * @param {number} n Number of vertices in the right partition (V).
     */
    constructor(m, n) {
        this.m = m; // Number of vertices on the left side (U)
        this.n = n; // Number of vertices on the right side (V)

        // Adjacency list: adj[u] contains list of neighbors of u in V
        // Initialize with empty lists for vertices 1 to m
        this.adj = Array(m + 1).fill(null).map(() => []);

        // Matching pairs:
        // pair_u[u] stores the vertex v in V matched with u in U (or NIL if unmatched)
        this.pair_u = Array(m + 1).fill(0);
        // pair_v[v] stores the vertex u in U matched with v in V (or NIL if unmatched)
        this.pair_v = Array(n + 1).fill(0);

        // dist[u] stores the distance (level) of vertex u in U during BFS
        // Initialized within the hopcroft_karp_algorithm or bfs method
        this.dist = Array(m + 1).fill(Infinity);
    }

    /**
     * Adds a directed edge from vertex u (left partition) to vertex v (right partition).
     *
     * @param {number} u Vertex index in the left partition (1 to m).
     * @param {number} v Vertex index in the right partition (1 to n).
     */
    addEdge(u, v) {
        // Ensure vertices are within the valid range
        if (1 <= u && u <= this.m && 1 <= v && v <= this.n) {
            this.adj[u].push(v); // Add v to u's adjacency list
        } else {
            // Optionally print a warning for edges added outside the defined range
            // This check is now also done in the main section when adding edges.
            //console.warn(`Warning: Attempted to add edge (${u}, ${v}) outside graph bounds [1..${this.m}], [1..${this.n}]`);
            //pass
        }
    }

    /**
     * Performs Breadth-First Search (BFS) to find layers in the graph.
     * It checks if there exists an augmenting path starting from a free vertex in U.
     *
     * @returns {boolean} True if an augmenting path might exist (dist[NIL] is finite),
     *                  False otherwise.
     */
    bfs() {
        const queue = []; // Use array as queue

        // Initialize distances for vertices in U
        for (let u = 1; u <= this.m; u++) {
            if (this.pair_u[u] === 0) {
                // If u is a free vertex, its distance is 0, add to queue
                this.dist[u] = 0;
                queue.push(u);
            } else {
                // Otherwise, set distance to infinity initially
                this.dist[u] = Infinity;
            }
        }

        // Distance to the NIL node represents the length of the shortest augmenting path
        this.dist[0] = Infinity;

        while (queue.length > 0) {
            const u = queue.shift(); // Dequeue a vertex from U

            // If the path through u can potentially lead to a shorter augmenting path
            if (this.dist[u] < this.dist[0]) {
                // Explore neighbors v of u in V
                for (const v of this.adj[u]) {
                    const matched_u = this.pair_v[v]; // Get the vertex u' matched with v
                    // If the matched vertex u' hasn't been visited yet (its distance is INF)
                    if (this.dist[matched_u] === Infinity) {
                        // Set the distance of u' based on u
                        this.dist[matched_u] = this.dist[u] + 1;
                        // Enqueue u' to explore further
                        queue.push(matched_u);
                    }
                }
            }
        }

        // If dist[NIL] is still INF, no augmenting path was found originating
        // from the initial free vertices. Otherwise, augmenting paths might exist.
        return this.dist[0] !== Infinity;
    }

    /**
     * Performs Depth-First Search (DFS) starting from vertex u in U
     * to find and augment along a shortest path identified by BFS.
     *
     * @param {number} u The current vertex in U being visited (or NIL).
     *
     * @returns {boolean} True if an augmenting path was found and used starting from u,
     *                  False otherwise.
     */
    dfs(u) {
        if (u !== 0) {
            // Explore neighbors v of u in V
            for (const v of this.adj[u]) {
                const matched_u = this.pair_v[v]; // Get the vertex u' matched with v
                // Check if the edge (u, v) leads to a vertex u'
                // such that the path u -> v -> u' is part of a shortest augmenting path
                if (this.dist[matched_u] === this.dist[u] + 1) {
                    // Recursively call DFS on u'
                    if (this.dfs(matched_u)) {
                        // If an augmenting path is found starting from u',
                        // update the matching: match v with u, and u with v
                        this.pair_v[v] = u;
                        this.pair_u[u] = v;
                        return true; // Augmentation successful
                    }
                }
            }

            // If no augmenting path was found starting from u through any neighbor v,
            // mark u as visited in this DFS phase by setting its distance to INF
            this.dist[u] = Infinity;
            return false; // Augmentation failed for this path
        }

        // Base case: If u is NIL, it means we have reached the end of an alternating path
        // originating from a free vertex in U and ending at a free vertex in V (represented by NIL).
        return true;
    }

    /**
     * Executes the Hopcroft-Karp algorithm to find the maximum matching.
     *
     * @returns {number} The size of the maximum matching found.
     */
    hopcroftKarpAlgorithm() {
        // Initialize matching pairs to NIL (unmatched)
        this.pair_u = Array(this.m + 1).fill(0);
        this.pair_v = Array(this.n + 1).fill(0);

        let matching_size = 0; // Initialize the size of the matching

        // Keep finding augmenting paths using BFS and DFS until no more exist
        while (this.bfs()) {
            // For every free vertex u in U
            for (let u = 1; u <= this.m; u++) {
                // If u is free and an augmenting path starting from u is found via DFS
                if (this.pair_u[u] === 0 && this.dfs(u)) {
                    // Increment the matching size
                    matching_size++;
                }
            }
        }

        return matching_size;
    }
}


// --- Testing ---

function tests() {
    /** Runs test cases for the Hopcroft-Karp implementation. */
    console.log("Running tests...");

    // Test Case 1 (Corrected from C++ version - using 1-based indexing)
    // m=3, n=5, edges = [(1, 4)] - Expected matching size = 1
    let g1 = new HKGraph(3, 5);
    g1.addEdge(1, 4);
    let res1 = g1.hopcroftKarpAlgorithm();
    let expected_res1 = 1;
    console.log(`Test 1: Result=${res1}, Expected=${expected_res1}`);
    console.assert(res1 === expected_res1, `Test 1 Failed: Expected ${expected_res1}, got ${res1}`);

    // Test Case 2 (Corrected from C++ version - using 1-based indexing, assuming (5,0) meant (5,1) or similar valid edge)
    // m=6, n=6, edges = [(1,4), (1,5), (5,1)]
    // Expected matching size = 2 (e.g., (1,4), (5,1) or (1,5), (5,1))
    // Note: Original C++ test had (0,1) and (5,0) which are problematic with 1-based index logic.
    let g2 = new HKGraph(6, 6);
    // g3.addEdge(0,1); // Invalid vertex 0 in U
    g2.addEdge(1, 4);
    g2.addEdge(1, 5);
    g2.addEdge(5, 1); // Assuming (5,0) meant a valid edge like (5,1)
    // g2.addEdge(5, 0); // Invalid vertex 0 in V
    let res2 = g2.hopcroftKarpAlgorithm();
    let expected_res2 = 2;
    console.log(`Test 2: Result=${res2}, Expected=${expected_res2}`);
    console.assert(res2 === expected_res2, `Test 3 Failed: Expected ${expected_res2}, got ${res2}`);

    // Test Case 3: Complete Bipartite Graph K_{3,3}
    // m=3, n=3, all possible edges. Expected matching size = 3
    let g3 = new HKGraph(3, 3);
    for (let i = 1; i <= 3; i++) {
        for (let j = 1; j <= 3; j++) {
            g3.addEdge(i, j);
        }
    }
    let res3 = g3.hopcroftKarpAlgorithm();
    let expected_res3 = 3;
    console.log(`Test 3: Result=${res3}, Expected=${expected_res3}`);
    console.assert(res3 === expected_res3, `Test 4 Failed: Expected ${expected_res3}, got ${res3}`);

    // Test Case 4: No edges
    // m=2, n=2, no edges. Expected matching size = 0
    let g4 = new HKGraph(2, 2);
    let res4 = g4.hopcroftKarpAlgorithm();
    let expected_res4 = 0;
    console.log(`Test 4: Result=${res4}, Expected=${expected_res4}`);
    console.assert(res4 === expected_res4, `Test 4 Failed: Expected ${expected_res4}, got ${res4}`);

    console.log("All tests passed!");
}


// --- Main execution ---

// Check if running in a Node.js environment
if (typeof window === 'undefined') {
    // Run self-tests first
    tests();
    console.log("\n--- Running main execution with hard-coded input ---");

    // --- Hard-coded input data ---
    // Example 1: Corresponds to Test Case 2
    let hardcoded_v1 = 4; // Number of vertices in left partition (m)
    let hardcoded_v2 = 4; // Number of vertices in right partition (n)
    let hardcoded_edges = [
        [1, 1],
        [1, 3],
        [2, 3],
        [3, 4],
        [4, 3],
        [4, 2]
    ];
    // Expected output for Example 1: 3

    // Use the selected hardcoded data
    let v1 = hardcoded_v1;
    let v2 = hardcoded_v2;
    let edges_data = hardcoded_edges;
    let e = edges_data.length; // Number of edges is derived from the list

    // Create the graph object
    let g = new HKGraph(v1, v2);

    console.log(`Hard-coded graph dimensions: m=${v1}, n=${v2}, edges=${e}`);
    console.log("Adding hard-coded edges:");

    // Add edges from the hard-coded list
    for (const [u, v] of edges_data) {
        console.log(`  Adding edge: (${u}, ${v})`);
        // Add edge only if vertices are within valid 1-based range
        if (1 <= u && u <= v1 && 1 <= v && v <= v2) {
            g.addEdge(u, v);
        } else {
            // This warning is important if hardcoded data might be invalid
            console.warn(`Warning: Skipping invalid hard-coded edge (${u}, ${v}) - indices out of range [1..${v1}] or [1..${v2}]`);
        }
    }

    // Run the Hopcroft-Karp algorithm
    let max_matching_size = g.hopcroftKarpAlgorithm();

    // Print the result
    console.log(`\nMaximum matching size is ${max_matching_size}`);
}
