import 'dart:collection';
import 'dart:math' as math;

// Use a very large number to represent infinity since Dart's double.infinity
// might not behave as expected in all comparison contexts.
// A finite value is often preferred for algorithms like these.
const double INF = 1e300;

class Edge {
  final int u;
  final int v;
  final double weight;

  Edge(this.u, this.v, this.weight);
}

class VertexAndWeight {
  final int vertex;
  final double weight;

  VertexAndWeight(this.vertex, this.weight);
}

/// Return a list of shortest path distances from the source vertex in the original graph to all other vertices
List<double> dijkstraAlgorithm(
    int vertexCount,
    Map<int, List<VertexAndWeight>> reweightedAdjacencies,
    int sourceVertex,
    List<double> values) {
  List<double> distances = List.filled(vertexCount, INF);
  distances[sourceVertex] = 0.0;

  // Using a simple list-based priority queue simulation for clarity.
  // A more efficient heap-based implementation would be better for performance.
  List<VertexAndWeight> priorityQueue = [VertexAndWeight(sourceVertex, 0.0)];
  void addToQueue(VertexAndWeight item) {
    priorityQueue.add(item);
    priorityQueue.sort((a, b) => a.weight.compareTo(b.weight)); // Min-heap
  }

  List<double> finalDistances = List.filled(vertexCount, INF);

  while (priorityQueue.isNotEmpty) {
    VertexAndWeight vertexAndWeight = priorityQueue.removeAt(0); // Remove min
    final int vertex = vertexAndWeight.vertex;
    if (vertexAndWeight.weight > distances[vertex]) {
      continue;
    }

    // Store the final shortest path distance, translated back to the distance in the original graph
    // which prevents processing vertices disconnected from the source vertex
    if (finalDistances[vertex] == INF) {
      if (distances[vertex] == INF) {
        // This should not happen, but is included as a safety check
        finalDistances[vertex] = INF;
      } else {
        // Translate distance back to its original weight: d(u,v) = d'(u,v) - h[u] + h[v]
        finalDistances[vertex] =
            distances[vertex] - values[sourceVertex] + values[vertex];
      }
    }

    // Relax the edges outgoing from vertex
    // Check if the key exists and the list is not empty
    if (reweightedAdjacencies.containsKey(vertex) && reweightedAdjacencies[vertex].isNotEmpty) {
      for (VertexAndWeight pair in reweightedAdjacencies[vertex]) {
        if (distances[vertex] != INF &&
            distances[vertex] + pair.weight < distances[pair.vertex]) {
          distances[pair.vertex] = distances[vertex] + pair.weight;
          addToQueue(VertexAndWeight(pair.vertex, distances[pair.vertex]));
        }
      }
    }
  }

  // Translate distance back to its original weight for any remaining reachable vertices
  // This handles cases where a vertex was reachable, but was not the minimum vertex
  // removed from the priority queue when its final distance was determined.
  for (int i = 0; i < vertexCount; ++i) {
    if (finalDistances[i] == INF && distances[i] != INF) {
      finalDistances[i] = distances[i] - values[sourceVertex] + values[i];
    }
  }

  return finalDistances;
}

/// Return a list of shortest distances from the source vertex to all other vertices,
/// or an empty list if a negative cycle is detected
List<double> bellmanFordAlgorithm(
    int augmentedVertexCount, List<Edge> edges, int sourceVertex) {
  List<double> distances = List.filled(augmentedVertexCount, INF);
  distances[sourceVertex] = 0.0;

  // Relax the edges (augmentedVertexCount - 1) times
  bool updated = true;
  for (int i = 0; i < augmentedVertexCount - 1 && updated; ++i) {
    updated = false;
    for (int j = 0; j < edges.length; ++j) {
      Edge edge = edges[j];
      if (distances[edge.u] != INF &&
          distances[edge.u] + edge.weight < distances[edge.v]) {
        distances[edge.v] = distances[edge.u] + edge.weight;
        updated = true;
      }
    }
  }

  // Check for negative cycles in the graph
  for (Edge edge in edges) {
    if (distances[edge.u] != INF &&
        distances[edge.u] + edge.weight < distances[edge.v]) {
      // Indicates a negative cycle was detected, return an empty list
      return List(); // Return an empty list instead of List<double>.empty()
    }
  }

  return distances;
}

/// Return the shortest path between all pairs of vertices in an edge weighted directed graph
/// For a full description of the algorithm visit https://en.wikipedia.org/wiki/Johnson%27s_algorithm
List<List<double>> johnsonsAlgorithm(List<List<double>> graph) {
  final int vertexCount = graph.length;
  List<Edge> originalEdges = [];

  // Step 0: Build a list of edges for the original graph
  for (int i = 0; i < vertexCount; ++i) {
    for (int j = 0; j < vertexCount; ++j) {
      final double weight = graph[i][j];
      if (i == j) {
        if (weight != 0.0) {
          print('Warning: graph[$i][$i] is $weight, expected to be 0.0, '
              'resetting it to 0.0');
          // Note: Original graph is not modified here, only the edge list is built.
        }
      } else if (weight != INF) {
        originalEdges.add(Edge(i, j, weight));
      }
    }
  }

  // Step 1: Form the augmented graph
  // Add a new vertex with index 'vertexCount' and having 0-weight edges to all the original vertices
  List<Edge> augmentedEdges = List.from(originalEdges);
  for (int i = 0; i < vertexCount; ++i) {
    augmentedEdges.add(Edge(vertexCount, i, 0.0));
  }

  // Step 2: Invoke the Bellman-Ford Algorithm starting from the new vertex
  List<double> hValues =
      bellmanFordAlgorithm(vertexCount + 1, augmentedEdges, vertexCount);

  // Check if Bellman-Ford returned an empty list (indicating a negative cycle)
  if (hValues.isEmpty) {
    // A negative cycle was detected by the Bellman-Ford Algorithm, return an empty list
    return List(); // Return an empty list instead of List<List<double>>.empty()
  }

  // The hValues list is valid, proceed.
  // Create a new growable list from hValues so we can modify it
  List<double> values = List.from(hValues);
  values.removeLast(); // Remove the value for the augmented vertex

  // Step 3: Reweight the edges
  Map<int, List<VertexAndWeight>> reweightedAdjacencies = {};

  for (Edge edge in originalEdges) {
    // Ensure the 'values' are valid before reweighting
    if (values[edge.u] == INF || values[edge.v] == INF) {
      // This can happen if the original graph was not strongly connected to the augmented vertex.
      // While not strictly an error for Johnson's Algorithm, because paths might still exist between
      // reachable nodes, it means the reweighting might involve INF.
      // Computation can proceed since Dijkstra's Algorithm can handle INF.
      print('Warning: invalid hValues detected by the Bellman-Ford Algorithm.');
    }

    final double reweight = edge.weight + values[edge.u] - values[edge.v];
    if (!reweightedAdjacencies.containsKey(edge.u)) {
      reweightedAdjacencies[edge.u] = [];
    }
    reweightedAdjacencies[edge.u].add(VertexAndWeight(edge.v, reweight));
  }

  // Step 4: Invoke Dijkstra's Algorithm starting from each vertex on the reweighted graph
  List<List<double>> allPairsShortestPaths = [];
  for (int u = 0; u < vertexCount; ++u) {
    allPairsShortestPaths
        .add(dijkstraAlgorithm(vertexCount, reweightedAdjacencies, u, values));
  }

  // Step 5: Return the result matrix
  return allPairsShortestPaths;
}

void main() {
  // The element (i, j) is the weight of the edge from vertex i to vertex j.
  // INF, for infinity, means that there is no edge from vertex i to vertex j.
  final List<List<double>> graph = [
    [0.0, -5.0, 2.0, 3.0],
    [INF, 0.0, 4.0, INF],
    [INF, INF, 0.0, 1.0],
    [INF, INF, INF, 0.0]
  ];

  final List<List<double>> result = johnsonsAlgorithm(graph);

  // Check if the result is an empty list (indicating a negative cycle)
  if (result.isEmpty) {
    print('A negative cycle was detected in the graph.');
  } else {
    print('All pairs shortest paths:');
    print(
        'The element (i, j) is the shortest path between vertex i and vertex j.');
    for (List<double> row in result) {
      StringBuffer sb = StringBuffer('[');
      for (int j = 0; j < row.length; j++) {
        double number = row[j];
        if (number >= INF / 2) { // Heuristic check for infinity
          sb.write('INF');
        } else {
          sb.write(number.toStringAsFixed(1)); // Format number for display
        }
        if (j < row.length - 1) {
          sb.write(', ');
        }
      }
      sb.write(']');
      print(sb.toString());
    }
  }
}
