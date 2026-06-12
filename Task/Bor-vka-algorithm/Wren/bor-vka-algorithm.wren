// Class to represent a graph
class Graph {
    construct new(vertices) {
        _v = vertices  // number of vertices
        _graph = []    // list of edges [u, v, w]
    }

    // Method to add an edge to the graph.
    addEdge(u, v, w) {
        _graph.add([u, v, w])
    }

    // A utility method to find the set of an element i
    // (uses path compression technique).
    find(parent, i) {
        if (parent[i] == i) return i
        var result = find(parent, parent[i])
        parent[i] = result  // path compression
        return result
    }

    // A method that performs union of two sets x and y
    // (uses union by rank).
    unionSet(parent, rank, x, y) {
        var xRoot = find(parent, x)
        var yRoot = find(parent, y)

        // Attach smaller rank tree under root of high rank tree.
        if (rank[xRoot] < rank[yRoot]) {
            parent[xRoot] = yRoot
        } else if (rank[xRoot] > rank[yRoot]) {
            parent[yRoot] = xRoot
        } else {
            // If ranks are the same, make one as root and increment its rank.
            parent[yRoot] = xRoot
            rank[xRoot] = rank[xRoot] + 1
        }
    }

    // The main method to construct MST using Boruvka's algorithm.
    boruvkaMst() {
        var parent = (0..._v).map { |i| i }.toList
        var rank = List.filled(_v, 0)

        // An array to store the index of the cheapest edge of each subset
        // It stores [u, v, w] for each component.
        var cheapest = List.filled(_v, null)
        for (i in 0..._v) cheapest[i] = [-1, -1, -1]

        // Initially there are V different trees
        // Finally there will be one tree that will be the MST.
        var numTrees = _v
        var mstWeight = 0

        // Keep combining components (or sets) until all
        // components are combined into a single MST.
        while (numTrees > 1) {
            // Traverse through all edges and update
            // cheapest edge for every component.
            for (edge in _graph) {
                var u = edge[0]
                var v = edge[1]
                var w = edge[2]

                var set1 = find(parent, u)
                var set2 = find(parent, v)

                // If two corners of current edge belong to different sets,
                // check if current edge is cheaper than previous cheapest edges.
                if (set1 != set2) {
                    if (cheapest[set1][2] == -1 || cheapest[set1][2] > w) {
                        cheapest[set1] = [u, v, w]
                    }
                    if (cheapest[set2][2] == -1 || cheapest[set2][2] > w) {
                        cheapest[set2] = [u, v, w]
                    }
                }
            }

            // Consider the picked cheapest edges and add them to the MST.
            for (node in 0..._v) {
                // Check if cheapest edge for current set exists.
                if (cheapest[node][2] != -1) {
                    var u = cheapest[node][0]
                    var v = cheapest[node][1]
                    var w = cheapest[node][2]

                    var set1 = find(parent, u)
                    var set2 = find(parent, v)

                    if (set1 != set2) {
                        mstWeight = mstWeight + w
                        unionSet(parent, rank, set1, set2)
                        System.print("Edge %(u)-%(v) with weight %(w) included in MST")
                        numTrees = numTrees - 1
                    }
                }
            }

            // Reset cheapest array for next iteration.
            for (node in 0..._v) cheapest[node][2] = -1
        }

        System.print("Weight of MST is %(mstWeight)")
    }
}

var g = Graph.new(4)
g.addEdge(0, 1, 10)
g.addEdge(0, 2, 6)
g.addEdge(0, 3, 5)
g.addEdge(1, 3, 15)
g.addEdge(2, 3, 4)

g.boruvkaMst()
