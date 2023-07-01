class Graph {
    construct new(s, edges) {
        _vertices = s.split(", ")
        var n = _vertices.count
        _adjacency = List.filled(n, null)
        for (i in 0...n) _adjacency[i] = List.filled(n, false)
        for (edge in edges) _adjacency[edge[0]][edge[1]] = true
    }

    hasDependency(r, todo) {
        for (c in todo) if (_adjacency[r][c]) return true
        return false
    }

    topoSort() {
        var res = []
        var todo = List.filled(_vertices.count, 0)
        for (i in 0...todo.count) todo[i] = i
        while (!todo.isEmpty) {
            var outer = false
            var i = 0
            for (r in todo) {
                if (!hasDependency(r, todo)) {
                    todo.removeAt(i)
                    res.add(_vertices[r])
                    outer = true
                    break
                }
                i = i + 1
            }
            if (!outer) {
                System.print("Graph has cycles")
                return ""
            }
        }
        return res
    }
}

var s = "std, ieee, des_system_lib, dw01, dw02, dw03, dw04, dw05, " +
        "dw06, dw07, dware, gtech, ramlib, std_cell_lib, synopsys"

var deps = [
    [2, 0], [2, 14], [2, 13], [2, 4], [2, 3], [2, 12], [2, 1],
    [3, 1], [3, 10], [3, 11],
    [4, 1], [4, 10],
    [5, 0], [5, 14], [5, 10], [5, 4], [5, 3], [5, 1], [5, 11],
    [6, 1], [6, 3], [6, 10], [6, 11],
    [7, 1], [7, 10],
    [8, 1], [8, 10],
    [9, 1], [9, 10],
    [10, 1],
    [11, 1],
    [12, 0], [12, 1],
    [13, 1]
]

var g = Graph.new(s, deps)
System.print("Topologically sorted order:")
System.print(g.topoSort())
System.print()
// now insert [3, 6] at index 10 of deps
deps.insert(10, [3, 6])
var g2 = Graph.new(s, deps)
System.print("Following the addition of dw04 to the dependencies of dw01:")
System.print(g2.topoSort())
