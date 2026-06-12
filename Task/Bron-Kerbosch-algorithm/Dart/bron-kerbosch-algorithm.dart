List<List<String>> cliques = [];

class Edge {
  String start;
  String end;
  Edge(this.start, this.end);
}

void printVector<T>(List<T> vec) {
  StringBuffer sb = StringBuffer();
  sb.write('[');
  for (int i = 0; i < vec.length - 1; i++) {
    sb.write('${vec[i]}, ');
  }
  sb.write('${vec.last}]');
  print(sb.toString());
}

void print2DVector<T>(List<List<T>> vecs) {
  StringBuffer sb = StringBuffer();
  sb.write('[');
  for (int i = 0; i < vecs.length - 1; i++) {
    printVector(vecs[i]);
    sb.write(', ');
  }
  printVector(vecs.last);
  sb.write(']');
}

void bronKerbosch(
    Set<String> currentClique, Set<String> candidates, Set<String> processedVertices, Map<String, Set<String>> graph) {
  if (candidates.isEmpty && processedVertices.isEmpty) {
    if (currentClique.length > 2) {
      cliques.add(List<String>.from(currentClique));
    }
    return;
  }

  // Select a pivot vertex from 'candidates' union 'processedVertices' with the maximum degree
  Set<String> unionSet = Set<String>.from(candidates)..addAll(processedVertices);
  String pivot = unionSet.reduce((s1, s2) => graph[s1]!.length > graph[s2]!.length ? s1 : s2);


  // 'possibles' are vertices in 'candidates' that are not neighbors of the 'pivot'
  Set<String> possibles = candidates.difference(graph[pivot]!);

  for (String vertex in possibles) {
    // Create a new clique including 'vertex'
    Set<String> newCliques = Set<String>.from(currentClique)..add(vertex);

    // 'newCandidates' are the members of 'candidates' that are neighbors of 'vertex'
    Set<String> newCandidates = candidates.intersection(graph[vertex]!);

    // 'newProcessedVertices' are members of 'processedVertices' that are neighbors of 'vertex'
    Set<String> newProcessedVertices = processedVertices.intersection(graph[vertex]!);

    // Recursive call with the updated sets
    bronKerbosch(newCliques, newCandidates, newProcessedVertices, graph);

    // Move 'vertex' from 'candidates' to 'processedVertices'
    candidates.remove(vertex);
    processedVertices.add(vertex);
  }
}

void main() {
  List<Edge> edges = [
    Edge("a", "b"),
    Edge("b", "a"),
    Edge("a", "c"),
    Edge("c", "a"),
    Edge("b", "c"),
    Edge("c", "b"),
    Edge("d", "e"),
    Edge("e", "d"),
    Edge("d", "f"),
    Edge("f", "d"),
    Edge("e", "f"),
    Edge("f", "e")
  ];

  // Build the graph as an adjacency list
  Map<String, Set<String>> graph = {};
  edges.forEach((edge) {
    graph.putIfAbsent(edge.start, () => <String>{}).add(edge.end);
  });

  // Initialize current clique, candidates, and processed vertices
  Set<String> currentClique = {};
  Set<String> candidates = graph.keys.toSet();
  Set<String> processedVertices = {};

  // Execute the Bron-Kerbosch algorithm to collect the cliques
  bronKerbosch(currentClique, candidates, processedVertices, graph);

  // Sort the cliques for consistent display
  cliques.sort((a, b) {
    for (int i = 0; i < a.length && i < b.length; i++) {
      if (a[i] != b[i]) {
        return a[i].compareTo(b[i]);
      }
    }
    return a.length.compareTo(b.length);
  });

  // Display the cliques
  print2DVector(cliques);
}

