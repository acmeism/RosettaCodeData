typealias WeightedEdge = (Int, Int, Int)

struct Grid<T> {
  var nodes: [Node<T>]

  mutating func addNode(data: T) -> Int {
    nodes.append(Node(data: data, edges: []))

    return nodes.count - 1
  }

  mutating func createEdges(weights: [WeightedEdge]) {
    for (start, end, weight) in weights {
      nodes[start].edges.append((end, weight))
      nodes[end].edges.append((start, weight))
    }
  }

  func findPath(start: Int, end: Int) -> ([Int], Int)? {
    var dist = Array(repeating: (Int.max, nil as Int?), count: nodes.count)
    var heap = Heap<State>(sort: { $0.cost < $1.cost })

    dist[start] = (0, nil)
    heap.insert(State(node: start, cost: 0))

    while let state = heap.remove(at: 0) {
      if state.node == end {
        var path = [end]
        var currentDist = dist[end]

        while let prev = currentDist.1 {
          path.append(prev)
          currentDist = dist[prev]
        }

        return (path.reversed(), state.cost)
      }

      guard state.cost <= dist[state.node].0 else {
        continue
      }

      for edge in nodes[state.node].edges {
        let next = State(node: edge.0, cost: state.cost + edge.1)

        if next.cost < dist[next.node].0 {
          dist[next.node] = (next.cost, state.node)
          heap.insert(next)
        }
      }
    }

    return nil
  }
}

struct Node<T> {
  var data: T
  var edges: [(Int, Int)]
}

struct State {
  var node: Int
  var cost: Int
}

var grid = Grid<String>(nodes: [])

let (a, b, c, d, e, f) = (
  grid.addNode(data: "a"),
  grid.addNode(data: "b"),
  grid.addNode(data: "c"),
  grid.addNode(data: "d"),
  grid.addNode(data: "e"),
  grid.addNode(data: "f")
)

grid.createEdges(weights: [
  (a, b, 7), (a, c, 9), (a, f, 14),
  (b, c, 10), (b, d, 15), (c, d, 11),
  (c, f, 2), (d, e, 6), (e, f, 9)
])

guard let (path, cost) = grid.findPath(start: a, end: e) else {
  fatalError("Could not find path")
}

print("Cost: \(cost)")
print(path.map({ grid.nodes[$0].data }).joined(separator: " -> "))
