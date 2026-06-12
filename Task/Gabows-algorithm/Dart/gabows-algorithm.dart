import 'dart:collection';

class Edge {
  final int from;
  final int to;

  Edge(this.from, this.to);

  @override
  String toString() => 'Edge($from, $to)';
}

class Digraph {
  late int _vertexCount;
  late int _edgeCount;
  late List<List<int>> _adjacencyLists;

  Digraph(int vertexCount) {
    if (vertexCount < 0) {
      throw ArgumentError('Number of vertices must be non-negative');
    }

    _vertexCount = vertexCount;
    _edgeCount = 0;
    _adjacencyLists = List.generate(vertexCount, (_) => <int>[]);
  }

  void addEdge(int from, int to) {
    _validateVertex(from);
    _validateVertex(to);
    _adjacencyLists[from].add(to);
    _edgeCount++;
  }

  int get vertexCount => _vertexCount;

  int get edgeCount => _edgeCount;

  List<int> adjacencyList(int vertex) {
    _validateVertex(vertex);
    return List.unmodifiable(_adjacencyLists[vertex]);
  }

  void _validateVertex(int vertex) {
    if (vertex < 0 || vertex >= _vertexCount) {
      throw ArgumentError('Vertex must be between 0 and ${_vertexCount - 1}: $vertex');
    }
  }

  @override
  String toString() {
    String result = 'Digraph has $_vertexCount vertices and $_edgeCount edges\nAdjacency lists:\n';
    for (int vertex = 0; vertex < _vertexCount; vertex++) {
      String vertexStr = vertex < 10 ? ' $vertex' : '$vertex';
      List<int> sortedAdj = List.from(_adjacencyLists[vertex])..sort();
      result += '$vertexStr: ${sortedAdj.join(' ')}\n';
    }
    return result;
  }
}

class GabowSCC {
  static const int _NONE = -1;

  late List<bool> _visited;
  late List<int> _componentIDs;
  late List<int> _preorders;
  late int _preorderCount;
  late int _sccCount;
  late Queue<int> _visitedVerticesStack;
  late Queue<int> _auxiliaryStack;

  GabowSCC(Digraph digraph) {
    _visited = List.filled(digraph.vertexCount, false);
    _componentIDs = List.filled(digraph.vertexCount, _NONE);
    _preorders = List.filled(digraph.vertexCount, _NONE);
    _preorderCount = 0;
    _sccCount = 0;
    _visitedVerticesStack = Queue<int>();
    _auxiliaryStack = Queue<int>();

    for (int vertex = 0; vertex < digraph.vertexCount; vertex++) {
      if (!_visited[vertex]) {
        _depthFirstSearch(digraph, vertex);
      }
    }
  }

  List<List<int>> components() {
    List<List<int>> components = List.generate(_sccCount, (_) => <int>[]);

    for (int vertex = 0; vertex < _visited.length; vertex++) {
      int componentID = _componentIDs[vertex];
      if (componentID != _NONE) {
        components[componentID].add(vertex);
      } else {
        throw StateError('Warning: Vertex $vertex has no SCC ID assigned.');
      }
    }

    return components;
  }

  bool isStronglyConnected(int v, int w) {
    _validateVertex(v);
    _validateVertex(w);
    return _componentIDs[v] != _NONE && _componentIDs[v] == _componentIDs[w];
  }

  int componentID(int vertex) {
    _validateVertex(vertex);
    return _componentIDs[vertex];
  }

  int stronglyConnectedComponentCount() => _sccCount;

  void _depthFirstSearch(Digraph digraph, int vertex) {
    _visited[vertex] = true;
    _preorders[vertex] = _preorderCount;
    _preorderCount++;
    _visitedVerticesStack.addLast(vertex);
    _auxiliaryStack.addLast(vertex);

    for (int w in digraph.adjacencyList(vertex)) {
      if (!_visited[w]) {
        _depthFirstSearch(digraph, w);
      } else if (_componentIDs[w] == _NONE) {
        while (_auxiliaryStack.isNotEmpty &&
               _preorders[_auxiliaryStack.last] > _preorders[w]) {
          _auxiliaryStack.removeLast();
        }
      }
    }

    if (_auxiliaryStack.isNotEmpty && _auxiliaryStack.last == vertex) {
      _auxiliaryStack.removeLast();

      while (_visitedVerticesStack.isNotEmpty) {
        int w = _visitedVerticesStack.removeLast();
        _componentIDs[w] = _sccCount;
        if (w == vertex) {
          break;
        }
      }
      _sccCount++;
    }
  }

  void _validateVertex(int vertex) {
    int visitedCount = _visited.length;
    if (vertex < 0 || vertex >= visitedCount) {
      throw ArgumentError('Vertex $vertex is not between 0 and ${visitedCount - 1}');
    }
  }
}

void main() {
  List<Edge> edges = [
    Edge(4, 2), Edge(2, 3), Edge(3, 2), Edge(6, 0), Edge(0, 1),
    Edge(2, 0), Edge(11, 12), Edge(12, 9), Edge(9, 10), Edge(9, 11), Edge(8, 9),
    Edge(10, 12), Edge(0, 5), Edge(5, 4), Edge(3, 5), Edge(6, 4), Edge(6, 9),
    Edge(7, 6), Edge(7, 8), Edge(8, 7), Edge(5, 3), Edge(0, 6)
  ];

  Digraph digraph = Digraph(13);

  for (Edge edge in edges) {
    digraph.addEdge(edge.from, edge.to);
  }

  print('Constructed digraph:');
  print(digraph);

  GabowSCC gabowSCC = GabowSCC(digraph);
  print('It has ${gabowSCC.stronglyConnectedComponentCount()} strongly connected components.');

  List<List<int>> components = gabowSCC.components();
  print('\nComponents:');
  for (int i = 0; i < components.length; i++) {
    print('Component $i: ${components[i].join(' ')}');
  }

  // Example usage of the isStronglyConnected() and componentID() methods
  print('\nExample connectivity checks:');
  print('Vertices 0 and 3 strongly connected? ${gabowSCC.isStronglyConnected(0, 3)}');
  print('Vertices 0 and 7 strongly connected? ${gabowSCC.isStronglyConnected(0, 7)}');
  print('Vertices 9 and 12 strongly connected? ${gabowSCC.isStronglyConnected(9, 12)}');
  print('Component ID of vertex 5: ${gabowSCC.componentID(5)}');
  print('Component ID of vertex 8: ${gabowSCC.componentID(8)}');
}
