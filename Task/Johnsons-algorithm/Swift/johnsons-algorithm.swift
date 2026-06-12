import Foundation

struct Edge {
    let u: Int
    let v: Int
    let weight: Double
}

struct VertexAndWeight {
    let vertex: Int
    let weight: Double
}

class JohnsonAlgorithm {

    private static let INF = Double.greatestFiniteMagnitude

    static func main() {
        // The element (i, j) is the weight of the edge from vertex i to vertex j.
        // INF, for infinity, means that there is no edge from vertex i to vertex j.
        let graph = [
            [0.0, -5.0, 2.0, 3.0],
            [INF, 0.0, 4.0, INF],
            [INF, INF, 0.0, 1.0],
            [INF, INF, INF, 0.0]
        ]

        let result = johnsonsAlgorithm(graph: graph)

        if let shortestPaths = result {
            print("All pairs shortest paths:")
            print("The element (i, j) is the shortest path between vertex i and vertex j.")
            for row in shortestPaths {
                print("[", terminator: "")
                for number in row {
                    print(number == INF ? "INF" : "\(number)", terminator: " ")
                }
                print("]")
            }
        } else {
            print("A negative cycle was detected in the graph.")
        }
    }

    private static func johnsonsAlgorithm(graph: [[Double]]) -> [[Double]]? {
        let vertexCount = graph.count
        var originalEdges = [Edge]()

        // Step 0: Build a list of edges for the original graph
        for i in 0..<vertexCount {
            for j in 0..<vertexCount {
                let weight = graph[i][j]
                if i == j {
                    if weight != 0.0 {
                        print("Warning: graph[i][i] for i = \(i) is \(weight), expected to be 0.0, resetting it to 0.0")
                    }
                } else if weight != INF {
                    originalEdges.append(Edge(u: i, v: j, weight: weight))
                }
            }
        }

        // Step 1: Form the augmented graph
        var augmentedEdges = originalEdges
        for i in 0..<vertexCount {
            augmentedEdges.append(Edge(u: vertexCount, v: i, weight: 0.0))
        }

        // Step 2: Invoke the Bellman-Ford Algorithm starting from the new vertex
        guard let hValues = bellmanFordAlgorithm(augmentedVertexCount: vertexCount + 1, edges: augmentedEdges, sourceVertex: vertexCount) else {
            return nil // A negative cycle was detected by the Bellman-Ford Algorithm
        }

        var values = hValues
        values.removeLast() // Remove the value for the augmented vertex

        // Step 3: Reweight the edges
        var reweightedAdjacencies = [Int: [VertexAndWeight]]()
        for v in 0..<vertexCount {
            reweightedAdjacencies[v] = [VertexAndWeight]()
        }

        for edge in originalEdges {
            if values[edge.u] == INF || values[edge.v] == INF {
                print("Warning: invalid hValues detected by the Bellman-Ford Algorithm.")
            }
            let reweight = edge.weight + values[edge.u] - values[edge.v]
            reweightedAdjacencies[edge.u]?.append(VertexAndWeight(vertex: edge.v, weight: reweight))
        }

        // Step 4: Invoke Dijkstra's Algorithm starting from each vertex on the reweighted graph
        var allPairsShortestPaths = [[Double]]()
        for u in 0..<vertexCount {
            let shortestPaths = dijkstraAlgorithm(vertexCount: vertexCount, reweightedAdjacencies: reweightedAdjacencies, sourceVertex: u, values: values)
            allPairsShortestPaths.append(shortestPaths)
        }

        // Step 5: Return the result matrix
        return allPairsShortestPaths
    }

    private static func bellmanFordAlgorithm(augmentedVertexCount: Int, edges: [Edge], sourceVertex: Int) -> [Double]? {
        var distances = [Double](repeating: INF, count: augmentedVertexCount)
        distances[sourceVertex] = 0.0

        // Relax the edges (augmentedVertexCount - 1) times
        var updated: Bool
        for _ in 0..<augmentedVertexCount - 1 {
            updated = false
            for edge in edges {
                if distances[edge.u] != INF && distances[edge.u] + edge.weight < distances[edge.v] {
                    distances[edge.v] = distances[edge.u] + edge.weight
                    updated = true
                }
            }
            if !updated { break }
        }

        // Check for negative cycles in the graph
        for edge in edges {
            if distances[edge.u] != INF && distances[edge.u] + edge.weight < distances[edge.v] {
                return nil // Indicates to the calling method that a negative cycle has been detected
            }
        }

        return distances
    }

    private static func dijkstraAlgorithm(vertexCount: Int, reweightedAdjacencies: [Int: [VertexAndWeight]], sourceVertex: Int, values: [Double]) -> [Double] {
        var distances = [Double](repeating: INF, count: vertexCount)
        distances[sourceVertex] = 0.0

        var priorityQueue = [VertexAndWeight]()
        priorityQueue.append(VertexAndWeight(vertex: sourceVertex, weight: 0.0))

        var finalDistances = [Double](repeating: INF, count: vertexCount)

        while !priorityQueue.isEmpty {
            priorityQueue.sort { $0.weight < $1.weight }
            let vertexAndWeight = priorityQueue.removeFirst()
            let vertex = vertexAndWeight.vertex

            if vertexAndWeight.weight > distances[vertex] {
                continue
            }

            // Store the final shortest path distance, translated back to the distance in the original graph
            if finalDistances[vertex] == INF {
                if distances[vertex] == INF {
                    finalDistances[vertex] = INF
                } else {
                    finalDistances[vertex] = distances[vertex] - values[sourceVertex] + values[vertex]
                }
            }

            // Relax the edges outgoing from vertex
            if let adjacencies = reweightedAdjacencies[vertex] {
                for pair in adjacencies {
                    if distances[vertex] != INF && distances[vertex] + pair.weight < distances[pair.vertex] {
                        distances[pair.vertex] = distances[vertex] + pair.weight
                        priorityQueue.append(VertexAndWeight(vertex: pair.vertex, weight: distances[pair.vertex]))
                    }
                }
            }
        }

        // Translate distance back to its original weight for any remaining reachable vertices
        for i in 0..<vertexCount {
            if finalDistances[i] == INF && distances[i] != INF {
                finalDistances[i] = distances[i] - values[sourceVertex] + values[i]
            }
        }

        return finalDistances
    }
}

// Run the algorithm
JohnsonAlgorithm.main()

