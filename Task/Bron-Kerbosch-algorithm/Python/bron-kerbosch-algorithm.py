from collections import defaultdict

# Global variable to store cliques
cliques = []

class Edge:
    def __init__(self, start, end):
        self.start = start
        self.end = end

def print_vector(vec):
    print("[" + ", ".join(sorted(map(str, vec))) + "]", end="")

def print_2D_vector(vecs):
    print("[", end="")
    for i in range(len(vecs) - 1):
        print_vector(vecs[i])
        print(", ", end="")
    print_vector(vecs[-1])
    print("]")

def bron_kerbosch(current_clique, candidates, processed_vertices, graph):
    global cliques

    if not candidates and not processed_vertices:
        if len(current_clique) > 2:
            cliques.append(list(current_clique))
        return

    # Select a pivot vertex from 'candidates' union 'processed_vertices' with the maximum degree
    union_set = candidates.union(processed_vertices)
    pivot = max(union_set, key=lambda v: len(graph[v]))

    # 'possibles' are vertices in 'candidates' that are not neighbors of the 'pivot'
    possibles = candidates.difference(graph[pivot])

    for vertex in possibles:
        # Create a new clique including 'vertex'
        new_clique = current_clique.union({vertex})

        # 'new_candidates' are the members of 'candidates' that are neighbors of 'vertex'
        new_candidates = candidates.intersection(graph[vertex])

        # 'new_processed_vertices' are members of 'processed_vertices' that are neighbors of 'vertex'
        new_processed_vertices = processed_vertices.intersection(graph[vertex])

        # Recursive call with the updated sets
        bron_kerbosch(new_clique, new_candidates, new_processed_vertices, graph)

        # Move 'vertex' from 'candidates' to 'processed_vertices'
        candidates.remove(vertex)
        processed_vertices.add(vertex)

def main():
    global cliques

    # Define edges
    edges = [
        Edge("a", "b"), Edge("b", "a"), Edge("a", "c"), Edge("c", "a"),
        Edge("b", "c"), Edge("c", "b"), Edge("d", "e"), Edge("e", "d"),
        Edge("d", "f"), Edge("f", "d"), Edge("e", "f"), Edge("f", "e")
    ]

    # Build the graph as an adjacency list
    graph = defaultdict(set)
    for edge in edges:
        graph[edge.start].add(edge.end)

    # Initialize current clique, candidates, and processed vertices
    current_clique = set()
    candidates = set(graph.keys())
    processed_vertices = set()

    # Execute the Bron-Kerbosch algorithm to collect the cliques
    bron_kerbosch(current_clique, candidates, processed_vertices, graph)

    # Sort the cliques for consistent display
    cliques.sort(key=lambda x: (len(x), x))

    # Display the cliques
    print_2D_vector(cliques)

if __name__ == "__main__":
    main()
