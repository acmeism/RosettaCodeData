import Foundation

// MARK: - Main Program
struct Edge {
    let from: Int
    let to: Int
}

func main() {
    let edges = [
        Edge(from: 4, to: 2), Edge(from: 2, to: 3), Edge(from: 3, to: 2), Edge(from: 6, to: 0),
        Edge(from: 0, to: 1), Edge(from: 2, to: 0), Edge(from: 11, to: 12), Edge(from: 12, to: 9),
        Edge(from: 9, to: 10), Edge(from: 9, to: 11), Edge(from: 8, to: 9), Edge(from: 10, to: 12),
        Edge(from: 0, to: 5), Edge(from: 5, to: 4), Edge(from: 3, to: 5), Edge(from: 6, to: 4),
        Edge(from: 6, to: 9), Edge(from: 7, to: 6), Edge(from: 7, to: 8), Edge(from: 8, to: 7),
        Edge(from: 5, to: 3), Edge(from: 0, to: 6)
    ]

    var digraph = Digraph(vertexCount: 13)

    for edge in edges {
        digraph.addEdge(from: edge.from, to: edge.to)
    }

    print("Constructed digraph:")
    print(digraph)

    let gabowSCC = GabowSCC(digraph: digraph)
    print("It has \(gabowSCC.stronglyConnectedComponentCount()) strongly connected components.")

    let components = gabowSCC.components()
    print("\nComponents:")
    for (i, component) in components.enumerated() {
        let componentString = component.map(String.init).joined(separator: " ")
        print("Component \(i): \(componentString)")
    }

    // Example usage of the isStronglyConnected() and componentID() methods
    print("\nExample connectivity checks:")
    print("Vertices 0 and 3 strongly connected? \(gabowSCC.isStronglyConnected(0, 3))")
    print("Vertices 0 and 7 strongly connected? \(gabowSCC.isStronglyConnected(0, 7))")
    print("Vertices 9 and 12 strongly connected? \(gabowSCC.isStronglyConnected(9, 12))")
    print("Component ID of vertex 5: \(gabowSCC.componentID(5))")
    print("Component ID of vertex 8: \(gabowSCC.componentID(8))")
}

// MARK: - Gabow's SCC Algorithm
/// Determination of the strongly connected components (SCC's) of a directed graph using Gabow's algorithm.
final class GabowSCC {
    private static let NONE = -1

    private var visited: [Bool]
    private var componentIDs: [Int]
    private var preorders: [Int]
    private var preorderCount: Int
    private var sccCount: Int
    private var visitedVerticesStack: [Int]
    private var auxiliaryStack: [Int]

    init(digraph: Digraph) {
        let vertexCount = digraph.doVertexCount()

        visited = Array(repeating: false, count: vertexCount)
        componentIDs = Array(repeating: GabowSCC.NONE, count: vertexCount)
        preorders = Array(repeating: GabowSCC.NONE, count: vertexCount)
        preorderCount = 0
        sccCount = 0
        visitedVerticesStack = []
        auxiliaryStack = []

        for vertex in 0..<vertexCount {
            if !visited[vertex] {
                depthFirstSearch(digraph: digraph, vertex: vertex)
            }
        }
    }

    /// Return, for each vertex, a list of its strongly connected vertices
    func components() -> [[Int]] {
        var components = Array(repeating: [Int](), count: sccCount)

        for vertex in 0..<visited.count {
            let componentID = self.componentID(vertex)
            if componentID != GabowSCC.NONE {
                components[componentID].append(vertex)
            } else {
                // Could be caused by the digraph edges being changed by the user
                fatalError("Warning: Vertex \(vertex) has no SCC ID assigned.")
            }
        }

        return components
    }

    /// Return whether or not vertices 'v' and 'w' are in the same strongly connected component.
    func isStronglyConnected(_ v: Int, _ w: Int) -> Bool {
        validateVertex(v)
        validateVertex(w)
        // If either vertex was not visited, for example, due to it being in an unconnected graph component,
        // its id will be 'NONE', and they cannot be strongly connected unless
        // the graph is empty or has isolated vertices which is handled by the return condition below.
        return componentIDs[v] != GabowSCC.NONE && componentIDs[v] == componentIDs[w]
    }

    /// Return the component ID of the strong component containing 'vertex'.
    func componentID(_ vertex: Int) -> Int {
        validateVertex(vertex)
        return componentIDs[vertex]
    }

    func stronglyConnectedComponentCount() -> Int {
        return sccCount
    }

    private func depthFirstSearch(digraph: Digraph, vertex: Int) {
        visited[vertex] = true
        preorders[vertex] = preorderCount
        preorderCount += 1
        visitedVerticesStack.append(vertex)
        auxiliaryStack.append(vertex)

        for w in digraph.adjacencyList(vertex) {
            if !visited[w] {
                depthFirstSearch(digraph: digraph, vertex: w)
                // If 'w' is visited, but not yet assigned to a SCC,
                // then 'w' is on the current depth first path,
                // or in a SCC which has already been processed in this depth first path,
                // and this will be handled by the 'auxiliaryStack'.
            } else if componentIDs[w] == GabowSCC.NONE {
                // Pop vertices from the 'auxiliaryStack' until the top vertex has a preorder <= preorder of 'w'.
                // This maintains the invariant that 'auxiliaryStack' contains a path of potential SCC roots.
                while !auxiliaryStack.isEmpty && preorders[auxiliaryStack.last!] > preorders[w] {
                    auxiliaryStack.removeLast()
                }
            }
        }

        // 'vertex' is the root of a SCC,
        // if it remains on top of the 'auxiliaryStack' after exploring all of its descendants and back-edges.
        if !auxiliaryStack.isEmpty && auxiliaryStack.last! == vertex {
            auxiliaryStack.removeLast()
            // Pop vertices from the 'auxiliaryStack' until 'vertex' is popped,
            // and assign these vertices the current strongly connected component id.
            while !visitedVerticesStack.isEmpty {
                let w = visitedVerticesStack.removeLast()
                componentIDs[w] = sccCount
                if w == vertex {
                    break
                }
            }
            sccCount += 1
        }
    }

    private func validateVertex(_ vertex: Int) {
        let visitedCount = visited.count
        if vertex < 0 || vertex >= visitedCount {
            fatalError("Vertex \(vertex) is not between 0 and \(visitedCount - 1)")
        }
    }
}

// MARK: - Digraph
/// Representation of a directed graph, or digraph, using adjacency lists.
/// Vertices are identified by integers starting from zero.
struct Digraph {
    private var vertexCount: Int
    private var edgeCount: Int
    private var adjacencyLists: [[Int]]

    init(vertexCount: Int) {
        guard vertexCount >= 0 else {
            fatalError("Number of vertices must be non-negative")
        }

        self.vertexCount = vertexCount
        self.edgeCount = 0
        self.adjacencyLists = Array(repeating: [], count: vertexCount)
    }

    mutating func addEdge(from: Int, to: Int) {
        validateVertex(from)
        validateVertex(to)
        adjacencyLists[from].append(to)
        edgeCount += 1
    }

    func doVertexCount() -> Int {
        return vertexCount
    }

    func doEdgeCount() -> Int {
        return edgeCount
    }

    func adjacencyList(_ vertex: Int) -> [Int] {
        validateVertex(vertex)
        return adjacencyLists[vertex]
    }

    private func validateVertex(_ vertex: Int) {
        if vertex < 0 || vertex >= vertexCount {
            fatalError("Vertex must be between 0 and \(vertexCount): \(vertex)")
        }
    }
}

extension Digraph: CustomStringConvertible {
    var description: String {
        var result = "Digraph has \(vertexCount) vertices and \(edgeCount) edges\n"
        result += "Adjacency lists:\n"

        for vertex in 0..<vertexCount {
            let padding = vertex < 10 ? " " : ""
            let sortedAdjacencies = adjacencyLists[vertex].sorted().map(String.init).joined(separator: " ")
            result += "\(padding)\(vertex): \(sortedAdjacencies)\n"
        }

        return result
    }
}

// Run the main function
main()
