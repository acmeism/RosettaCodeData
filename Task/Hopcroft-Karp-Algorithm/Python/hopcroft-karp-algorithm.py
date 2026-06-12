import collections

# Setting a large value for infinity, equivalent to C++ INT_MAX for distance calculations
INF = float('inf')
# Using 0 as the NIL node, consistent with the C++ code
NIL = 0


class HKGraph:
    """
    Implementation of the Hopcroft-Karp algorithm for finding maximum matching
    in a bipartite graph.

    Assumes vertices in the left partition (U) are numbered 1 to m,
    and vertices in the right partition (V) are numbered 1 to n.
    The NIL node is represented by 0.
    """

    def __init__(self, m, n):
        """
        Constructor for the HKGraph class.

        Args:
            m (int): Number of vertices in the left partition (U).
            n (int): Number of vertices in the right partition (V).
        """
        self.m = m  # Number of vertices on the left side (U)
        self.n = n  # Number of vertices on the right side (V)

        # Adjacency list: adj[u] contains list of neighbors of u in V
        # Initialize with empty lists for vertices 1 to m
        self.adj = [[] for _ in range(m + 1)]

        # Matching pairs:
        # pair_u[u] stores the vertex v in V matched with u in U (or NIL if unmatched)
        self.pair_u = [NIL] * (m + 1)
        # pair_v[v] stores the vertex u in U matched with v in V (or NIL if unmatched)
        self.pair_v = [NIL] * (n + 1)

        # dist[u] stores the distance (level) of vertex u in U during BFS
        # Initialized within the hopcroft_karp_algorithm or bfs method
        self.dist = [INF] * (m + 1)

    def add_edge(self, u, v):
        """
        Adds a directed edge from vertex u (left partition) to vertex v (right partition).

        Args:
            u (int): Vertex index in the left partition (1 to m).
            v (int): Vertex index in the right partition (1 to n).
        """
        # Ensure vertices are within the valid range
        if 1 <= u <= self.m and 1 <= v <= self.n:
            self.adj[u].append(v)  # Add v to u's adjacency list
        else:
            # Optionally print a warning for edges added outside the defined range
            # This check is now also done in the main section when adding edges.
            # print(f"Warning: Attempted to add edge ({u}, {v}) outside graph bounds [1..{self.m}], [1..{self.n}]")
            pass

    def bfs(self) -> bool:
        """
        Performs Breadth-First Search (BFS) to find layers in the graph.
        It checks if there exists an augmenting path starting from a free vertex in U.

        Returns:
            bool: True if an augmenting path might exist (dist[NIL] is finite),
                  False otherwise.
        """
        queue = collections.deque()  # Use deque for efficient queue operations

        # Initialize distances for vertices in U
        for u in range(1, self.m + 1):
            if self.pair_u[u] == NIL:
                # If u is a free vertex, its distance is 0, add to queue
                self.dist[u] = 0
                queue.append(u)
            else:
                # Otherwise, set distance to infinity initially
                self.dist[u] = INF

        # Distance to the NIL node represents the length of the shortest augmenting path
        self.dist[NIL] = INF

        while queue:
            u = queue.popleft()  # Dequeue a vertex from U

            # If the path through u can potentially lead to a shorter augmenting path
            if self.dist[u] < self.dist[NIL]:
                # Explore neighbors v of u in V
                for v in self.adj[u]:
                    matched_u = self.pair_v[v]  # Get the vertex u' matched with v
                    # If the matched vertex u' hasn't been visited yet (its distance is INF)
                    if self.dist[matched_u] == INF:
                        # Set the distance of u' based on u
                        self.dist[matched_u] = self.dist[u] + 1
                        # Enqueue u' to explore further
                        queue.append(matched_u)

        # If dist[NIL] is still INF, no augmenting path was found originating
        # from the initial free vertices. Otherwise, augmenting paths might exist.
        return self.dist[NIL] != INF

    def dfs(self, u: int) -> bool:
        """
        Performs Depth-First Search (DFS) starting from vertex u in U
        to find and augment along a shortest path identified by BFS.

        Args:
            u (int): The current vertex in U being visited (or NIL).

        Returns:
            bool: True if an augmenting path was found and used starting from u,
                  False otherwise.
        """
        if u != NIL:
            # Explore neighbors v of u in V
            for v in self.adj[u]:
                matched_u = self.pair_v[v]  # Get the vertex u' matched with v
                # Check if the edge (u, v) leads to a vertex u'
                # such that the path u -> v -> u' is part of a shortest augmenting path
                if self.dist[matched_u] == self.dist[u] + 1:
                    # Recursively call DFS on u'
                    if self.dfs(matched_u):
                        # If an augmenting path is found starting from u',
                        # update the matching: match v with u, and u with v
                        self.pair_v[v] = u
                        self.pair_u[u] = v
                        return True  # Augmentation successful

            # If no augmenting path was found starting from u through any neighbor v,
            # mark u as visited in this DFS phase by setting its distance to INF
            self.dist[u] = INF
            return False  # Augmentation failed for this path

        # Base case: If u is NIL, it means we have reached the end of an alternating path
        # originating from a free vertex in U and ending at a free vertex in V (represented by NIL).
        return True

    def hopcroft_karp_algorithm(self) -> int:
        """
        Executes the Hopcroft-Karp algorithm to find the maximum matching.

        Returns:
            int: The size of the maximum matching found.
        """
        # Initialize matching pairs to NIL (unmatched)
        self.pair_u = [NIL] * (self.m + 1)
        self.pair_v = [NIL] * (self.n + 1)

        matching_size = 0  # Initialize the size of the matching

        # Keep finding augmenting paths using BFS and DFS until no more exist
        while self.bfs():
            # For every free vertex u in U
            for u in range(1, self.m + 1):
                # If u is free and an augmenting path starting from u is found via DFS
                if self.pair_u[u] == NIL and self.dfs(u):
                    # Increment the matching size
                    matching_size += 1

        return matching_size


# --- Testing ---

def tests():
    """ Runs test cases for the Hopcroft-Karp implementation. """
    print("Running tests...")

    # Test Case 1 (Corrected from C++ version - using 1-based indexing)
    # m=3, n=5, edges = [(1, 4)] - Expected matching size = 1
    g1 = HKGraph(3, 5)
    g1.add_edge(1, 4)
    res1 = g1.hopcroft_karp_algorithm()
    expected_res1 = 1
    print(f"Test 1: Result={res1}, Expected={expected_res1}")
    assert res1 == expected_res1, f"Test 1 Failed: Expected {expected_res1}, got {res1}"

    # Test Case 2 (Corrected from C++ version - using 1-based indexing, assuming (5,0) meant (5,1) or similar valid edge)
    # m=6, n=6, edges = [(1,4), (1,5), (5,1)]
    # Expected matching size = 2 (e.g., (1,4), (5,1) or (1,5), (5,1))
    # Note: Original C++ test had (0,1) and (5,0) which are problematic with 1-based index logic.
    g2 = HKGraph(6, 6)
    # g3.add_edge(0,1) # Invalid vertex 0 in U
    g2.add_edge(1, 4)
    g2.add_edge(1, 5)
    g2.add_edge(5, 1)  # Assuming (5,0) meant a valid edge like (5,1)
    # g2.add_edge(5, 0) # Invalid vertex 0 in V
    res2 = g2.hopcroft_karp_algorithm()
    expected_res2 = 2
    print(f"Test 2: Result={res2}, Expected={expected_res2}")
    assert res2 == expected_res2, f"Test 3 Failed: Expected {expected_res2}, got {res2}"

    # Test Case 3: Complete Bipartite Graph K_{3,3}
    # m=3, n=3, all possible edges. Expected matching size = 3
    g3 = HKGraph(3, 3)
    for i in range(1, 4):
        for j in range(1, 4):
            g3.add_edge(i, j)
    res3 = g3.hopcroft_karp_algorithm()
    expected_res3 = 3
    print(f"Test 3: Result={res3}, Expected={expected_res3}")
    assert res3 == expected_res3, f"Test 4 Failed: Expected {expected_res3}, got {res3}"

    # Test Case 4: No edges
    # m=2, n=2, no edges. Expected matching size = 0
    g4 = HKGraph(2, 2)
    res4 = g4.hopcroft_karp_algorithm()
    expected_res4 = 0
    print(f"Test 4: Result={res4}, Expected={expected_res4}")
    assert res4 == expected_res4, f"Test 4 Failed: Expected {expected_res4}, got {res4}"

    print("All tests passed!")


# --- Main execution ---

if __name__ == "__main__":
    # Run self-tests first
    tests()
    print("\n--- Running main execution with hard-coded input ---")

    # --- Hard-coded input data ---
    # Example 1: Corresponds to Test Case 2
    hardcoded_v1 = 4  # Number of vertices in left partition (m)
    hardcoded_v2 = 4  # Number of vertices in right partition (n)
    hardcoded_edges = [
        (1, 1),
        (1, 3),
        (2, 3),
        (3, 4),
        (4, 3),
        (4, 2)
    ]
    # Expected output for Example 1: 3

    # Use the selected hardcoded data
    v1 = hardcoded_v1
    v2 = hardcoded_v2
    edges_data = hardcoded_edges
    e = len(edges_data)  # Number of edges is derived from the list

    # Create the graph object
    g = HKGraph(v1, v2)

    print(f"Hard-coded graph dimensions: m={v1}, n={v2}, edges={e}")
    print("Adding hard-coded edges:")

    # Add edges from the hard-coded list
    for u, v in edges_data:
        print(f"  Adding edge: ({u}, {v})")
        # Add edge only if vertices are within valid 1-based range
        if 1 <= u <= v1 and 1 <= v <= v2:
            g.add_edge(u, v)
        else:
            # This warning is important if hardcoded data might be invalid
            print(f"Warning: Skipping invalid hard-coded edge ({u}, {v}) - indices out of range [1..{v1}] or [1..{v2}]")

    # Run the Hopcroft-Karp algorithm
    max_matching_size = g.hopcroft_karp_algorithm()

    # Print the result
    print(f"\nMaximum matching size is {max_matching_size}")
