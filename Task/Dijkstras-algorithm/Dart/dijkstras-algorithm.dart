import 'dart:math';
import 'dart:collection';

class Edge<T extends num, U> {
  final U from;
  final U to;
  final T weight;

  Edge(this.from, this.to, this.weight);

  @override
  String toString() => '($from, $to, $weight)';
}

class Digraph<T extends num, U> {
  final Map<MapEntry<U, U>, T> edges;
  final Set<U> verts;

  Digraph(this.edges, this.verts);

  factory Digraph.fromEdges(List<Edge<T, U>> edgeList) {
    final Set<U> vnames = <U>{};
    final Map<MapEntry<U, U>, T> adjmat = <MapEntry<U, U>, T>{};

    for (final edge in edgeList) {
      vnames.add(edge.from);
      vnames.add(edge.to);
      adjmat[MapEntry(edge.from, edge.to)] = edge.weight;
    }

    return Digraph(adjmat, vnames);
  }

  Set<U> get vertices => verts;
  Map<MapEntry<U, U>, T> get edgeMap => edges;

  Set<MapEntry<U, T>> neighbours(U vertex) {
    final Set<MapEntry<U, T>> result = <MapEntry<U, T>>{};
    for (final entry in edges.entries) {
      if (entry.key.key == vertex) {
        result.add(MapEntry(entry.key.value, entry.value));
      }
    }
    return result;
  }
}

class DijkstraResult<T extends num, U> {
  final List<U> path;
  final T cost;

  DijkstraResult(this.path, this.cost);
}

DijkstraResult<T, U> dijkstraPath<T extends num, U>(
    Digraph<T, U> graph, U source, U destination) {

  // Verify source is in graph
  if (!graph.vertices.contains(source)) {
    throw ArgumentError('$source is not a vertex in the graph');
  }

  // Easy case - same source and destination
  if (source == destination) {
    return DijkstraResult([source], 0 as T);
  }

  // Initialize variables
  final T infinity = (T == int) ?
    (double.maxFinite.toInt() as T) :
    (double.maxFinite as T);

  final Map<U, T> dist = <U, T>{};
  final Map<U, U> prev = <U, U>{};
  final Set<U> unvisited = Set<U>.from(graph.vertices);
  final Map<U, Set<MapEntry<U, T>>> neighMap = <U, Set<MapEntry<U, T>>>{};

  // Initialize distances and previous vertices
  for (final vertex in graph.vertices) {
    dist[vertex] = infinity;
    prev[vertex] = vertex;
    neighMap[vertex] = graph.neighbours(vertex);
  }
  dist[source] = 0 as T;

  // Main loop
  while (unvisited.isNotEmpty) {
    // Find vertex with minimum distance
    U? current;
    T minDist = infinity;
    for (final vertex in unvisited) {
      if (dist[vertex]! < minDist) {
        minDist = dist[vertex]!;
        current = vertex;
      }
    }

    if (current == null || dist[current] == infinity || current == destination) {
      break;
    }

    unvisited.remove(current);

    // Update distances to neighbours
    for (final neighbour in neighMap[current]!) {
      final U neighbourVertex = neighbour.key;
      final T edgeCost = neighbour.value;
      final T alt = (dist[current]! + edgeCost) as T;

      if (alt < dist[neighbourVertex]!) {
        dist[neighbourVertex] = alt;
        prev[neighbourVertex] = current;
      }
    }
  }

  // Reconstruct path
  final List<U> path = <U>[];
  final T cost = dist[destination]!;

  if (prev[destination] == destination) {
    // No path found
    return DijkstraResult(path, cost);
  } else {
    // Build path backwards
    U current = destination;
    while (current != source) {
      path.insert(0, current);
      current = prev[current]!;
    }
    path.insert(0, current);
    return DijkstraResult(path, cost);
  }
}

// Test data
final List<Edge<int, String>> testGraph = [
  Edge("a", "b", 7),
  Edge("a", "c", 9),
  Edge("a", "f", 14),
  Edge("b", "c", 10),
  Edge("b", "d", 15),
  Edge("c", "d", 11),
  Edge("c", "f", 2),
  Edge("d", "e", 6),
  Edge("e", "f", 9),
];

void testPaths() {
  final graph = Digraph.fromEdges(testGraph);
  final String src = "a";
  final String dst = "e";

  final result = dijkstraPath(graph, src, dst);
  final String pathStr = result.path.isEmpty
    ? "no possible path"
    : result.path.join(" → ");

  print("Shortest path from $src to $dst: $pathStr (cost ${result.cost})");

  // Print all possible paths
  print("\n src | dst | path");
  print("----------------");

  for (final source in graph.vertices) {
    for (final dest in graph.vertices) {
      final pathResult = dijkstraPath(graph, source, dest);
      final String pathDisplay = pathResult.path.isEmpty
        ? "no possible path"
        : "${pathResult.path.join(" → ")} (${pathResult.cost})";

      print("${source.toString().padLeft(4)} | ${dest.toString().padLeft(3)} | $pathDisplay");
    }
  }
}

void main() {
  testPaths();
}
