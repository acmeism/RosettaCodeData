var INF = Num.infinity

/*  Runs Bellman-Ford algorithm from a source vertex.

    Args:
        numVertices: The total number of vertices (including the augmented source).
        edges: A list of tuples (u, v, weight) representing directed edges.
        source: The index of the source vertex.

    Returns:
        A list of shortest distances 'h' from the source to all other vertices,
        or null if a negative cycle is detected.
*/
var bellmanFord = Fn.new { |numVertices, edges, source|
    var dist = List.filled(numVertices, INF)
    dist[source] = 0

    // Relax edges V - 1 times.
    for (i in 0...numVertices - 1) {
        var updated = false
        for (e in edges) {
            var u = e[0]
            var v = e[1]
            var w = e[2]
            if (dist[u] != INF && dist[u] + w < dist[v]) {
                dist[v] = dist[u] + w
                updated = true
            }
        }
        // If no update in a full pass, we can stop early.
        if (!updated) break
    }

    // Check for negative cycles.
    for (e in edges) {
        var u = e[0]
        var v = e[1]
        var w = e[2]
        if (dist[u] != INF && dist[u] + w < dist[v]) {
            System.print("Graph contains a negative weight cycle")
            return null // indicate negative cycle
        }
    }
    return dist
}

/*  Runs Dijkstra's algorithm on a potentially re-weighted graph.

    Args:
        numVertices: The number of vertices in the original graph.
        adj: Adjacency list of the re-weighted graph.
        source: The source vertex index for this run.
        hValues: The potential values calculated by Bellman-Ford.

    Returns:
        A list of shortest path distances from the source in the original graph.
*/
var dijkstra = Fn.new { |numVertices, adj, source, hValues|
    var dist = List.filled(numVertices, INF)
    dist[source] = 0

    // Priority queue stores (distance, vertex).
    var pq = [[0, source]]

    var finalDist = List.filled(numVertices, INF)  // to store results
    while (!pq.isEmpty) {
        var du = pq.removeAt(0)
        var d = du[0]
        var u = du[1]
        // If we found a shorter path already, skip.
        if (d > dist[u]) continue

        // Store the final shortest path distance (translated back).
        // This check prevents processing nodes disconnected from source.
        if (finalDist[u] == INF) {
            if (dist[u] == INF) {  // Should not happen if popped from pq, but safety check
                finalDist[u] = INF
            } else {
                // Translate distance back to original weight: d(u,v) = d'(u,v) - h[u] + h[v]
                // Here, d'(source, u) is dist[u]
                // So, original distance = dist[u] - h[source] + h[u]
                finalDist[u] = dist[u] - hValues[source] + hValues[u]
            }
        }

        // Relax edges outgoing from u.
        if (adj.containsKey(u)) {
            for (vr in adj[u]) {
                var v = vr[0]
                var rw = vr[1]
                if (dist[u] != INF && dist[u] + rw < dist[v]) {
                    dist[v] = dist[u] + rw
                    pq.add([dist[v], v])
                    pq.sort { |a, b| a[0] < b[0] }
                }
            }
        }
    }

    // After Dijkstra finishes, translate any remaining reachable vertices.
    // This handles cases where a node might be reachable but wasn't the
    // minimum popped from PQ when its final distance was determined.
    for (i in 0...numVertices) {
        if (finalDist[i] == INF && dist[i] != INF) {
            finalDist[i] = dist[i] - hValues[source] + hValues[i]
        }
    }

    return finalDist
}

/* Implements Johnson's algorithm for all-pairs shortest paths.

    Args:
        graph_matrix: An adjacency matrix representation of the graph.
                      graphMatrix[i][j] is the weight of the edge from i to j.
                      Use 0 for non-existent edges between different nodes (or INF).
                      graphMatrix[i][i] should be 0.

    Returns:
        A matrix containing the shortest path distances between all pairs,
        or null if a negative cycle is detected. Returns INF if no path exists.
*/
var johnsonsAlgorithm = Fn.new { |graphMatrix|
    var V = graphMatrix.count
    var originalEdges = []

    // --- Step 0: Handle Input and Build Edge List for Original Graph ---
    // Be careful about 0 vs non-existent edge. Assume 0 means no edge if i != j.
    for (i in 0...V) {
        for (j in 0...V) {
            var weight = graphMatrix[i][j]
            // Only add edges that exist. Assuming 0 means no edge unless i==j.
            // If 0 could be a valid edge weight, use INF for non-edges in input.
            if (i == j) {
                if (weight != 0) {
                    System.print("Warning: graphMatrix[%(i)][%(i)] is %(weight), expected 0. Setting to 0.")
                }
            } else if (weight != 0) {  // assuming 0 means non-edge here
                originalEdges.add([i, j, weight])
                // If 0 IS a valid weight, the condition should be:
                // else if (weight != INF) { // Use INF in the input matrix for non-edges
                //     originalEdges.add([i, j, weight])
            }
        }
    }

    // --- Step 1: Form the augmented graph G' ---
    // Add a new vertex 's' (index V) with 0-weight edges to all original vertices.
    var augmentedEdges = List.filled(originalEdges.count, null)
    for (i in 0...originalEdges.count) augmentedEdges[i] = originalEdges[i].toList
    for (i in 0...V) {
        augmentedEdges.add([V, i, 0])  // new source V connects to all others
    }

    var numVerticesAugmented = V + 1

    // --- Step 2: Run Bellman-Ford from the new source 's' ---
    var hValues = bellmanFord.call(numVerticesAugmented, augmentedEdges, V)

    if (!hValues) {
        // Negative cycle detected by Bellman-Ford
        return null
    }

    // Remove the h value for the augmented source, we only need it for original vertices.
    hValues = hValues[0...V]  // Keep h[0] to h[V-1]

    // --- Step 3: Reweight the edges ---
    var reweightedAdj = {}
    for (i in 0...V) reweightedAdj[i] = []
    for (e in originalEdges) {
        var u = e[0]
        var v = e[1]
        var w = e[2]
        // Ensure h values are valid before reweighting.
        if (hValues[u] == INF || hValues[v] == INF) {
            // This can happen if the original graph wasn't strongly connected
            // from the augmented source 's'. While not strictly an error for
            // Johnson's (paths might still exist between reachable nodes),
            // it means the reweighting might involve INF.
            // Let's compute the reweighted value anyway; Dijkstra handles INF.
            System.print("Warning: invalid h values detected.")
        }

        var rw = w + hValues[u] - hValues[v]
        // Theoretically, rw should be >= 0 if no negative cycle.
        // Add small tolerance for floating point issues if necessary:
        // if (rw < -1e-9) {
        //     System.print("Warning: Potential negative reweighted edge %(u)->%(v): %(rw)")
        // }
        reweightedAdj[u].add([v, rw])
    }

    // --- Step 4: Run Dijkstra from each vertex on the reweighted graph ---
    var allPairsShortestPaths = (0...V).map { |i| List.filled(V, INF) }.toList

    for (u in 0...V) {
        // Run Dijkstra on the reweighted graph starting from u
        var shortestPathsFromU = dijkstra.call(V, reweightedAdj, u, hValues)
        allPairsShortestPaths[u] = shortestPathsFromU
        // The dijkstra implementation now directly calculates the original distance.
    }

    // --- Step 5: Return the result matrix ---
    return allPairsShortestPaths
}

// --- Test Case ---
var graph = [[0, -5,  2,  3],
             [0,  0,  4,  0],  // assuming 0 means no edge from 1->0 and 1->3
             [0,  0,  0,  1],  // assuming 0 means no edge from 2->0 and 2->1
             [0,  0,  0,  0]]  // assuming 0 means no edge from 3->0, 3->1, 3->2

var result = johnsonsAlgorithm.call(graph)

if (result) {
    System.print("All-pairs shortest paths:")
    for (row in result) {
        System.print(row.toString.replace("infinity", "'INF'"))
    }
} else {
    System.print("Negative cycle detected in the graph.")
}

System.print("\nExpected for the test case:")
System.print("[0, -5, -1, 0]")
System.print("['INF', 0, 4, 5]")
System.print("['INF', 'INF', 0, 1]")
System.print("['INF', 'INF', 'INF', 0]")
