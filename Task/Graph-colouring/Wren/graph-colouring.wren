import "./dynamic" for Struct
import "./sort" for Sort
import "./fmt" for Fmt

// (n)umber of node and its (v)alence i.e. number of neighbors
var NodeVal = Struct.create("NodeVal", ["n", "v"])

class Graph {
    construct new(nn, st) {
        _nn  = nn                       // number of nodes
        _st  = st                       // node numbering starts from
        _nbr = List.filled(nn, null)    // neighbor list for each node
        for (i in 0...nn) _nbr[i] = []
    }

    nn { _nn }
    st { _st }

    // Note that this creates a single 'virtual' edge for an isolated node.
    addEdge(n1, n2) {
        // adjust to starting node number
        n1 = n1 - _st
        n2 = n2 - _st
        _nbr[n1].add(n2)
        if (n1 != n2) _nbr[n2].add(n1)
    }

    // Uses 'greedy' algorithm.
    greedyColoring {
        // create a list with a color for each node
        var cols = List.filled(_nn, -1) // -1 denotes no color assigned
        cols[0] = 0  // first node assigned color 0
        // create a bool list to keep track of which colors are available
        var available = List.filled(_nn, false)
        // assign colors to all nodes after the first
        for (i in 1..._nn) {
            // iterate through neighbors and mark their colors as available
            for (j in _nbr[i]) {
                if (cols[j] != -1) available[cols[j]] = true
            }
            // find the first available color
            var c = available.indexOf(false)
            cols[i] = c  // assign it to the current node
            // reset the neighbors' colors to unavailable
            // before the next iteration
            for (j in _nbr[i]) {
                if (cols[j] != -1) available[cols[j]] = false
            }
        }
        return cols
    }

    // Uses Welsh-Powell algorithm.
    wpColoring {
        // create NodeVal for each node
        var nvs = List.filled(_nn, null)
        for (i in 0..._nn) {
            var v = _nbr[i].count
            if (v == 1 && _nbr[i][0] == i) {  // isolated node
                v = 0
            }
            nvs[i] = NodeVal.new(i, v)
        }
        // sort the NodeVals in descending order by valence
        var cmp = Fn.new { |nv1, nv2| (nv2.v - nv1.v).sign }
        Sort.insertion(nvs, cmp) // stable sort

        // create colors list with entries for each node
        var cols = List.filled(_nn, -1)  // set all nodes to no color (-1) initially
        var currCol = 0 // start with color 0
        for (f in 0..._nn-1) {
            var h = nvs[f].n
            if (cols[h] != -1) {  // already assigned a color
                continue
            }
            cols[h] = currCol
            // assign same color to all subsequent uncolored nodes which are
            // not connected to a previous colored one
            var i = f + 1
            while (i < _nn) {
                var outer = false
                var j = nvs[i].n
                if (cols[j] != -1) {  // already colored
                    i = i + 1
                    continue
                }
                var k = f
                while (k < i) {
                    var l = nvs[k].n
                    if (cols[l] == -1) {  // not yet colored
                        k = k + 1
                        continue
                    }
                    if (_nbr[j].contains(l)) {
                        outer = true
                        break  // node j is connected to an earlier colored node
                    }
                    k = k + 1
                }
                if (!outer) cols[j] = currCol
                i = i + 1
            }
            currCol = currCol + 1
        }
        return cols
    }
}

var fns = [Fn.new { |g| g.greedyColoring }, Fn.new { |g| g.wpColoring }]
var titles = ["'Greedy'", "Welsh-Powell"]
var nns = [4, 8, 8, 8]
var starts = [0, 1, 1, 1]
var edges1 = [[0, 1], [1, 2], [2, 0], [3, 3]]
var edges2 = [[1, 6], [1, 7], [1, 8], [2, 5], [2, 7], [2, 8],
    [3, 5], [3, 6], [3, 8], [4, 5], [4, 6], [4, 7]]
var edges3 = [[1, 4], [1, 6], [1, 8], [3, 2], [3, 6], [3, 8],
    [5, 2], [5, 4], [5, 8], [7, 2], [7, 4], [7, 6]]
var edges4 = [[1, 6], [7, 1], [8, 1], [5, 2], [2, 7], [2, 8],
    [3, 5], [6, 3], [3, 8], [4, 5], [4, 6], [4, 7]]
var j = 0
for (fn in fns) {
    System.print("Using the %(titles[j]) algorithm:\n")
    var i = 0
    for (edges in [edges1, edges2, edges3, edges4]) {
        System.print("  Example %(i+1)")
        var g = Graph.new(nns[i], starts[i])
        for (e in edges) g.addEdge(e[0], e[1])
        var cols = fn.call(g)
        var ecount = 0  // counts edges
        for (e in edges) {
            if (e[0] != e[1]) {
                Fmt.print("    Edge  $d-$d -> Color $d, $d", e[0], e[1],
                    cols[e[0]-g.st], cols[e[1]-g.st])
                ecount = ecount + 1
            } else {
                Fmt.print("    Node  $d   -> Color $d\n", e[0], cols[e[0]-g.st])
            }
        }
        var maxCol = 0  // maximum color number used
        for (col in cols) {
            if (col > maxCol) maxCol = col
        }
        System.print("    Number of nodes  : %(nns[i])")
        System.print("    Number of edges  : %(ecount)")
        System.print("    Number of colors : %(maxCol+1)")
        System.print()
        i = i + 1
    }
    j = j + 1
}
