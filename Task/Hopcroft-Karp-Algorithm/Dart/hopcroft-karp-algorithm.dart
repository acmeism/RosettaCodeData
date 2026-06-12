import 'dart:collection';
import 'dart:math';

/// Representation of a bipartite graph.
/// Vertices in the left partition, U, are numbered from 1 to m,
/// and vertices in the right partition, V, are numbered 1 to n.
class BipartiteGraph {
  late int m; // Index of the vertices in the left partition
  late int n; // Index of the vertices in the right partition

  final int NIL = 0;
  final int INFINITY = 2147483647; // INT_MAX

  late List<List<int>> adjacencyLists; // adjacencyLists[u] stores a list of neighbours of u in V
  late List<int> pairU; // pairU[u] stores the vertex v in V matched with u in U, or NIL if unmatched
  late List<int> pairV; // pairV[v] stores the vertex u in U matched with v in V, or NIL if unmatched
  late List<int> levels; // levels[u] stores the level of vertex u in U during a breadth first search

  BipartiteGraph(int aM, int aN) {
    m = aM;
    n = aN;

    adjacencyLists = List.generate(m + 1, (index) => <int>[], growable: false);
    pairU = List.filled(m + 1, NIL, growable: false);
    pairV = List.filled(n + 1, NIL, growable: false);
    levels = List.filled(m + 1, INFINITY, growable: false);
  }

  void addEdge(int u, int v) {
    if (1 <= u && u <= m && 1 <= v && v <= n) {
      adjacencyLists[u].add(v);
    } else {
      throw ArgumentError('Attempt to add an edge ($u, $v) which is out of bounds');
    }
  }

  /// Return the matching size of the bipartite graph.
  int hopcroftKarpAlgorithm() {
    pairU = List.filled(m + 1, NIL, growable: false);
    pairV = List.filled(n + 1, NIL, growable: false);
    int matchingSize = 0;

    while (breadthFirstSearch()) {
      for (int u = 1; u <= m; u++) {
        if (pairU[u] == NIL && depthFirstSearch(u)) { // vertex u is free and an augmenting path starting
          matchingSize++;                             // from u has been found by the depth first search
        }
      }
    }
    return matchingSize;
  }

  /// Determines whether there exists an augmenting path starting from a free vertex in U.
  ///
  /// Return true if an augmenting path could exist, otherwise false.
  bool breadthFirstSearch() {
    Queue<int> queue = Queue();
    for (int u = 1; u <= m; u++) { // Initialise 'levels' for the vertices in U
      if (pairU[u] == NIL) { // If u is a free vertex, its level is 0 and it is added to the queue
        levels[u] = 0;
        queue.add(u);
      } else { // Otherwise, set 'levels' to infinity
        levels[u] = INFINITY;
      }
    }

    // The 'level' to the NIL node represents the length of the shortest augmenting path
    levels[NIL] = INFINITY;

    while (queue.isNotEmpty) {
      final int u = queue.removeFirst();
      if (levels[u] < levels[NIL]) { // The path through u could lead to a shorter augmenting path
        for (final int v in adjacencyLists[u]) { // Explore the neighbours v of u in V
          final int matchedU = pairV[v];
          if (levels[matchedU] == INFINITY) { // The matched vertex has not been visited yet
            levels[matchedU] = levels[u] + 1;
            queue.add(matchedU); // Enqueue the matched vertex to explore it further
          }
        }
      }
    }

    // An augmenting path from the initial free vertices was found if levels[NIL] is not INFINITY
    return levels[NIL] != INFINITY;
  }

  /// Determine whether the shortest path from vertex u in U found by breadthFirstSearch() can be augmented.
  ///
  /// Return true if an augmenting path was found starting from u, otherwise false.
  bool depthFirstSearch(int u) {
    if (u != NIL) {
      for (final int v in adjacencyLists[u]) { // Explore neighbours v of u in V
        final int matchedU = pairV[v];
        // Check whether the edge (u, v) leads to a vertex matchedU
        // such that the path u -> v -> matchedU is part of a shortest augmenting path
        if (levels[matchedU] == levels[u] + 1) {
          if (depthFirstSearch(matchedU)) { // An augmenting path is found starting from 'matchedU'
            pairV[v] = u; // Match v with u,
            pairU[u] = v; // and u with v
            return true;
          }
        }
      }

      // No augmenting path was found starting from vertex u through any of its neighbours v,
      // so remove u from the depth first search phase of the algorithm
      levels[u] = INFINITY;
      return false;
    }

    return true;
  }
}

class Edge {
  final int from;
  final int to;

  Edge(this.from, this.to);
}

int testValue(int testNumber, int m, int n, List<Edge> edges, int expectedResult) {
  BipartiteGraph graph = BipartiteGraph(m, n);
  for (final Edge edge in edges) {
    graph.addEdge(edge.from, edge.to);
  }
  final int result = graph.hopcroftKarpAlgorithm();
  print('Test $testNumber: Result = $result, Expected = $expectedResult');
  if (result == expectedResult) {
    return 1;
  }

  print('Test $testNumber failed.');
  return 0;
}

void main() {
  print('Running tests:');
  int successCount = 0;

  // Test Case 1
  successCount = testValue(1, 3, 5, [Edge(1, 4)], 1);

  // Test Case 2
  successCount += testValue(2, 6, 6, [Edge(1, 4), Edge(1, 5), Edge(5, 1)], 2);

  // Test Case 3: Complete Bipartite Graph K(3, 3)
  List<Edge> edges = [];
  for (int i = 1; i <= 3; i++) {
    for (int j = 1; j <= 3; j++) {
      edges.add(Edge(i, j));
    }
  }
  successCount += testValue(3, 3, 3, edges, 3);

  // Test Case 4: No edges
  successCount += testValue(4, 2, 2, [], 0);

  // Test Case 5
  edges = [Edge(1, 1), Edge(1, 3), Edge(2, 3), Edge(3, 4), Edge(4, 3), Edge(4, 2)];
  successCount += testValue(5, 4, 4, edges, 4);

  if (successCount == 5) {
    print('All tests passed.');
  }
}
