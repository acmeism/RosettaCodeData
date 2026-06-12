class Graph:
    def __init__(self, n):
        """Create a new graph on n vertices (0..n-1), no edges."""
        self.n = n
        self.adj = [[False] * n for _ in range(n)]

    def clone(self):
        """Return a deep copy of the graph."""
        g2 = Graph(self.n)
        g2.adj = [row.copy() for row in self.adj]
        return g2

    def add_edge(self, u, v):
        """Add an undirected edge u--v."""
        if not (0 <= u < self.n and 0 <= v < self.n):
            raise IndexError("vertex index out of bounds")
        self.adj[u][v] = True
        self.adj[v][u] = True

    def degree(self, u):
        """Degree of vertex u."""
        return sum(self.adj[u])

    def closure(self):
        """
        Compute the Chvátal closure in-place.
        Repeatedly adds edges {u,v} whenever (u,v) is a non-edge
        with degree(u) + degree(v) >= n, until no more can be added.
        """
        n = self.n
        added = True
        while added:
            added = False
            for u in range(n):
                for v in range(u + 1, n):
                    if not self.adj[u][v]:
                        if self.degree(u) + self.degree(v) >= n:
                            self.add_edge(u, v)
                            added = True
                            break
                if added:
                    break

    def is_complete(self):
        """Return True if the graph is complete."""
        for u in range(self.n):
            for v in range(u + 1, self.n):
                if not self.adj[u][v]:
                    return False
        return True

    def hamiltonian_cycle(self):
        """
        Find a Hamiltonian cycle in the original graph by simple backtracking.
        Returns a list of vertices including the return to the start, or None.
        """
        n = self.n
        visited = [False] * n
        path = [0]
        visited[0] = True

        def dfs(u):
            if len(path) == n:
                # can we close the cycle?
                if self.adj[u][path[0]]:
                    return path + [path[0]]
                return None
            for v in range(n):
                if not visited[v] and self.adj[u][v]:
                    visited[v] = True
                    path.append(v)
                    cycle = dfs(v)
                    if cycle:
                        return cycle
                    # backtrack
                    path.pop()
                    visited[v] = False
            return None

        return dfs(0)


if __name__ == "__main__":
    # Example: 5 vertices, almost complete graph missing edge 0--1.
    # This satisfies Ore's condition: deg(0)=3, deg(1)=3, 3+3>=5.
    g = Graph(5)
    # Add all edges except (0,1)
    for u in range(5):
        for v in range(u + 1, 5):
            if not (u == 0 and v == 1):
                g.add_edge(u, v)

    print("Original graph degrees:")
    for u in range(g.n):
        print(f" deg({u}) = {g.degree(u)}")

    # Compute closure
    closure = g.clone()
    closure.closure()

    print("\nAfter Chvátal closure:")
    for u in range(closure.n):
        print(f"  {u}:", end='')
        for v in range(closure.n):
            if closure.adj[u][v]:
                print(f" {v}", end='')
        print()

    if closure.is_complete():
        print("\nClosure is complete ⇒ graph is Hamiltonian (by Bondy–Chvátal).")
        cycle = g.hamiltonian_cycle()
        if cycle:
            print("Found Hamiltonian cycle in original graph:")
            print(" → ".join(str(v) for v in cycle))
        else:
            print("Unexpected: could not find a Hamiltonian cycle.")
    else:
        print("\nClosure is not complete ⇒ no guarantee of Hamiltonian cycle.")
