import "./llist" for DLinkedList
import "./seq" for Lst

var s = "top1, top2, ip1, ip2, ip3, ip1a, ip2a, ip2b, ip2c, ipcommon, des1, " +
        "des1a, des1b, des1c, des1a1, des1a2, des1c1, extra1"

var deps = [
    [ 0, 10], [ 0,  2], [ 0,  3],
    [ 1, 10], [ 1,  3], [ 1,  4],
    [ 2, 17], [ 2,  5], [ 2,  9],
    [ 3,  6], [ 3,  7], [ 3,  8], [ 3,  9],
    [10, 11], [10, 12], [10, 13],
    [11, 14], [11, 15],
    [13, 16], [13, 17],
]

var files = ["top1", "top2", "ip1"]

class Graph {
    construct new(s, edges) {
        _vertices = s.split(", ")
        var nv = _vertices.count
        _adjacency = List.filled(nv, null)
        for (i in 0...nv) _adjacency[i] = List.filled(nv, false)
        for (edge in edges) _adjacency[edge[0]][edge[1]] = true
        _numVertices = nv
    }

    topLevels {
        var result = []
        // look for empty columns
        for (c in 0..._numVertices) {
            var outer = false
            for (r in 0..._numVertices) {
                if (_adjacency[r][c]) {
                    outer = true
                    break
                }
            }
            if (!outer) result.add(_vertices[c])
        }
        return result
    }

    compileOrder(item) {
        var result = DLinkedList.new()
        var queue  = DLinkedList.new()
        queue.add(Lst.indexOf(_vertices, item))
        while (!queue.isEmpty) {
            var r = queue.removeAt(0)
            for (c in 0..._numVertices) {
                if (_adjacency[r][c] && !queue.contains(c)) queue.add(c)
            }
            result.prepend(_vertices[r])
        }
        return Lst.distinct(result.toList)
    }
}

var g = Graph.new(s, deps)
System.print("Top levels: %(g.topLevels)")
for (f in files) System.print("\nCompile order for %(f): %(g.compileOrder(f))")
