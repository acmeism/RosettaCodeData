import "./dynamic" for Tuple
import "./trait" for Comparable
import "./sort" for Cmp, Sort
import "./set" for Set

var Edge = Tuple.create("Edge", ["v1", "v2", "dist"])

// One vertex of the graph, complete with mappings to neighboring vertices
class Vertex is Comparable {
    static map { __map }  // maps a name to its corresponding Vertex

    construct new(name) {
        _name = name
        _dist = Num.maxSafeInteger  // assumed to be infinity
        _prev = null
        _neighbors = {}
        if (!__map) __map = {}
        __map[name] = this
    }

    name      { _name }
    dist      { _dist }
    dist=(d)  { _dist = d }
    prev      { _prev }
    prev=(v)  { _prev = v  }
    neighbors { _neighbors }

    printPath() {
        if (this == _prev) {
            System.write(_name)
        } else if (!_prev) {
            System.write("%(_name)(unreached)")
        } else {
            _prev.printPath()
            System.write(" -> %(_name)(%(_dist))")
        }
    }

    compare(other) {
        if (_dist == other.dist) return Cmp.string.call(_name, other.name)
        return Cmp.num.call(_dist, other.dist)
    }

    toString { "(%(_name), %(_dist))" }
}

class Graph {
    construct new(edges, directed, showAllPaths) {
        _graph = {}
        // one pass to find all vertices
        for (e in edges) {
            if (!_graph.containsKey(e.v1)) _graph[e.v1] = Vertex.new(e.v1)
            if (!_graph.containsKey(e.v2)) _graph[e.v2] = Vertex.new(e.v2)
        }

        // another pass to set neighboring vertices
        for (e in edges) {
            _graph[e.v1].neighbors[_graph[e.v2].name] = e.dist
            // also do this for an undirected graph if applicable
            if (!directed) _graph[e.v2].neighbors[_graph[e.v1].name] = e.dist
        }
        _showAllPaths = showAllPaths
        _directed = directed
    }

    // Runs dijkstra using a specified source vertex
    dijkstra(startName) {
        if (!_graph.containsKey(startName)) {
            System.print("Graph doesn't contain start vertex '%(startName)'")
            return
        }
        var source = _graph[startName]
        var q = Set.new()

        // set-up vertices
        for (v in _graph.values) {
            v.prev = (v == source) ? source : null
            v.dist = (v == source) ? 0 : Num.maxSafeInteger
            q.add(v.name)
        }
        dijkstra_(q)
    }

    // Implementation of dijkstra's algorithm using a (simulated) tree set
    dijkstra_(q) {
        while (!q.isEmpty) {
            var qq = q.toList
            Sort.heap(qq)
            // vertex with shortest distance (first iteration will return source)
            var u = Vertex.map[qq[0]]
            q.remove(qq[0])
            // if distance is infinite we can ignore 'u'
            // (and any other remaining vertices) since they are unreachable
            if (u.dist == Num.maxSafeInteger) break

            // look at distances to each neighbor
            for (a in u.neighbors) {
                var v = Vertex.map[a.key] // the neighbor in this iteration
                var alternateDist = u.dist + a.value
                if (alternateDist < v.dist) { // shorter path to neighbor found
                    v.dist = alternateDist
                    v.prev = u
                }
            }
        }
    }

    // Prints the path from the source to every vertex
    // (output order is not guaranteed)
    printAllPaths_() {
        for (v in _graph.values) {
            v.printPath()
            System.print()
        }
        System.print()
    }

    // Prints a path from the source to the specified vertex
    printPath(endName) {
        if (!_graph.containsKey(endName)) {
            System.print("Graph doesn't contain end vertex '%(endName)'")
            return
        }
        System.write(_directed ? "Directed   : " : "Undirected : ")
        _graph[endName].printPath()
        System.print()
        if (_showAllPaths) printAllPaths_() else System.print()
    }
}

var GRAPH = [
    Edge.new("a", "b", 7),
    Edge.new("a", "c", 9),
    Edge.new("a", "f", 14),
    Edge.new("b", "c", 10),
    Edge.new("b", "d", 15),
    Edge.new("c", "d", 11),
    Edge.new("c", "f", 2),
    Edge.new("d", "e", 6),
    Edge.new("e", "f", 9)
]

var START = "a"
var END   = "e"

var g = Graph.new(GRAPH, true, false)  // directed
g.dijkstra(START)
g.printPath(END)

g = Graph.new(GRAPH, false, false)     // undirected
g.dijkstra(START)
g.printPath(END)
