class Edge {
  final int u;
  final int v;
  final double weight;

  Edge(this.u, this.v, this.weight);
}

class Graph {
  final int vertexCount;
  final List<Edge> edges = [];

  Graph(this.vertexCount);

  void addEdge(Edge edge) {
    edges.add(edge);
  }

  void boruvkaMinimumSpanningTree() {
    List<int> parent = List.generate(vertexCount, (i) => i);
    List<int> rank = List.filled(vertexCount, 0);
    List<Edge?> cheapest = List.filled(vertexCount, null);
    int treeCount = vertexCount;
    double minimumSpanningTreeWeight = 0;

    while (treeCount > 1) {
      // Traverse through all edges and update cheapest edge for every tree
      for (final edge in edges) {
        final u = edge.u;
        final v = edge.v;
        final weight = edge.weight;
        final index1 = find(parent, u);
        final index2 = find(parent, v);

        if (index1 != index2) {
          if (cheapest[index1] == null || cheapest[index1]!.weight > weight) {
            cheapest[index1] = edge;
          }
          if (cheapest[index2] == null || cheapest[index2]!.weight > weight) {
            cheapest[index2] = edge;
          }
        }
      }

      // Add the cheapest edges to the minimum spanning tree
      for (int vertex = 0; vertex < vertexCount; ++vertex) {
        if (cheapest[vertex] != null) {
          final u = cheapest[vertex]!.u;
          final v = cheapest[vertex]!.v;
          final weight = cheapest[vertex]!.weight;
          final index1 = find(parent, u);
          final index2 = find(parent, v);

          if (index1 != index2) {
            minimumSpanningTreeWeight += weight;
            unionSet(parent, rank, index1, index2);
            print("Edge $u--$v with weight $weight is included in the minimum spanning tree");
            treeCount--;
          }
        }
      }
    }

    print("\nWeight of minimum spanning tree is $minimumSpanningTreeWeight");
  }

  int find(List<int> parent, int vertex) {
    if (parent[vertex] != vertex) {
      parent[vertex] = find(parent, parent[vertex]);
    }
    return parent[vertex];
  }

  void unionSet(List<int> parent, List<int> rank, int u, int v) {
    final uRoot = find(parent, u);
    final vRoot = find(parent, v);

    if (rank[uRoot] < rank[vRoot]) {
      parent[uRoot] = vRoot;
    } else if (rank[uRoot] > rank[vRoot]) {
      parent[vRoot] = uRoot;
    } else {
      parent[vRoot] = uRoot;
      rank[uRoot]++;
    }
  }
}

void main() {
  final graph = Graph(4);
  graph.addEdge(Edge(0, 1, 10.0));
  graph.addEdge(Edge(0, 2, 6.0));
  graph.addEdge(Edge(0, 3, 5.0));
  graph.addEdge(Edge(1, 3, 15.0));
  graph.addEdge(Edge(2, 3, 4.0));
  graph.boruvkaMinimumSpanningTree();
}

