import 'dart:math';
import 'dart:collection';

// Helper Classes
class Point {
  final double x, y;
  final int id; // Original index

  Point(this.x, this.y, this.id);
}

class Edge implements Comparable<Edge> {
  final int u, v;
  final double weight;

  Edge(this.u, this.v, this.weight);

  @override
  int compareTo(Edge other) => weight.compareTo(other.weight);
}

// Helper Functions to Print Containers
void printContainer(List<dynamic> container, String name) {
  print('$name: [${container.join(', ')}]');
}

void printEdges(List<Edge> edges, String name) {
  final buffer = StringBuffer('$name: [');
  for (var i = 0; i < edges.length; i++) {
    if (i != 0) buffer.write(', ');
    buffer.write('(${edges[i].u}, ${edges[i].v}, ${edges[i].weight.toStringAsFixed(2)})');
  }
  buffer.write(']');
  print(buffer.toString());
}

void printGraph(List<List<double>> graph, String name) {
  print('$name: {');
  for (var i = 0; i < graph.length; i++) {
    final buffer = StringBuffer('  $i: {');
    for (var j = 0; j < graph[i].length; j++) {
      if (i != j) {
        if (buffer.length > 6) buffer.write(', ');
        buffer.write('$j: ${graph[i][j].toStringAsFixed(2)}');
      }
    }
    buffer.write('}${i == graph.length - 1 ? '' : ','}');
    print(buffer.toString());
  }
  print('}');
}

// Euclidean Distance
double getLength(Point p1, Point p2) {
  final dx = p1.x - p2.x;
  final dy = p1.y - p2.y;
  return sqrt(dx * dx + dy * dy);
}

// Build Complete Graph (Adjacency Matrix)
List<List<double>> buildGraph(List<Point> data) {
  final n = data.length;
  final graph = List.generate(n, (_) => List.filled(n, 0.0));
  for (var i = 0; i < n; i++) {
    for (var j = i + 1; j < n; j++) {
      final dist = getLength(data[i], data[j]);
      graph[i][j] = dist;
      graph[j][i] = dist;
    }
  }
  return graph;
}

// Union-Find Data Structure
class UnionFind {
  final List<int> parent;
  final List<int> rank;

  UnionFind(int n)
      : parent = List.generate(n, (i) => i),
        rank = List.filled(n, 0);

  int find(int i) {
    if (parent[i] == i) return i;
    parent[i] = find(parent[i]); // Path compression
    return parent[i];
  }

  void unite(int i, int j) {
    final rootI = find(i);
    final rootJ = find(j);
    if (rootI != rootJ) {
      if (rank[rootI] < rank[rootJ]) {
        parent[rootI] = rootJ;
      } else if (rank[rootI] > rank[rootJ]) {
        parent[rootJ] = rootI;
      } else {
        parent[rootJ] = rootI;
        rank[rootI]++;
      }
    }
  }
}

// Minimum Spanning Tree (Kruskal's Algorithm)
List<Edge> minimumSpanningTree(List<List<double>> graph) {
  final n = graph.length;
  if (n == 0) return [];

  final edges = <Edge>[];
  for (var i = 0; i < n; i++) {
    for (var j = i + 1; j < n; j++) {
      edges.add(Edge(i, j, graph[i][j]));
    }
  }
  edges.sort();

  final mst = <Edge>[];
  final uf = UnionFind(n);
  var edgesCount = 0;
  for (final edge in edges) {
    if (uf.find(edge.u) != uf.find(edge.v)) {
      mst.add(edge);
      uf.unite(edge.u, edge.v);
      edgesCount++;
      if (edgesCount == n - 1) break; // Optimization: MST has n-1 edges
    }
  }
  return mst;
}

// Find Vertices with Odd Degree in MST
List<int> findOddVertices(List<Edge> mst, int n) {
  final degree = List.filled(n, 0);
  for (final edge in mst) {
    degree[edge.u]++;
    degree[edge.v]++;
  }

  final oddVertices = <int>[];
  for (var i = 0; i < n; i++) {
    if (degree[i] % 2 != 0) {
      oddVertices.add(i);
    }
  }
  return oddVertices;
}

// Minimum Weight Matching (Greedy Heuristic)
void minimumWeightMatching(List<Edge> mst, List<List<double>> graph, List<int> oddVertices) {
  final currentOdd = List.from(oddVertices);
  currentOdd.shuffle(); // Shuffle for randomness

  final matched = List.filled(graph.length, false);
  for (var i = 0; i < currentOdd.length; i++) {
    final v = currentOdd[i];
    if (matched[v]) continue;

    var minLength = double.infinity;
    var closestU = -1;
    for (var j = i + 1; j < currentOdd.length; j++) {
      final u = currentOdd[j];
      if (!matched[u] && graph[v][u] < minLength) {
        minLength = graph[v][u];
        closestU = u;
      }
    }

    if (closestU != -1) {
      mst.add(Edge(v, closestU, minLength));
      matched[v] = true;
      matched[closestU] = true;
    }
  }
}

// Find Eulerian Tour (Hierholzer's Algorithm)
List<int> findEulerianTour(List<Edge> matchedMst, int n) {
  if (matchedMst.isEmpty) return [];

  final adj = List.generate(n, (_) => <_EdgeNode>[]);
  final edgeUsed = <Edge, bool>{};

  for (final edge in matchedMst) {
    adj[edge.u].add(_EdgeNode(edge.v, edge));
    adj[edge.v].add(_EdgeNode(edge.u, edge));
    edgeUsed[edge] = false;
  }

  final tour = <int>[];
  final currentPath = Queue<int>();
  final startNode = matchedMst.first.u;
  currentPath.addLast(startNode);

  while (currentPath.isNotEmpty) {
    final currentNode = currentPath.last;
    var foundEdge = false;

    for (final node in adj[currentNode]) {
      if (!edgeUsed[node.edge]!) {
        edgeUsed[node.edge] = true;
        currentPath.addLast(node.neighbor);
        foundEdge = true;
        break;
      }
    }

    if (!foundEdge) {
      tour.add(currentPath.removeLast());
    }
  }

  return tour.reversed.toList();
}

// Main TSP Function (Christofides Approximation)
Map<String, dynamic> tsp(List<Point> data) {
  final n = data.length;
  if (n == 0) return {'length': 0.0, 'path': <int>[]};
  if (n == 1) return {'length': 0.0, 'path': [data.first.id]};

  final G = buildGraph(data);
  printGraph(G, 'Graph');

  final MSTree = minimumSpanningTree(G);
  printEdges(MSTree, 'MSTree');

  final oddVertices = findOddVertices(MSTree, n);
  printContainer(oddVertices, 'Odd vertexes in MSTree');

  minimumWeightMatching(MSTree, G, oddVertices);
  printEdges(MSTree, 'Minimum weight matching (MST + Matching Edges)');

  final eulerianTour = findEulerianTour(MSTree, n);
  printContainer(eulerianTour, 'Eulerian tour');

  if (eulerianTour.isEmpty) {
    print('Error: Eulerian tour could not be found.');
    return {'length': -1.0, 'path': <int>[]};
  }

  final path = <int>[];
  var length = 0.0;
  final visited = List.filled(n, false);
  var current = eulerianTour.first;
  path.add(current);
  visited[current] = true;

  for (var i = 1; i < eulerianTour.length; i++) {
    final v = eulerianTour[i];
    if (!visited[v]) {
      path.add(v);
      visited[v] = true;
      length += G[current][v];
      current = v;
    }
  }

  length += G[current][path.first];
  path.add(path.first);

  printContainer(path, 'Result path');
  print('Result length of the path: ${length.toStringAsFixed(2)}');

  return {'length': length, 'path': path};
}

class _EdgeNode {
  final int neighbor;
  final Edge edge;

  _EdgeNode(this.neighbor, this.edge);
}

void main() {
  final rawData = <List<double>>[
    [1380, 939], [2848, 96], [3510, 1671], [457, 334], [3888, 666], [984, 965], [2721, 1482], [1286, 525],
    [2716, 1432], [738, 1325], [1251, 1832], [2728, 1698], [3815, 169], [3683, 1533], [1247, 1945], [123, 862],
    [1234, 1946], [252, 1240], [611, 673], [2576, 1676], [928, 1700], [53, 857], [1807, 1711], [274, 1420],
    [2574, 946], [178, 24], [2678, 1825], [1795, 962], [3384, 1498], [3520, 1079], [1256, 61], [1424, 1728],
    [3913, 192], [3085, 1528], [2573, 1969], [463, 1670], [3875, 598], [298, 1513], [3479, 821], [2542, 236],
    [3955, 1743], [1323, 280], [3447, 1830], [2936, 337], [1621, 1830], [3373, 1646], [1393, 1368],
    [3874, 1318], [938, 955], [3022, 474], [2482, 1183], [3854, 923], [376, 825], [2519, 135], [2945, 1622],
    [953, 268], [2628, 1479], [2097, 981], [890, 1846], [2139, 1806], [2421, 1007], [2290, 1810], [1115, 1052],
    [2588, 302], [327, 265], [241, 341], [1917, 687], [2991, 792], [2573, 599], [19, 674], [3911, 1673],
    [872, 1559], [2863, 558], [929, 1766], [839, 620], [3893, 102], [2178, 1619], [3822, 899], [378, 1048],
    [1178, 100], [2599, 901], [3416, 143], [2961, 1605], [611, 1384], [3113, 885], [2597, 1830], [2586, 1286],
    [161, 906], [1429, 134], [742, 1025], [1625, 1651], [1187, 706], [1787, 1009], [22, 987], [3640, 43],
    [3756, 882], [776, 392], [1724, 1642], [198, 1810], [3950, 1558]
  ];

  final dataPoints = <Point>[];
  for (var i = 0; i < rawData.length; i++) {
    dataPoints.add(Point(rawData[i][0], rawData[i][1], i));
  }

  tsp(dataPoints);
}

