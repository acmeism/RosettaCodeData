struct Edge {
    let u: Int
    let v: Int
    let weight: Double
}

class Graph {
    private var edges: [Edge] = []
    private let vertexCount: Int

    init(vertexCount: Int) {
        self.vertexCount = vertexCount
    }

    func addEdge(_ edge: Edge) {
        edges.append(edge)
    }

    func boruvkaMinimumSpanningTree() {
        var parent = Array(0..<vertexCount)
        var rank = Array(repeating: 0, count: vertexCount)
        var cheapest = Array(repeating: Edge(u: -1, v: -1, weight: -1.0), count: vertexCount)
        var treeCount = vertexCount
        var minimumSpanningTreeWeight = 0.0

        while treeCount > 1 {
            // Traverse through all edges and update cheapest edge for every tree
            for edge in edges {
                let u = edge.u
                let v = edge.v
                let weight = edge.weight
                let index1 = find(&parent, u)
                let index2 = find(&parent, v)

                if index1 != index2 {
                    if cheapest[index1].weight == -1.0 || cheapest[index1].weight > weight {
                        cheapest[index1] = Edge(u: u, v: v, weight: weight)
                    }
                    if cheapest[index2].weight == -1.0 || cheapest[index2].weight > weight {
                        cheapest[index2] = Edge(u: u, v: v, weight: weight)
                    }
                }
            }

            // Add the cheapest edges to the minimum spanning tree
            for vertex in 0..<vertexCount {
                if cheapest[vertex].weight != -1.0 {
                    let u = cheapest[vertex].u
                    let v = cheapest[vertex].v
                    let weight = cheapest[vertex].weight
                    let index1 = find(&parent, u)
                    let index2 = find(&parent, v)

                    if index1 != index2 {
                        minimumSpanningTreeWeight += weight
                        unionSet(&parent, &rank, index1, index2)
                        print("Edge \(u)--\(v) with weight \(weight) is included in the minimum spanning tree")
                        treeCount -= 1
                    }
                }
            }
        }

        print("\nWeight of minimum spanning tree is \(minimumSpanningTreeWeight)")
    }

    private func find(_ parent: inout [Int], _ vertex: Int) -> Int {
        if parent[vertex] != vertex {
            parent[vertex] = find(&parent, parent[vertex])
        }
        return parent[vertex]
    }

    private func unionSet(_ parent: inout [Int], _ rank: inout [Int], _ u: Int, _ v: Int) {
        let uRoot = find(&parent, u)
        let vRoot = find(&parent, v)

        if rank[uRoot] < rank[vRoot] {
            parent[uRoot] = vRoot
        } else if rank[uRoot] > rank[vRoot] {
            parent[vRoot] = uRoot
        } else {
            parent[vRoot] = uRoot
            rank[uRoot] += 1
        }
    }
}

// Example usage
let graph = Graph(vertexCount: 4)
graph.addEdge(Edge(u: 0, v: 1, weight: 10.0))
graph.addEdge(Edge(u: 0, v: 2, weight: 6.0))
graph.addEdge(Edge(u: 0, v: 3, weight: 5.0))
graph.addEdge(Edge(u: 1, v: 3, weight: 15.0))
graph.addEdge(Edge(u: 2, v: 3, weight: 4.0))
graph.boruvkaMinimumSpanningTree()

