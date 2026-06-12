import "./dynamic" for Struct
import "./set" for Set
import "random" for Random

/* Helper structs. */
var Point    = Struct.create("Point", ["x", "y", "id"])
var Edge     = Struct.create("Edge", ["u", "v", "weight", "id"])
var Neighbor = Struct.create("Neighbor", ["neighbor", "edgeId"])

/* Random number generator. */
var rand = Random.new()

/* Helper functions. */
var toFixed2 = Fn.new { |f| (f * 100).round / 100 }

var printContainer = Fn.new { |container, name|
    System.print("%(name): [%(container.join(", "))]")
}

var printEdges = Fn.new { |edges, name|
    var edgeStrings = edges.map { |e| "%(e.u), %(e.v), %(toFixed2.call(e.weight))" }
    System.print("%(name): [%(edgeStrings.join(", "))]")
}

var printGraph = Fn.new { |graph, name|
    System.print("%(name): {")
    var n = graph.count
    for (i in 0...n) {
        var entries = []
        for (j in 0...n) {
            if (i != j) entries.add("%(j): %(toFixed2.call(graph[i][j]))")
        }
        System.print("   %(i): {%(entries.join(", "))}%(i == n - 1 ? "" : ",")")
    }
    System.print("}")
}

/* Euclidean distance. */
var getLength = Fn.new { |p1, p2|
    var dx = p1.x - p2.x
    var dy = p1.y - p2.y
    return (dx * dx + dy * dy).sqrt
}

/* Build Complete Graph (Adjacency Matrix). */
var buildGraph = Fn.new { |data|
    var n = data.count
    // Initialize n x n list with 0's.
    var graph = List.filled(n, null)
    for (i in 0...n) graph[i] = List.filled(n, 0)
    for (i in 0...n) {
        // Only calculate upper triangle.
        var j = i + 1
        while (j < n) {
            var dist = getLength.call(data[i], data[j])
            graph[i][j] = dist
            graph[j][i] = dist  // symmetric graph
            j = j + 1
        }
    }
    return graph
}

/* Union-Find Data Structure. */
class UnionFind {
    construct new(n) {
        // Initialize parent list: each node is its own parent.
        _parent = List.filled(n, 0)
        for (i in 0...n) _parent[i] = i
        // Initialize rank (or size) list for optimization.
        _rank = List.filled(n, 0)
    }

    find(i) {
        if (_parent[i] == i) return i
        // Path compression: point directly to the root.
        _parent[i] = find(_parent[i])
        return _parent[i]
    }

    unite(i, j) {
        var rootI = find(i)
        var rootJ = find(j)
        if (rootI != rootJ) {
            // Union by rank: attach smaller rank tree under larger rank tree.
            if (_rank[rootI] < _rank[rootJ]) {
                _parent[rootI] = rootJ
            } else if (_rank[rootI] > _rank[rootJ]) {
                _parent[rootJ] = rootI
            } else {
                // Ranks are equal, choose one as parent and increment its rank.
                _parent[rootJ] = rootI
                _rank[rootI] = _rank[rootI] + 1
            }
            return true // successfully united
        }
        return false // already in the same set
    }
}

/* Minimum Spanning Tree (Kruskal's Algorithm). */
var minimumSpanningTree = Fn.new { |graph|
    var n = graph.count
    if (n == 0) return []
    var edges = []
    for (i in 0...n) {
        // Avoid duplicates and self-loops.
        var j = i + 1
        while (j < n) {
            edges.add(Edge.new(i, j, graph[i][j], null))
            j = j + 1
        }
    }
    // Sort edges by weight in ascending order.
    edges.sort { |a, b| a.weight < b.weight }
    var mst = []
    var uf = UnionFind.new(n)
    var edgesCount = 0
    for (edge in edges) {
        // If uniting forms a new connection:
        if (uf.unite(edge.u, edge.v)) {
            mst.add(edge)
            edgesCount = edgesCount + 1
            if (edgesCount == n - 1) break  // optimization: MST has n-1 edges
        }
    }
    return mst
}

/* Find Vertices with Odd Degree in MST. */
var findOddVertices = Fn.new { |mst, n|
    var degree = List.filled(n, 0)
    for (edge in mst) {
        degree[edge.u] = degree[edge.u] + 1
        degree[edge.v] = degree[edge.v] + 1
    }
    var oddVertices = []
    for (i in 0...n) {
        if (degree[i] % 2 != 0) oddVertices.add(i)
    }
    return oddVertices
}

/* Minimum Weight Matching (Greedy Heuristic)
   Fisher-Yates (Knuth) Shuffle algorithm. */
var shuffleArray = Fn.new { |array|
    rand.shuffle(array)  // uses F-Y uder the hood
}

// Note: This modifies the mst array by adding matching edges.
var minimumWeightMatching = Fn.new { |mst, graph, oddVertices|
    // Shuffle for randomness.
    shuffleArray.call(oddVertices)

    // Keep track of vertices already matched in this phase.
    var matched = Set.new()
    for (i in 0...oddVertices.count) {
        var v = oddVertices[i]
        if (matched.contains(v)) continue  // skip if already matched
        var minLength = Num.infinity
        var closestU = -1
        // Find the closest *unmatched* odd vertex.
        var j = i + 1
        while (j < oddVertices.count) {
            var u = oddVertices[j]
            if (!matched.contains(u)) {  // check if 'u' is available
                if (graph[v][u] < minLength) {
                    minLength = graph[v][u]
                    closestU = u
                }
            }
            j = j + 1
        }
        if (closestU != -1) {
            // Add the matching edge to the MST list (now a multigraph).
            mst.add(Edge.new(v, closestU, minLength, null))
            matched.add(v)
            matched.add(closestU)  // mark both as matched
        }
        // Christofides guarantees an even number of odd-degree vertices,
        // so every vertex *should* find a match in a perfect matching scenario.
        // The greedy approach might leave some unmatched if not careful,
        // but this loop structure should work.
    }
}

/* Find Eulerian Tour (Hierholzer's Algorithm). */
var findEulerianTour = Fn.new { |matchedMST, n|
    if (matchedMST.isEmpty) return []

    // Assign unique IDs to edges for tracking in the multigraph
    // (essential because multiple edges can exist between nodes).
    for (i in 0...matchedMST.count) matchedMST[i].id = i

    // Build adjacency list.
    var adj = List.filled(n, null)
    for (i in 0...n) adj[i] = []
    var edgeUsed = Set.new()  // store used edge IDs

    for (edge in matchedMST) {
        adj[edge.u].add(Neighbor.new(edge.v, edge.id))
        adj[edge.v].add(Neighbor.new(edge.u, edge.id))
    }

    var tour = []
    var stack = []

    // Start at any vertex with edges (guaranteed to exist if matchedMST is not empty).
    var startNode = matchedMST[0].u
    stack.add(startNode)
    var currentNode = startNode
    while (!stack.isEmpty) {
        currentNode = stack[-1]  // peek top of stack
        var foundUnusedEdge = false
        // Check outgoing edges from currentNode.
        while (!adj[currentNode].isEmpty) {
            // Look at last edge (efficient removal).
            var edgeInfo = adj[currentNode][adj[currentNode].count - 1]
            if (!edgeUsed.contains(edgeInfo.edgeId)) {
                // Found an unused edge.
                edgeUsed.add(edgeInfo.edgeId)    // mark edge as used
                stack.add(edgeInfo.neighbor)     // push neighbor onto stack
                adj[currentNode].removeAt(-1)    // remove edge for current node's list
                currentNode = edgeInfo.neighbor  // move to the neighbor
                foundUnusedEdge = true
                break  // break inner loop to process the new currentNode
            } else {
                // This edge was already used (by traversal from the other side), remove it.
                adj[currentNode].removeAt(-1)
            }
        }
        if (!foundUnusedEdge) {
            // If no unused edges from currentNode, backtrack.
            tour.add(stack.removeAt(-1))
        }
    }

    // The tour is constructed in reverse order by Hierholzer's algorithm.
    return tour[-1..0]
}

/* Main TSP Function (Christofides Approximation). */
var tsp = Fn.new { |data|
    var n = data.count
    if (n == 0) return [0, []]
    if (n == 1) {
        // If data points have explicit IDs use them, otherwise use index 0.
        var startId = data[0].id ? data[0].id : 0
        return [0, [startId]]
    }

    // Assign IDs if they don't exist, assuming order corresponds to 0..n-1.
    for (i in 0...data.count) if (!data[i].id) data[i].id = i

    System.print("Bulding graph...")
    var G = buildGraph.call(data)
    // printGraph.call(G, "Graph") // often too large to print meaningfully

    System.print("\nFinding Minimum Spanning Tree...")
    var MSTree = minimumSpanningTree.call(G)
    printEdges.call(MSTree, "MSTree")

    System.print("\nFinding odd degree vertices...")
    var oddVertices = findOddVertices.call(MSTree, n)
    printContainer.call(oddVertices, "Odd vertices in MSTree")

    System.print("\nFinding Minimum Weight Matching (greedy)...")
    // Create a new list containing MST edges to avoid modifying the original
    // MSTree variable directly. The matching edges will be added to this new list.
    var multigraphEdges = MSTree.toList
    // Pass a copy of oddVertices as it might be shuffled in place.
    minimumWeightMatching.call(multigraphEdges, G, oddVertices.toList)
    printEdges.call(multigraphEdges, "Minimum weight matching (MST + Matching Edges)")

    System.print("\nFinding Eulerian Tour...")
    var eulerianTour = findEulerianTour.call(multigraphEdges, n)
    printContainer.call(eulerianTour, "Eulerian tour")

    /* Create Hamiltonian Circuit by Skipping Visited Nodes. */
    if (eulerianTour.isEmpty && n > 0) {
        System.print("Error: Eulerian tour could not be found.")
        return [-1, []]  // indicate error
    }

    System.print("\nCreating Hamiltonian path (shortcutting)...")
    var path = []
    var length = 0
    var visited = Set.new()   // use Set for efficient O(1) average time complexity checks
    var currentPathNode = -1  // track the last node added to the *Hamiltonian* path
    for (node in eulerianTour) {
        if (!visited.contains(node)) {
            path.add(node)
            visited.add(node)
            if (currentPathNode != -1) { // add edge length from the previous node *in the path*
                length = length + G[currentPathNode][node]
            }
            currentPathNode = node  // update the last node added to the path
        }
    }

    // Add the edge back to the start to complete the cycle.
    if (!path.isEmpty) {
        // Edge from last node in path to first node.
        length = length + G[currentPathNode][path[0]]
        // Add the starting node again to show the cycle.
        path.add(path[0])
    }

    printContainer.call(path, "Result path")
    System.print("Result length of the path: %(toFixed2.call(length))")
}

// Input Data
var rawData = [
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
]

// Convert raw data to Point objects, using index as ID.
var dataPoints = (0...rawData.count).map { |i|
    var x = rawData[i][0]
    var y = rawData[i][1]
    var id = i // Use 0-based index as the vertex ID
    return Point.new(x, y, id)
}.toList

// Runs TSP
tsp.call(dataPoints)
