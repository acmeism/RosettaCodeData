import heapq
import itertools # Used for counter in Bellman-Ford

INF = float('inf')

def bellman_ford(num_vertices, edges, source):
    """
    Runs Bellman-Ford algorithm from a source vertex.

    Args:
        num_vertices: The total number of vertices (including the augmented source).
        edges: A list of tuples (u, v, weight) representing directed edges.
        source: The index of the source vertex.

    Returns:
        A list of shortest distances 'h' from the source to all other vertices,
        or None if a negative cycle is detected.
    """
    dist = [INF] * num_vertices
    dist[source] = 0

    # Relax edges V-1 times
    for _ in range(num_vertices - 1):
        updated = False
        for u, v, weight in edges:
            if dist[u] != INF and dist[u] + weight < dist[v]:
                dist[v] = dist[u] + weight
                updated = True
        # If no update in a full pass, we can stop early
        if not updated:
            break

    # Check for negative cycles
    for u, v, weight in edges:
        if dist[u] != INF and dist[u] + weight < dist[v]:
            print("Graph contains a negative weight cycle")
            return None # Indicate negative cycle

    return dist

def dijkstra(num_vertices, adj, source, h_values):
    """
    Runs Dijkstra's algorithm on a potentially re-weighted graph.

    Args:
        num_vertices: The number of vertices in the original graph.
        adj: Adjacency list of the re-weighted graph {u: [(v, reweighted_weight), ...]}.
        source: The source vertex index for this run.
        h_values: The potential values calculated by Bellman-Ford.

    Returns:
        A list of shortest path distances from the source in the original graph.
    """
    dist = [INF] * num_vertices
    dist[source] = 0

    # Priority queue stores (distance, vertex)
    pq = [(0, source)]

    final_dist = [INF] * num_vertices # To store results

    while pq:
        d, u = heapq.heappop(pq)

        # If we found a shorter path already, skip
        if d > dist[u]:
            continue

        # Store the final shortest path distance (translated back)
        # This check prevents processing nodes disconnected from source
        if final_dist[u] == INF:
             if dist[u] == INF: # Should not happen if popped from pq, but safety check
                 final_dist[u] = INF
             else:
                 # Translate distance back to original weight: d(u,v) = d'(u,v) - h[u] + h[v]
                 # Here, d'(source, u) is dist[u]
                 # So, original distance = dist[u] - h[source] + h[u]
                 final_dist[u] = dist[u] - h_values[source] + h_values[u]


        # Relax edges outgoing from u
        if u in adj:
            for v, reweighted_weight in adj[u]:
                if dist[u] != INF and dist[u] + reweighted_weight < dist[v]:
                    dist[v] = dist[u] + reweighted_weight
                    heapq.heappush(pq, (dist[v], v))

    # After Dijkstra finishes, translate any remaining reachable vertices
    # This handles cases where a node might be reachable but wasn't the
    # minimum popped from PQ when its final distance was determined.
    for i in range(num_vertices):
         if final_dist[i] == INF and dist[i] != INF:
             final_dist[i] = dist[i] - h_values[source] + h_values[i]


    return final_dist


def johnsons_algorithm(graph_matrix):
    """
    Implements Johnson's algorithm for all-pairs shortest paths.

    Args:
        graph_matrix: An adjacency matrix representation of the graph.
                      graph_matrix[i][j] is the weight of the edge from i to j.
                      Use 0 for non-existent edges between different nodes (or INF).
                      graph_matrix[i][i] should be 0.

    Returns:
        A matrix containing the shortest path distances between all pairs,
        or None if a negative cycle is detected. Returns INF if no path exists.
    """
    V = len(graph_matrix)
    original_edges = []

    # --- Step 0: Handle Input and Build Edge List for Original Graph ---
    # Be careful about 0 vs non-existent edge. Assume 0 means no edge if i != j
    for i in range(V):
        for j in range(V):
            weight = graph_matrix[i][j]
            # Only add edges that exist. Assuming 0 means no edge unless i==j.
            # If 0 could be a valid edge weight, use INF for non-edges in input.
            if i == j:
                if weight != 0:
                   print(f"Warning: graph_matrix[{i}][{i}] is {weight}, expected 0. Setting to 0.")
                   # Optional: Raise error instead? Or just proceed assuming 0?
                   # graph_matrix[i][i] = 0 # Correct it if needed by Bellman-Ford/Dijkstra logic
            elif weight != 0: # Assuming 0 means non-edge here
                 original_edges.append((i, j, weight))
            # If 0 IS a valid weight, the condition should be:
            # elif weight != INF: # Use INF in the input matrix for non-edges
            #    original_edges.append((i, j, weight))


    # --- Step 1: Form the augmented graph G' ---
    # Add a new vertex 's' (index V) with 0-weight edges to all original vertices
    augmented_edges = list(original_edges)
    for i in range(V):
        augmented_edges.append((V, i, 0)) # New source V connects to all others

    num_vertices_augmented = V + 1

    # --- Step 2: Run Bellman-Ford from the new source 's' ---
    h_values = bellman_ford(num_vertices_augmented, augmented_edges, V)

    if h_values is None:
        # Negative cycle detected by Bellman-Ford
        return None

    # Remove the h value for the augmented source, we only need it for original vertices
    h_values = h_values[:V] # Keep h[0] to h[V-1]

    # --- Step 3: Reweight the edges ---
    reweighted_adj = {i: [] for i in range(V)}
    for u, v, weight in original_edges:
        # Ensure h values are valid before reweighting
        if h_values[u] == INF or h_values[v] == INF:
            # This can happen if the original graph wasn't strongly connected
            # from the augmented source 's'. While not strictly an error for
            # Johnson's (paths might still exist between reachable nodes),
            # it means the reweighting might involve INF.
            # Let's compute the reweighted value anyway; Dijkstra handles INF.
            pass # Or print a warning if desired

        reweighted_weight = weight + h_values[u] - h_values[v]
        # Theoretically, reweighted_weight should be >= 0 if no negative cycle
        # Add small tolerance for floating point issues if necessary:
        # if reweighted_weight < -1e-9:
        #     print(f"Warning: Potential negative reweighted edge {u}->{v}: {reweighted_weight}")
        reweighted_adj[u].append((v, reweighted_weight))

    # --- Step 4: Run Dijkstra from each vertex on the reweighted graph ---
    all_pairs_shortest_paths = [[INF for _ in range(V)] for _ in range(V)]

    for u in range(V):
        # Run Dijkstra on the reweighted graph starting from u
        shortest_paths_from_u = dijkstra(V, reweighted_adj, u, h_values)
        all_pairs_shortest_paths[u] = shortest_paths_from_u
        # The dijkstra implementation now directly calculates the original distance

    # --- Step 5: Return the result matrix ---
    return all_pairs_shortest_paths

# --- Test Case ---
graph = [[0, -5,  2,  3],
         [0,  0,  4,  0], # Assuming 0 means no edge from 1->0 and 1->3
         [0,  0,  0,  1], # Assuming 0 means no edge from 2->0 and 2->1
         [0,  0,  0,  0]] # Assuming 0 means no edge from 3->0, 3->1, 3->2

result = johnsons_algorithm(graph)

if result:
    print("All-pairs shortest paths:")
    for row in result:
        print([x if x != INF else "INF" for x in row])
else:
    print("Negative cycle detected in the graph.")

print("\nExpected for the test case:")
print("[0, -5, -1, 0]")
print("['INF', 0, 4, 5]")
print("['INF', 'INF', 0, 1]")
print("['INF', 'INF', 'INF', 0]")
