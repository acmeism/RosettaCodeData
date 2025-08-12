void main() {
  List<List<int>> weights = [
    [1, 3, -2],
    [2, 1, 4],
    [2, 3, 3],
    [3, 4, 2],
    [4, 2, -1]
  ];
  int numVertices = 4;
  floydWarshall(weights, numVertices);
}

void floydWarshall(List<List<int>> weights, int numVertices) {
  List<List<double>> dist = List.generate(
      numVertices, (_) => List.filled(numVertices, double.infinity));

  for (var w in weights) {
    dist[w[0] - 1][w[1] - 1] = w[2].toDouble();
  }

  List<List<int>> next = List.generate(
      numVertices, (i) => List.generate(numVertices, (j) => j != i ? j + 1 : 0));

  for (int k = 0; k < numVertices; k++) {
    for (int i = 0; i < numVertices; i++) {
      for (int j = 0; j < numVertices; j++) {
        if (dist[i][k] + dist[k][j] < dist[i][j]) {
          dist[i][j] = dist[i][k] + dist[k][j];
          next[i][j] = next[i][k];
        }
      }
    }
  }

  printResult(dist, next);
}

void printResult(List<List<double>> dist, List<List<int>> next) {
  print("pair     dist    path");
  for (int i = 0; i < next.length; i++) {
    for (int j = 0; j < next.length; j++) {
      if (i != j) {
        int u = i + 1;
        int v = j + 1;
        String path = "$u -> $v    ${dist[i][j].toInt()}     $u";
        do {
          u = next[u - 1][v - 1];
          path += " -> $u";
        } while (u != v);
        print(path);
      }
    }
  }
}
