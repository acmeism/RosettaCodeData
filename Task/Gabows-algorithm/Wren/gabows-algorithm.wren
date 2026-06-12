/* Basic Directed Graph class using adjacency lists.
   Vertices are assumed to be integers from 0 to _v-1. */
class Digraph {
    // Creates a new digraph with v vertices.
    construct new(v) {
        if (v < 0) Fiber.abort("Number of vertices must be non-negative")
        _v = v
        _e = 0
        // use a list of lists for adjacency lists
        _adj = List.filled(v, null)
        for (i in 0...v) _adj[i] = []
    }

    // Returns the number of vertices.
    v { _v }

    // Returns the number of edges.
    e { _e }

    // Private method to validate a vertex.
    validateVertex_(v) {
        if (v < 0 || v >= _v) Fiber.abort("Vertex %(v) is not between 0 and %(_v - 1)")
    }

    // Adds the directed edge v->w to the digraph.
    addEdge(v, w) {
        validateVertex_(v)
        validateVertex_(w)
        _adj[v].add(w)
        _e = _e + 1
    }

    // Returns the list of neighbors adjacent from vertex v.
    adj(v) {
        validateVertex_(v)
        return _adj[v]
    }

    // String representation of the digraph.
    toString {
        var s = "%(_v) vertices, %(_e) edges\n"
        for (v in 0..._v) {
            var sp = v < 10 ? " " : ""
            s = s + "%(sp)%(v): %(_adj[v].join(" "))\n"
        }
        return s
    }
}

/*  Computes strongly connected components (SCCs) in a digraph
    using Gabow's algorithm. */
class GabowSCC {
    // Creates a GabowSCC to compute the strong components of the digraph 'g'.
    construct new(g) {
        _marked     = List.filled(g.v, false)  // marked[v] = has v been visited?
        _id         = List.filled(g.v, -1)     // id[v] = id of strong component containing v
        _preorder   = List.filled(g.v, -1)     // preorder[v] = preorder of v
        _preCounter = 0                        // preorder number counter
        _sccCount   = 0                        // number of strongly connected components
        _stack1     = []                       // stores vertices in order of visitation
        _stack2     = []                       // auxiliary stack for finding SCC roots

        for (v in 0...g.v) if (!_marked[v]) dfs_(g, v)
    }

    // Private method containing 'depth first search' core logic for Gabow's algorithm.
    dfs_(g, v) {
        _marked[v]   = true
        _preorder[v] = _preCounter
        _preCounter  = _preCounter + 1
        _stack1.add(v)
        _stack2.add(v)

        for (w in g.adj(v)) {
            if (!_marked[w]) {
                dfs_(g, w)
            // If w is visited but not yet assigned to an SCC,
            // it means w is on the current DFS path (or in an SCC already processed
            // in this DFS branch, but stack2 handles this).
            } else if (_id[w] == -1) {
                // Pop vertices from stack2 until top has preorder number <= preorder[w].
                // This maintains the invariant that stack2 contains a path of potential SCC roots.
                while (!_stack2.isEmpty && _preorder[_stack2[-1]] > _preorder[w]) _stack2.removeAt(-1)
            }
        }

        // If v is the root of an SCC (i.e., it remains on top of stack2 after
        // exploring all its descendants and back-edges):
        if (!_stack2.isEmpty && _stack2[-1] == v) {
            _stack2.removeAt(-1)
            // Pop vertices from stack1 until v is popped; assign them the current SCC id.
            while (!_stack1.isEmpty) {
                var w = _stack1.removeAt(-1)
                _id[w] = _sccCount
                if (w == v) break
            }
            _sccCount = _sccCount + 1
        }
    }

    // Returns the number of strong components.
    count { _sccCount }

    // Private method to validate a vertex.
    validateVertex_(v) {
        var vc = _marked.count
        if (v < 0 || v >= vc) Fiber.abort("Vertex %(v) is not between 0 and %(vc - 1)")
    }

    // Returns whether or not vertices v and w are in the same strong component.
    stronglyConnected(v, w) {
        validateVertex_(v)
        validateVertex_(w)
        // If either vertex wasn't visited (e.g., in a disconnected graph part),
        // its id will be -1, and they cannot be strongly connected unless
        // the graph is empty or has isolated vertices (handled by id comparison).
        return _id[v] != -1 && _id[v] == _id[w]
    }

    // Returns the component id of the strong component containing vertex v.
    getId(v) {
        validateVertex_(v)
        return _id[v]
    }
}

var numVertices = 13
var g = Digraph.new(numVertices)

var edges = [
    [4, 2], [2, 3], [3, 2], [6, 0], [0, 1], [2, 0], [11, 12],
    [12, 9], [9, 10], [9, 11], [8, 9], [10, 12], [0, 5], [5, 4],
    [3, 5], [6, 4], [6, 9], [7, 6], [7, 8], [8, 7], [5, 3], [0, 6]
]

for (edge in edges) g.addEdge(edge[0], edge[1])
System.print("Constructed Digraph:")
System.print(g)

// --- Compute SCCs ---
var scc = GabowSCC.new(g)

// --- Print results ---
var m = scc.count
System.print("%(m) strongly connected components")

// Group vertices by component ID.
var components = List.filled(m, null)
for (i in 0...m) components[i] = []
for (v in 0...g.v) {
    var componentId = scc.getId(v)
    if (componentId != -1) {  // should always be >= 0 after running constructor
        components[componentId].add(v)
    } else {
        // This case should ideally not happen if all vertices are reachable
        // or handled correctly in the constructor loop. Could represent isolated vertices
        // or issues if the graph was modified after SCC computation.
        System.print("Warning: Vertex %(v) has no SCC ID assigned.")
    }
}

System.print("\nComponents:")
for (i in 0...m) System.print("Component %(i): %(components[i].join(" "))")

// --- Example usage of strongly_connected and get_id ---
System.print("\nConnectivity checks:")
System.print("Vertices 0 and 3 strongly connected?  %(scc.stronglyConnected(0, 3))")  // should be true
System.print("Vertices 0 and 7 strongly connected?  %(scc.stronglyConnected(0, 7))")  // should be false
System.print("Vertices 9 and 12 strongly connected? %(scc.stronglyConnected(9, 12))") // should be true
System.print("ID of vertex 5: %(scc.getId(5))")
System.print("ID of vertex 8: %(scc.getId(8))")
