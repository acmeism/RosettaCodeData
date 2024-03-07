import "./seq" for Stack
import "./dynamic" for Tuple

class Node {
    construct new(n) {
        _n = n
        _index = -1   // -1 signifies undefined
        _lowLink = -1
        _onStack = false
    }

    n           { _n }
    index       { _index }
    index=(v)   { _index = v }
    lowLink     { _lowLink }
    lowLink=(v) { _lowLink = v }
    onStack     { _onStack }
    onStack=(v) { _onStack = v }

    toString    { _n.toString }
}

var DirectedGraph = Tuple.create("DirectedGraph", ["vs", "es"])

var tarjan = Fn.new { |g|
    var sccs = []
    var index = 0
    var s = Stack.new()

    var strongConnect // recursive closure
    strongConnect = Fn.new { |v|
        // Set the depth index for v to the smallest unused index
        v.index = index
        v.lowLink = index
        index = index + 1
        s.push(v)
        v.onStack = true

        // consider successors of v
        for (w in g.es[v.n]) {
            if (w.index < 0) {
                // Successor w has not yet been visited; recurse on it
                strongConnect.call(w)
                v.lowLink = v.lowLink.min(w.lowLink)
            } else if (w.onStack) {
                // Successor w is in stack s and hence in the current SCC
                v.lowLink = v.lowLink.min(w.index)
            }
        }

        // If v is a root node, pop the stack and generate an SCC
        if (v.lowLink == v.index) {
            var scc = []
            while (true) {
                var w = s.pop()
                w.onStack = false
                scc.add(w)
                if (w == v) break
            }
            sccs.add(scc)
        }
    }

    for (v in g.vs) if (v.index < 0) strongConnect.call(v)
    return sccs
}

var vs = (0..7).map { |i| Node.new(i) }.toList
var es = {
    0: [vs[1]],
    2: [vs[0]],
    5: [vs[2], vs[6]],
    6: [vs[5]],
    1: [vs[2]],
    3: [vs[1], vs[2], vs[4]],
    4: [vs[5], vs[3]],
    7: [vs[4], vs[7], vs[6]]
}
var g = DirectedGraph.new(vs, es)
var sccs = tarjan.call(g)
System.print(sccs.join("\n"))
