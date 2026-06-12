class Graph {
    // Create a new graph on n vertices (0..n-1), no edges.
    construct new(n) {
        _n = n
        _adj = List.filled(n, null)
        for (i in 0...n) _adj[i] = List.filled(n, false)
    }

    // Properties.
    n   { _n }
    adj { _adj}

    adj=(v) { _adj = v }

    // Return a deep copy of the graph.
    clone() {
        var g2 = Graph.new(_n)
        g2.adj = _adj.map { |row| row.toList }.toList
        return g2
    }

    // Add an undirected edge u--v.
    addEdge(u, v) {
        if (u < 0 || u >= _n || v < 0 || v >= _n) {
            Fiber.abort("Vertex index out of bounds.")
        }
        _adj[u][v] = true
        _adj[v][u] = true
    }

    // Degree of vertex u.
    degree(u) { _adj[u].reduce(0) { |sum, hasEdge| sum + (hasEdge ? 1 : 0) } }

    // Compute the Chvátal closure in-place.
    closure() {
        var n = _n
        while (true) {
            var added = false
            var outer = false
            for (u in 0...n) {
                var v = u + 1
                while (v < n) {
                    if (!_adj[u][v]) {
                        if (degree(u) + degree(v) >= n) {
                            addEdge(u, v)
                            added = true
                            outer = true
                            break
                        }
                    }
                    v = v + 1
                }
                if (outer) break
            }
            if (!added) break
        }
    }

    // Is the graph complete?
    isComplete() {
        for (u in 0...n) {
            var v = u + 1
            while (v < n) {
                if (!this.adj[u][v]) return false
                v = v + 1
            }
        }
        return true
    }

    // Find a Hamiltonian cycle by simple backtracking.
    hamiltonianCycle() {
        var n = _n
        var visited = List.filled(n, false)
        var path = [0]
        visited[0] = true

        var dfs // recursive
        dfs = Fn.new { |u|
            if (path.count == n) {
                // Can we close the cycle?
                if (_adj[u][path[0]]) return path + [path[0]]
                return null
            }
            for (v in 0...n) {
                if (!visited[v] && _adj[u][v]) {
                    visited[v] = true
                    path.add(v)
                    var cycle = dfs.call(v)
                    if (cycle) return cycle
                    // backtrack
                    path.removeAt(-1)
                    visited[v] = false
                }
            }
            return null
        }
        return dfs.call(0)
    }
}

// Example: 5 vertices, almost complete graph missing edge 0--1.
// This satisfies Ore's condition: deg(0)=3, deg(1)=3, 3+3>=5.
var g = Graph.new(5)
// Add all edges except (0,1)
for (u in 0..4) {
    var v = u + 1
    while (v < 5) {
        if (!(u == 0 && v == 1)) g.addEdge(u, v)
        v = v + 1
    }
}

System.print("Original graph degrees:")
for (u in 0...g.n) {
    System.print("  deg(%(u)) = %(g.degree(u))")
}

// Compute closure
var closure = g.clone()
closure.closure()

System.print("\nAfter Chvátal closure:")
for (u in 0...closure.n) {
    var neighbors = []
    for (v in 0...closure.n) {
        if (closure.adj[u][v]) neighbors.add(v)
    }
    System.print("  %(u): %(neighbors.join(" "))")
}

if (closure.isComplete()) {
    System.print("\nClosure is complete ⇒ graph is Hamiltonian (by Bondy–Chvátal).")
    var cycle = g.hamiltonianCycle()
    if (cycle) {
        System.print("Found Hamiltonian cycle in original graph:")
        System.print(cycle.join(" → "))
    } else {
        System.print("Unexpected: could not find a Hamiltonian cycle.")
    }
} else {
    System.print("\nClosure is not complete ⇒ no guarantee of Hamiltonian cycle.")
}
