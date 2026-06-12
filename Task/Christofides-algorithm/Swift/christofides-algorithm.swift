import Foundation

struct Pair {
    let x: Double
    let y: Double
}

struct Point {
    let pair: Pair
    let id: Int
}

struct Edge {
    let u: Int
    let v: Int
    let weight: Double

    func description() -> String {
        return String(format: "(%d, %d, %.2f)", u, v, weight)
    }
}

struct Result {
    let path: [Int]
    let length: Double
}

class UnionFind {
    private var parents: [Int]
    private var ranks: [Int]

    init(number: Int) {
        parents = Array(0..<number)
        ranks = Array(repeating: 0, count: number)
    }

    func find(_ n: Int) -> Int {
        if parents[n] == n {
            return n
        }
        parents[n] = find(parents[n])
        return parents[n]
    }

    func unite(_ i: Int, _ j: Int) -> Bool {
        let rootI = find(i)
        let rootJ = find(j)

        if rootI != rootJ {
            if ranks[rootI] < ranks[rootJ] {
                parents[rootI] = rootJ
            } else if ranks[rootI] > ranks[rootJ] {
                parents[rootJ] = rootI
            } else {
                parents[rootJ] = rootI
                ranks[rootI] += 1
            }
            return true
        }
        return false
    }
}

class Graph {
    private let pointCount: Int
    private var distanceLists: [[Double]]

    init(points: [Point]) {
        self.pointCount = points.count
        self.distanceLists = Array(repeating: Array(repeating: 0.0, count: pointCount), count: pointCount)

        for i in 0..<pointCount {
            for j in i+1..<pointCount {
                let dist = hypot(points[i].pair.x - points[j].pair.x, points[i].pair.y - points[j].pair.y)
                distanceLists[i][j] = dist
                distanceLists[j][i] = dist
            }
        }
    }

    func minimumSpanningTree() -> [Edge] {
        var edges = [Edge]()
        if pointCount == 0 {
            return edges
        }

        for i in 0..<pointCount {
            for j in i+1..<pointCount {
                edges.append(Edge(u: i, v: j, weight: distanceLists[i][j]))
            }
        }

        edges.sort { $0.weight < $1.weight }
        var minimumSpanningTree = [Edge]()
        let unionFind = UnionFind(number: pointCount)
        var edgeCount = 0

        for edge in edges {
            if unionFind.unite(edge.u, edge.v) {
                minimumSpanningTree.append(edge)
                edgeCount += 1
                if edgeCount == pointCount - 1 {
                    break
                }
            }
        }
        return minimumSpanningTree
    }

    func oddVertices(minimumSpanningTree: [Edge]) -> [Int] {
        var degrees = Array(repeating: 0, count: pointCount)
        for edge in minimumSpanningTree {
            degrees[edge.u] += 1
            degrees[edge.v] += 1
        }

        return degrees.enumerated().compactMap { $0.element % 2 == 1 ? $0.offset : nil }
    }

    func minimumWeightMatching(minimumSpanningTree: [Edge], oddVertices: [Int]) -> [Edge] {
        var minimumWeightMatching = minimumSpanningTree
        guard !oddVertices.isEmpty else {
            return minimumWeightMatching
        }

        var currentOdd = oddVertices.shuffled()
        var visited = Set<Int>()

        for i in 0..<currentOdd.count {
            guard !visited.contains(i) else { continue }

            let v = currentOdd[i]
            var minimumDistance = Double.greatestFiniteMagnitude
            var closestUIndex: Int?

            for j in i+1..<currentOdd.count {
                guard !visited.contains(j) else { continue }

                let u = currentOdd[j]
                if distanceLists[v][u] < minimumDistance {
                    minimumDistance = distanceLists[v][u]
                    closestUIndex = j
                }
            }

            if let j = closestUIndex {
                let u = currentOdd[j]
                minimumWeightMatching.append(Edge(u: v, v: u, weight: minimumDistance))
                visited.insert(i)
                visited.insert(j)
            } else {
                fatalError("Could not match an odd vertex in minimum weight matching: \(v)")
            }
        }

        return minimumWeightMatching
    }

    func eulerianCircuit(minimumWeightMatching: [Edge]) -> [Int] {
        var circuit = [Int]()
        guard !minimumWeightMatching.isEmpty else {
            return circuit
        }

        struct Twin {
            let halfEdge: Int
            let index: Int
        }

        var adjacencyLists = Array(repeating: [Twin](), count: pointCount)

        for (index, edge) in minimumWeightMatching.enumerated() {
            adjacencyLists[edge.u].append(Twin(halfEdge: edge.v, index: index))
            adjacencyLists[edge.v].append(Twin(halfEdge: edge.u, index: index))
        }

        var edgesUsed = Set<Int>()
        var stack = [Int]()
        var currentVertex = minimumWeightMatching.first!.u
        stack.append(currentVertex)

        while !stack.isEmpty {
            currentVertex = stack.last!
            var foundEdge = false

            while !adjacencyLists[currentVertex].isEmpty {
                let twin = adjacencyLists[currentVertex].removeLast()
                if !edgesUsed.contains(twin.index) {
                    edgesUsed.insert(twin.index)
                    stack.append(twin.halfEdge)
                    foundEdge = true
                    break
                }
            }

            if !foundEdge {
                circuit.append(stack.removeLast())
            }
        }

        circuit.reverse()
        return circuit
    }

    func hamiltonianCircuit(eulerianCircuit: [Int]) -> Result {
        var christofidesPath = [Int]()
        var length = 0.0
        var visited = Set<Int>()

        var current = eulerianCircuit.first!
        christofidesPath.append(current)
        visited.insert(current)

        for vertex in eulerianCircuit {
            if !visited.contains(vertex) {
                christofidesPath.append(vertex)
                visited.insert(vertex)
                length += distanceLists[current][vertex]
                current = vertex
            }
        }

        length += distanceLists[current][christofidesPath.first!]
        christofidesPath.append(christofidesPath.first!)
        return Result(path: christofidesPath, length: length)
    }

    func display() {
        print("Graph: {")
        for u in 0..<pointCount {
            print(String(format: "%3d", u) + ": {", terminator: "")
            for v in 0..<pointCount {
                if u != v {
                    if !(u == 0 && v == 1) && v > 0 {
                        print(", ", terminator: "")
                    }
                    print(String(format: "%d: %.2f", v, distanceLists[u][v]), terminator: "")
                }
            }
            print("}" + (u == pointCount - 1 ? "" : ","))
        }
        print("}\n")
    }
}

func christofidesPath(points: [Point]) -> Result {
    if points.isEmpty {
        return Result(path: [], length: 0.0)
    }
    if points.count == 1 {
        return Result(path: [points.first!.id], length: 0.0)
    }

    let graph = Graph(points: points)
    graph.display()
    let minimumSpanningTree = graph.minimumSpanningTree()
    print("Minimum spanning tree: \(minimumSpanningTree.map { $0.description() }.joined(separator: ", "))\n")
    let oddVertices = graph.oddVertices(minimumSpanningTree: minimumSpanningTree)
    print("Odd vertices in minimum spanning tree: \(oddVertices)\n")
    let minimumWeightMatching = graph.minimumWeightMatching(minimumSpanningTree: minimumSpanningTree, oddVertices: oddVertices)
    print("Minimum weight matching: \(minimumWeightMatching.map { $0.description() }.joined(separator: ", "))\n")

    let eulerianCircuit = graph.eulerianCircuit(minimumWeightMatching: minimumWeightMatching)
    print("Eulerian circuit: \(eulerianCircuit)\n")

    guard !eulerianCircuit.isEmpty else {
        print("Error: Christofides path could not be found.")
        return Result(path: [], length: -1.0)
    }

    let result = graph.hamiltonianCircuit(eulerianCircuit: eulerianCircuit)
    print("Result path: \(result.path)\n")
    print(String(format: "Length of the result path: %.2f", result.length))

    return result
}

func main() {
    let data = [
        Pair(x: 1380, y: 939), Pair(x: 2848, y: 96), Pair(x: 3510, y: 1671), Pair(x: 457, y: 334), Pair(x: 3888, y: 666),
        Pair(x: 984, y: 965), Pair(x: 2721, y: 1482), Pair(x: 1286, y: 525), Pair(x: 2716, y: 1432), Pair(x: 738, y: 1325),
        Pair(x: 1251, y: 1832), Pair(x: 2728, y: 1698), Pair(x: 3815, y: 169), Pair(x: 3683, y: 1533), Pair(x: 1247, y: 1945),
        Pair(x: 123, y: 862), Pair(x: 1234, y: 1946), Pair(x: 252, y: 1240), Pair(x: 611, y: 673), Pair(x: 2576, y: 1676),
        Pair(x: 928, y: 1700), Pair(x: 53, y: 857), Pair(x: 1807, y: 1711), Pair(x: 274, y: 1420), Pair(x: 2574, y: 946),
        Pair(x: 178, y: 24), Pair(x: 2678, y: 1825), Pair(x: 1795, y: 962), Pair(x: 3384, y: 1498), Pair(x: 3520, y: 1079),
        Pair(x: 1256, y: 61), Pair(x: 1424, y: 1728), Pair(x: 3913, y: 192), Pair(x: 3085, y: 1528), Pair(x: 2573, y: 1969),
        Pair(x: 463, y: 1670), Pair(x: 3875, y: 598), Pair(x: 298, y: 1513), Pair(x: 3479, y: 821), Pair(x: 2542, y: 236),
        Pair(x: 3955, y: 1743), Pair(x: 1323, y: 280), Pair(x: 3447, y: 1830), Pair(x: 2936, y: 337), Pair(x: 1621, y: 1830),
        Pair(x: 3373, y: 1646), Pair(x: 1393, y: 1368), Pair(x: 3874, y: 1318), Pair(x: 938, y: 955), Pair(x: 3022, y: 474),
        Pair(x: 2482, y: 1183), Pair(x: 3854, y: 923), Pair(x: 376, y: 825), Pair(x: 2519, y: 135), Pair(x: 2945, y: 1622),
        Pair(x: 953, y: 268), Pair(x: 2628, y: 1479), Pair(x: 2097, y: 981), Pair(x: 890, y: 1846), Pair(x: 2139, y: 1806),
        Pair(x: 2421, y: 1007), Pair(x: 2290, y: 1810), Pair(x: 1115, y: 1052), Pair(x: 2588, y: 302), Pair(x: 327, y: 265),
        Pair(x: 241, y: 341), Pair(x: 1917, y: 687), Pair(x: 2991, y: 792), Pair(x: 2573, y: 599), Pair(x: 19, y: 674),
        Pair(x: 3911, y: 1673), Pair(x: 872, y: 1559), Pair(x: 2863, y: 558), Pair(x: 929, y: 1766), Pair(x: 839, y: 620),
        Pair(x: 3893, y: 102), Pair(x: 2178, y: 1619), Pair(x: 3822, y: 899), Pair(x: 378, y: 1048), Pair(x: 1178, y: 100),
        Pair(x: 2599, y: 901), Pair(x: 3416, y: 143), Pair(x: 2961, y: 1605), Pair(x: 611, y: 1384), Pair(x: 3113, y: 885),
        Pair(x: 2597, y: 1830), Pair(x: 2586, y: 1286), Pair(x: 161, y: 906), Pair(x: 1429, y: 134), Pair(x: 742, y: 1025),
        Pair(x: 1625, y: 1651), Pair(x: 1187, y: 706), Pair(x: 1787, y: 1009), Pair(x: 22, y: 987), Pair(x: 3640, y: 43),
        Pair(x: 3756, y: 882), Pair(x: 776, y: 392), Pair(x: 1724, y: 1642), Pair(x: 198, y: 1810), Pair(x: 3950, y: 1558)
    ]

    let points = data.enumerated().map { Point(pair: $0.element, id: $0.offset) }
    let _ = christofidesPath(points: points)
}

main()

