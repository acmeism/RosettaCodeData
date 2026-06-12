import sys

# Increase recursion depth limit for potentially deep DFS
# Be cautious with this in production, but useful for deep graphs
try:
    sys.setrecursionlimit(2000)
except Exception as e:
    print(f"Warning: Could not set recursion depth limit: {e}")

class Digraph:
    """
    Basic Directed Graph class using adjacency lists.
    Vertices are assumed to be integers from 0 to V-1.
    """
    def __init__(self, V):
        """Initializes an empty digraph with V vertices."""
        if V < 0:
            raise ValueError("Number of vertices must be non-negative")
        self._V = V
        self._E = 0
        # Use a list of lists for adjacency lists
        self._adj = [[] for _ in range(V)]

    def V(self):
        """Returns the number of vertices."""
        return self._V

    def E(self):
        """Returns the number of edges."""
        return self._E

    def _validate_vertex(self, v):
        """Raises ValueError if v is not a valid vertex."""
        if not (0 <= v < self._V):
            raise ValueError(f"vertex {v} is not between 0 and {self._V-1}")

    def add_edge(self, v, w):
        """Adds the directed edge v->w to the digraph."""
        self._validate_vertex(v)
        self._validate_vertex(w)
        self._adj[v].append(w)
        self._E += 1

    def adj(self, v):
        """Returns the list of neighbors adjacent from vertex v."""
        self._validate_vertex(v)
        return self._adj[v]

    def __str__(self):
        """String representation of the digraph."""
        s = f"{self._V} vertices, {self._E} edges\n"
        for v in range(self._V):
            s += f"{v}: {' '.join(map(str, self._adj[v]))}\n"
        return s

class GabowSCC:
    """
    Computes strongly connected components (SCCs) in a digraph
    using Gabow's algorithm.
    """
    def __init__(self, G):
        """
        Computes the strong components of the digraph G.
        :param G: The Digraph object
        """
        self._marked = [False] * G.V()    # marked[v] = has v been visited?
        self._id = [-1] * G.V()           # id[v] = id of strong component containing v
        self._preorder = [-1] * G.V()     # preorder[v] = preorder of v
        self._pre_counter = 0             # preorder number counter
        self._scc_count = 0               # number of strongly-connected components
        self._stack1 = []                 # Stores vertices in order of visitation
        self._stack2 = []                 # Auxiliary stack for finding SCC roots

        for v in range(G.V()):
            if not self._marked[v]:
                self._dfs(G, v)

        # Optional: Add a check function if needed (requires TransitiveClosure)
        # assert self._check(G)

    def _dfs(self, G, v):
        """Depth First Search core logic for Gabow's algorithm."""
        self._marked[v] = True
        self._preorder[v] = self._pre_counter
        self._pre_counter += 1
        self._stack1.append(v)
        self._stack2.append(v)

        for w in G.adj(v):
            if not self._marked[w]:
                self._dfs(G, w)
            # If w is visited but not yet assigned to an SCC,
            # it means w is on the current DFS path (or in an SCC already processed
            # in this DFS branch, but stack2 handles this).
            elif self._id[w] == -1:
                # Pop vertices from stack2 until top has preorder number <= preorder[w]
                # This maintains the invariant that stack2 contains a path of potential SCC roots
                while self._stack2 and self._preorder[self._stack2[-1]] > self._preorder[w]:
                    self._stack2.pop()

        # If v is the root of an SCC (i.e., it remains on top of stack2 after
        # exploring all its descendants and back-edges)
        if self._stack2 and self._stack2[-1] == v:
            self._stack2.pop()
            # Pop vertices from stack1 until v is popped; assign them the current SCC id
            while True:
                w = self._stack1.pop()
                self._id[w] = self._scc_count
                if w == v:
                    break
            self._scc_count += 1

    def count(self):
        """Returns the number of strong components."""
        return self._scc_count

    def _validate_vertex(self, v):
        """Raises ValueError if v is not a valid vertex."""
        V = len(self._marked)
        if not (0 <= v < V):
            raise ValueError(f"vertex {v} is not between 0 and {V-1}")

    def strongly_connected(self, v, w):
        """
        Are vertices v and w in the same strong component?
        :param v: one vertex
        :param w: the other vertex
        :return: True if v and w are in the same strong component, False otherwise
        """
        self._validate_vertex(v)
        self._validate_vertex(w)
        # If either vertex wasn't visited (e.g., in a disconnected graph part),
        # its id will be -1, and they cannot be strongly connected unless
        # the graph is empty or has isolated vertices (handled by id comparison).
        return self._id[v] != -1 and self._id[v] == self._id[w]


    def get_id(self, v):
        """
        Returns the component id of the strong component containing vertex v.
        :param v: the vertex
        :return: The component id (an integer >= 0) or -1 if vertex is invalid/not reached.
        """
        self._validate_vertex(v)
        return self._id[v]

    # The _check method from Java requires a TransitiveClosure implementation.
    # For simplicity, it's omitted here, but could be added if needed.
    # def _check(self, G): ...


# --- Main execution block ---
if __name__ == "__main__":
    # --- Manually construct the digraph ---
    # Example graph (based on Sedgewick/Wayne algs4 tinyDG.txt)
    # 13 vertices, 22 edges
    # Edges: 4->2, 2->3, 3->2, 6->0, 0->1, 2->0, 11->12, 12->9, 9->10,
    #        9->11, 8->9, 10->12, 0->5, 5->4, 3->5, 6->4, 6->9, 7->6,
    #        7->8, 8->7, 5->3, 0->6 (Added 0->6 to connect 0-1 and 0-5-4-2-3 cycles more directly)

    num_vertices = 13
    g = Digraph(num_vertices)

    edges = [
        (4, 2), (2, 3), (3, 2), (6, 0), (0, 1), (2, 0), (11, 12),
        (12, 9), (9, 10), (9, 11), (8, 9), (10, 12), (0, 5), (5, 4),
        (3, 5), (6, 4), (6, 9), (7, 6), (7, 8), (8, 7), (5, 3), (0, 6)
    ]

    for v, w in edges:
        g.add_edge(v, w)

    print("Constructed Digraph:")
    print(g)

    # --- Compute SCCs ---
    scc = GabowSCC(g)

    # --- Print results ---
    m = scc.count()
    print(f"{m} strongly connected components")

    # Group vertices by component ID
    components = [[] for _ in range(m)]
    for v in range(g.V()):
        component_id = scc.get_id(v)
        if component_id != -1: # Should always be >= 0 after running constructor
             components[component_id].append(v)
        else:
             # This case should ideally not happen if all vertices are reachable
             # or handled correctly in the init loop. Could represent isolated vertices
             # or issues if the graph was modified after SCC computation.
             print(f"Warning: Vertex {v} has no SCC ID assigned.")


    print("\nComponents:")
    for i in range(m):
        print(f"Component {i}: {' '.join(map(str, components[i]))}")

    # --- Example usage of strongly_connected and get_id ---
    print("\nConnectivity checks:")
    print(f"Vertices 0 and 3 strongly connected? {scc.strongly_connected(0, 3)}") # Should be True in the example
    print(f"Vertices 0 and 7 strongly connected? {scc.strongly_connected(0, 7)}") # Should be False
    print(f"Vertices 9 and 12 strongly connected? {scc.strongly_connected(9, 12)}") # Should be True
    print(f"ID of vertex 5: {scc.get_id(5)}")
    print(f"ID of vertex 8: {scc.get_id(8)}")
