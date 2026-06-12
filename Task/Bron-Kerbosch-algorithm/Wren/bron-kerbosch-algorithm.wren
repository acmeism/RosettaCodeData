import "./set" for Set
import "./sort" for Sort

// r: Current clique (Set of strings)
// p: Potential candidates to expand the clique (Set of strings)
// x: Vertices already processed (Set of strings)
// g: Graph represented as an adjacency list (Map of strings to Sets)
// Cliques: List to store all maximal cliques (List of Lists of strings)
var BronKerbosch = Fn.new { |r, p, x, g, cliques|
    if (p.isEmpty && x.isEmpty) {
        if (r.count > 2) {
            var clique = r.toList
            Sort.quick(clique)
            cliques.add(clique)
        }
        return
    }

    // Select a pivot vertex from P ∪ X with the maximum degree.
    var pivot = p.union(x).max { |v| g[v] ? g[v].count : 0 }

    // Candidates are vertices in P that are not neighbors of the pivot.
    var candidates = p.except(g[pivot])

    for (v in candidates) {
        // New clique including vertex v.
        var newR = r.copy()
        newR.add(v)

        // New potential candidates are neighbors of v in p.
        var neighbors = g[v]
        var newP = p.intersect(neighbors)

        // New excluded vertices are neighbors of v in x.
        var newX = x.intersect(neighbors)

        // Recursive call with updated sets.
        BronKerbosch.call(newR, newP, newX, g, cliques)

        // Move vertex v from p to x.
        p.remove(v)
        x.add(v)
    }
}

// Define the input edges as a list of tuples.
var input = [
    ["a", "b"], ["b", "a"], ["a", "c"], ["c", "a"],
    ["b", "c"], ["c", "b"], ["d", "e"], ["e", "d"],
    ["d", "f"], ["f", "d"], ["e", "f"], ["f", "e"]
]

// Build the graph as an adjacency list.
var graph = {}
for (t in input) {
    if (!graph.containsKey(t[0])) graph[t[0]] = Set.new()
    graph[t[0]].add(t[1])
}

// Initialize r, p, x.
var r = Set.new()
var p = Set.new(graph.keys)
var x = Set.new()

// Initialize list to store cliques.
var cliques = []

// Execute the Bron-Kerbosch algorithm.
BronKerbosch.call(r, p, x, graph, cliques)

// Sort the cliqes for consistent output.
Sort.quick(cliques)

// Print each clique.
for (clique in cliques) {
    System.print(clique.join(", "))
}
