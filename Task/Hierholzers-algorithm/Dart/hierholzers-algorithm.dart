import 'dart:collection';

void printCircuit(List<List<int>> adj) {
  // Edge count map to track unused edges
  Map<int, int> edgeCount = {};

  for (var i = 0; i < adj.length; i++) {
    edgeCount[i] = adj[i].length;
  }

  if (adj.isEmpty) return;

  // Stack for current path
  Queue<int> currPath = Queue<int>();
  // List to store final circuit
  List<int> circuit = [];

  currPath.addFirst(0);
  var currV = 0;

  while (currPath.isNotEmpty) {
    if (edgeCount[currV]! > 0) {
      currPath.addFirst(currV);

      var nextV = adj[currV].last;
      edgeCount[currV] = edgeCount[currV]! - 1;
      adj[currV].removeLast();

      currV = nextV;
    } else {
      circuit.add(currV);
      currV = currPath.first;
      currPath.removeFirst();
    }
  }

  // Print circuit in reverse
  String result = circuit.reversed.join(" -> ");
  print(result);
}

void main() {
  // First adjacency list
  var adj1 = List.generate(3, (_) => <int>[]);
  adj1[0].add(1);
  adj1[1].add(2);
  adj1[2].add(0);

  printCircuit(adj1);

  // Second adjacency list
  var adj2 = List.generate(7, (_) => <int>[]);
  adj2[0].addAll([1, 6]);
  adj2[1].add(2);
  adj2[2].addAll([0, 3]);
  adj2[3].add(4);
  adj2[4].addAll([2, 5]);
  adj2[5].add(0);
  adj2[6].add(4);

  printCircuit(adj2);
}
